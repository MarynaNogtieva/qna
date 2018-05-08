class DailyMailer < ApplicationMailer
  # def notifier(question, user)
  #   @greeting = "Hi #{user.email} !"
  #   @question = question
  #   mail to: user.email
  # end

  def digest
    @greeting = "Hi"
    mail to: 'to@example.org'
  end
end
