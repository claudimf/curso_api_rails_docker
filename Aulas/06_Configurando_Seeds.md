Configurando Seeds    

No seu Gemfile no grupo de desenvolvimento e teste adicione a gema annotate:
```sh
group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'annotate'
  gem 'rspec-rails', '>= 5.1.2'
  gem 'faker'
  gem 'factory_bot_rails'
end
```

Autorizar arquivos para o usuário local:
```sh
sudo chown -R $USER:$USER .
```

Entre na bash:
```sh
docker-compose run --rm web bash
```

Instale as novas gemas:
```sh
bundle
```

Instale a o generator:
```sh
rails generate rspec:install
```

Após instalar irá gerar os seguintes arquivos:
```sh
.rspec
spec
spec/spec_helper.rb
spec/rails_helper.rb
```

No arquivo spec/rails_helper.rb, adicione o faker("require 'faker'"):
```sh
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'faker'
....
```

Agora é hora de criar a factory "users"(spec/factories/users.rb), dentro do arquivo adicione:
```sh
FactoryBot.define do
  factory :user, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "super_secret_123" }
  end
end
```

Depois crie a factory "contacts"(API/spec/factories/contacts.rb):
```sh
FactoryBot.define do
  factory :contact, class: Contact do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    description { Faker::Lorem.sentence }
    association :user, factory: :user
  end
end
```

Finalmente iremos editar o seeds(db/seeds.rb):
```sh
ActiveRecord::Base.transaction do
  numero_de_contatos = 5

  puts 'Criando primeiro usuário'
  user_1 = FactoryBot.create(:user)

  puts 'Criando lista de contato para o primeiro usuário'
  FactoryBot.create_list(:contact, numero_de_contatos, user: user_1)

  puts 'Criando o segundo usuário e sua lista de contatos'
  FactoryBot.create_list(:contact, numero_de_contatos, user_id: FactoryBot.create(:user).id)

  puts 'Gerado os novos registros'
end
```

Para recriar o banco e aplicar os seeds, rode:
```sh
docker-compose run --rm web rails db:drop db:create db:migrate db:seed
```

# Referências utilizadas
[1° rspec-rails](https://github.com/rspec/rspec-rails)  
[2° Ruby on Rails - 6 MVC and You](https://github.com/faker-ruby/faker)  
[3° Faker](https://github.com/thoughtbot/factory_bot_rails)  
[4° Working Effectively with Data Factories Using FactoryBot](https://semaphoreci.com/community/tutorials/working-effectively-with-data-factories-using-factorygirl)  
[5° Migrations and Seed Data](https://guides.rubyonrails.org/v5.1/active_record_migrations.html#migrations-and-seed-data)  
[6° Seeds: populando seu banco de dados](https://www.campuscode.com.br/conteudos/seeds-populando-seu-banco-de-dados)  
[7° Seeding a Database in Ruby on Rails](https://ninjadevel.com/seeding-database-ruby-on-rails/)  