Criar e testar uma classe de serviço

Criar um atributo "data de nascimento" na tabela Contacts:

1° Gerar migração:
```sh
docker-compose run --rm web rails g migration add_birthday_to_contacts birthday:date
```

2° Criar migrações:
```sh
docker-compose run --rm web rails db:migrate
```

3° Criar método na classe Contact para exibir a informação resumida:
```sh
def resume_info
  {
    name: name,
    age: Time.now.to_date.year - birthday.year
  }
end
```

4° Criar arquivo de serviço no endereço API/app/services/birthday_report_service.rb:
```sh
class BirthdayReportService

  def initialize(user_id, reference_date)
    @user = User.find(user_id)
    @reference_date = reference_date
  end

  def perform
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

# Referências utilizadas
[1° Using Service Objects in Ruby on Rails](https://blog.appsignal.com/2020/06/17/using-service-objects-in-ruby-on-rails.html)  
[2° Rails Service Objects: A Comprehensive Guide](https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial)  
[3° Refactoring Your Rails App With Service Objects](https://www.honeybadger.io/blog/refactor-ruby-rails-service-object/)  