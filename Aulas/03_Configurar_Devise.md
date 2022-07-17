Adicione as gemas necessárias para o rack-cors e rack-attack, então no arquivo Gemfile adicione:
```sh
gem 'devise'
```
Instale as novas gemas:
```sh
docker-compose run --rm web bundle
```

Em config/environments/development.rb coloque:
```sh
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

Instale as novas gemas:
```sh
docker-compose run --rm web rails generate devise:install
```

Crie a model User:
```sh
docker-compose run --rm web rails generate model User
```

Gerar a Devise para a classe User:
```sh
docker-compose run --rm web rails generate devise User
```

Adiciona o atributo 'name' a classe User:
```sh
docker-compose run --rm web rails g migration addNameToUser name:string
```

Autorizar arquivos para o usuário local:
```sh
sudo chown -R $USER:$USER .
```

Gerar migrações:
```sh
docker-compose run --rm web rails db:migrate
```

Adiciona o atributo 'authentication_token' a classe User:
```sh
docker-compose run --rm web rails g migration add_authentication_token_to_users "authentication_token:string{30}:uniq"
```

Autorizar arquivos para o usuário local:
```sh
sudo chown -R $USER:$USER .
```

Gerar migrações:
```sh
docker-compose run --rm web rails db:migrate
```