require "rails_helper"

RSpec.describe ContactMailer, type: :mailer do
  
  describe "birthday_report" do
    let(:user) { create(:user) }
    let(:contact_list) { create_list(:contact, 3, user: user) }
    let(:parsed_date) { "#{contact_list.first.birthday.strftime("%d/%m")}/#{Time.now.year}" }
    let(:mail) { 
      ContactMailer.with(
        user_email: user.email, 
        report: BirthdayReportService.new(
          user.id,
           contact_list.first.birthday
          ).generate_report,
        reference_date: contact_list.first.birthday
      ).birthday_report
     }

    context 'verifying headers rendered' do
      it "should render 'subject'" do
        subject = "Birthday Report - #{parsed_date}"

        expect(mail.subject).to eq(subject)
      end

      it "should render 'to'" do
        expect(mail.to).to eq([user.email])
      end

      it "should render 'from'" do
        expect(mail.from).to eq(["from@example.com"])
      end
    end

    it "renders the body" do
      title = "Aniversariantes de #{parsed_date}"
      expect(mail.body.encoded).to match("Nome")
      expect(mail.body.encoded).to match("Idade")
    end
  end

end
