# ContactMailer.with(invitation: self).birthday_report.deliver
class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.birthday_report.subject
  #
  def birthday_report
    user_email = params[:user_email]
    @report = params[:report]
    @parsed_date = "#{@params[:reference_date].to_date.strftime("%d/%m")}/#{Time.now.year}"

    subject = "Birthday Report - #{@parsed_date}"

    mail(to: user_email, subject: subject)
  end
end
