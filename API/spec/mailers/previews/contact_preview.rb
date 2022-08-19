# Preview all emails at http://localhost:3000/rails/mailers/contact
class ContactPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/contact/birthday_report
  def birthday_report
    contact = Contact.first
    user_email = contact.user.email
    report = BirthdayReportService.new(
      contact.user.id, 
      contact.birthday
    ).generate_report

    ContactMailer.with(
      user_email: user_email, 
      report: report,
      reference_date: contact.birthday
    ).birthday_report
  end

end
