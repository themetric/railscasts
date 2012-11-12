class Mailer < ActionMailer::Base
  def feedback(message)
    @message = message
    mail :to => "marklinstop@gmail.com", :from => @message.email, :subject => "MarklinStop Feedback from #{@message.name}"
  end

  def comment_response(comment, user)
    @comment = comment
    @user = user
    mail :to => @user.email, :from => "marklinstop@gmail.com", :subject => "Comment Response on MarklinStop"
  end
end
