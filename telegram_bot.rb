require 'bundler/setup'
require 'telegram/bot'

ABOUT_TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc et ipsum in ex accumsan vulputate. Morbi diam quam, sollicitudin dictum magna id, pharetra tincidunt mi. Nam mollis tortor sit amet velit rhoncus feugiat. Nulla fermentum sed urna vel auctor. Fusce sit amet odio id nibh venenatis vehicula nec sit amet urna. Curabitur eget nunc ac risus molestie interdum. Vestibulum nisi neque, ornare ac interdum et, rutrum id ligula. Pellentesque at dui leo."
FIELDS = %w[Medicine Police Education Engineering]
PROFESSIONS = %w[Programmer Driver Doctor Engineer]

token = ''

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    kb = [
      [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'About us', callback_data: 'about')],
      [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Fields of activity', callback_data: 'fields')],
      [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Professions', callback_data: 'professions')]
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

    case message
    when Telegram::Bot::Types::CallbackQuery
      case message.data
      when 'about'
        bot.api.send_message(chat_id: message.from.id, text: ABOUT_TEXT)
        bot.api.send_message(chat_id: message.from.id, text: 'Please choose again:', reply_markup: markup)
      when 'fields'
        bot.api.send_message(chat_id: message.from.id, text: FIELDS.join("\n"))
        bot.api.send_message(chat_id: message.from.id, text: 'Please choose again:', reply_markup: markup)
      when 'professions'
        bot.api.send_message(chat_id: message.from.id, text: PROFESSIONS.join("\n"))
        bot.api.send_message(chat_id: message.from.id, text: 'Please choose again:', reply_markup: markup)
      end
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: 'Please choose:', reply_markup: markup)
      end
    end
  end
end
