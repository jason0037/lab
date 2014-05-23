# encoding : utf-8
require 'net/smtp'
class SendMail< ActiveRecord::Base
  def self.send_mail(mail_to,token,user_id)
#    mail_content = 
#    mail_to= report_generate.user.try(:email)
    mail_from='longchuangemc@163.com' 
    mail=MailFactory.new 
    mail.encoding="GBK" #设置encoding
    mail.subject='开放大学开放教育数字实验平台-密码重置'
    mail.html="</font color=''>这是您在开放大学开放教育数字实验平台订阅的邮件</br>
                这是系统发送，请不要回复！
                <a href='http://101.226.163.150/lab_users/#{user_id}/reset_pass?reset_token=#{token}'>重置密码</a>
               </font>"
   
    Net::SMTP.start('smtp.163.com',25,"163.com","longchuangemc@163.com","qwer1234",'plain') do |smtp|
      smtp.send_message(mail.to_s,mail_from,mail_to)
    end
  end
end
