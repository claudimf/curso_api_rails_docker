class DailyReportWorker
  include Sidekiq::Worker

  def perform()                     
    puts 'Iniciando'
    
    contact = Contact.first
    user_email = contact.user.email
    report = BirthdayReportService.new(
      contact.user.id, 
      contact.birthday
    ).perform

    puts 'Finalizado'
  end  
end
