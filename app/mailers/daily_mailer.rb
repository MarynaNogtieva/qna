class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi #{user.email} !"
    # @question = question
    mail to: user.email
  end
end
