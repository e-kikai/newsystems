#! ruby -Ku
require 'mail'
 
Mail.defaults do
  delivery_method :smtp, {
    :address => "smtp.gmail.com", # smtpサーバのアドレス
    :port => 587,
    :user_name => "bata44883", # smtpサーバに対するユーザ名
    :password => "bob2002", # smtpサーバに対するパスワード
    :authentication => :plain
  }
end
 
mail = Mail.new do
  to 'bata44883@gmail.com'
  from 'bata44883@gmail.com'
  subject 'test mailテストメール'
  body "test bodyテストメールです\ntestテストです"
end
 
mail.charset = 'utf-8'
mail.deliver!
