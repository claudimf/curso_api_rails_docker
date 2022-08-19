Configurar email

1° Gerar mailer:
```sh
docker-compose run --rm web rails g mailer contact birthday_report
```

2° No arquivo API/app/mailers/contact_mailer.rb configure o método 'birthday_report':
```sh
def birthday_report
  user_email = params[:user_email]
  @report = params[:report]
  @parsed_date = "#{@params[:reference_date].to_date.strftime("%d/%m")}/#{Time.now.year}"

  subject = "Birthday Report - #{@parsed_date}"

  mail(to: user_email, subject: subject)
end
```

3° No arquivo API/app/services/birthday_report_service.rb configure a classe 'BirthdayReportService':
```sh
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
```

3° No arquivo API/app/views/contact_mailer/birthday_report.html.erb configure o template de email:
```sh
<h1>Aniversariantes de <%= "#{@parsed_date}" %></h1>

<table>
  <thead>
    <tr>
      <th>Nome</th>
      <th>Idade</th>
    </tr>
  </thead>

  <tbody>
    <% @report.each do |aniversariante| %>
      <tr>
        <td><%= aniversariante[:name] %></td>
        <td><%= aniversariante[:age] %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

4° No arquivo API/spec/mailers/previews/contact_preview.rb vamos criar um preview template:
```sh
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
```

5° No arquivo API/spec/mailers/contact_spec.rb vamos descrever os testes unitários:
```sh
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
```

6° Instalar [Letter Opener Web](https://github.com/fgrehm/letter_opener_web)  

# Referências utilizadas
[1° Envio de Emails no Rails 5 [Guia Completo]](https://onebitcode.com/envio-de-emails-no-rails-5/)  
[2° Letter Opener Web](https://github.com/fgrehm/letter_opener_web)  