require 'bundler/setup'
require 'telegram/bot'

ABOUT_TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc et ipsum in ex accumsan vulputate. Morbi diam quam, sollicitudin dictum magna id, pharetra tincidunt mi. Nam mollis tortor sit amet velit rhoncus feugiat. Nulla fermentum sed urna vel auctor. Fusce sit amet odio id nibh venenatis vehicula nec sit amet urna. Curabitur eget nunc ac risus molestie interdum. Vestibulum nisi neque, ornare ac interdum et, rutrum id ligula. Pellentesque at dui leo."
AREAS_JOBS = {
  "Медицина та охорона здоров'я" => ["лікарі", "медсестри", "фармацевти", "стоматологи", "фізіотерапевти", "психологи"],
  "ІТ та комп'ютерна технологія" => ["програмісти", "системні адміністратори", "мережеві інженери", "веб-розробники", "кібербезпека"],
  "Фінанси та банківська справа" => ["банкіри", "фінансові аналітики", "інвестиційні менеджери", "бухгалтери", "аудитори"],
  "Медіа та комунікації" => ["журналісти", "редактори", "письменники", "PR-менеджери", "графічні дизайнери", "відеоредактори"],
  "Освіта" => ["вчителі", "викладачі", "науковці", "тренери", "консультанти", "педагоги-дефектологи"],
  "Юриспруденція" => ["адвокати", "судді", "прокурори", "юристи", "нотаріуси", "юридичні консультанти"],
  "Інженерія" => ["інженери-механіки", "інженери-електрики", "інженери-будівельники", "інженери-проектувальники", "інженери-хіміки"],
  "Мистецтво та розваги" => ["актори", "музиканти", "художники", "режисери", "фотографи", "танцівники"],
  "Сфера послуг" => ["ресторани", "готелі", "туризм", "салони краси", "перукарні", "масажисти", "перекладачі", "організатори подій"],
  "Соціальна сфера" => ["соціальні працівники", "психологи", "реабілітологи", "соціальні працівники з дітьми", "роботники у сфері допомоги потребуючим"]
}

token = ''

def main_menu_markup
  kb = [
    [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'About Us', callback_data: 'about')],
    [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Areas', callback_data: 'areas')]
  ]
  Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      if message.data == 'about'
        bot.api.send_message(chat_id: message.from.id, text: ABOUT_TEXT, reply_markup: main_menu_markup)
        next
      end

      if message.data == 'areas'
        kb = AREAS_JOBS.keys.map { |area| [Telegram::Bot::Types::InlineKeyboardButton.new(text: area, callback_data: area)] }
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        bot.api.send_message(chat_id: message.from.id, text: 'Please choose an area:', reply_markup: markup)
        next
      end

      if AREAS_JOBS.keys.include?(message.data)
        jobs = AREAS_JOBS[message.data]
        bot.api.send_message(chat_id: message.from.id, text: jobs.join("\n"), reply_markup: main_menu_markup)
      end

    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: 'Please choose:', reply_markup: main_menu_markup)
      end
    end
  end
end