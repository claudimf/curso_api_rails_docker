# frozen_string_literal:true

class BirthdayReportService

  def initialize(user_id, reference_date)
    @user = User.find(user_id)
    @reference_date = reference_date
  end

  def perform

    ContactMailer.with(
      user_email: @user.email, 
      report: generate_report,
      reference_date: @reference_date
    ).birthday_report.deliver_now

    return
  end

  def generate_report
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
