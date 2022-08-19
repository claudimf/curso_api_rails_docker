# frozen_string_literal:true

class BirthdayReportService

  def initialize(user_id, reference_date)
    @user = User.find(user_id)
    @reference_date = reference_date
  end

  def perform
    report = generate_report
    puts 'Enviar email'
    ContactMailer.with(
      user_email: @user.email, 
      report: report,
      reference_date: @reference_date
    ).birthday_report.deliver_now
    puts 'Email enviado'

    return
  end

  def generate_report
    puts 'Gerando report'
    result = []
    reference_date = @reference_date.strftime("%d/%m")

    @user.contacts.each do |contact|
      if contact.birthday.present? && contact.birthday.strftime("%d/%m") == reference_date
        result << contact.resume_info
      end
    end

    return result
  end

end
