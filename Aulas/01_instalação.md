Crie o arquivo Dockerfile:
```sh
FROM ruby
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt install libpq-dev
RUN apt install build-essential
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY . /app
RUN bundle install
RUN bundle update
RUN gem update --system

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
```
Crie o arquivo docker-compose.yml:
```sh
version: "3.7"
services:
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: password
  web:
    build: .
    command: bash -c "bundle && rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/app
    ports:
      - "3000:3000"
    depends_on:
      - db
```
Crie o arquivo entrypoint.sh:
```sh
#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
```
Crie o arquivo Gemfile:
```sh
touch Gemfile
```
No arquivo Gemfile, adicione:
```sh
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', '~> 7.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use Puma as the app server
gem 'puma', '~> 5.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
```
Crie o arquivo Gemfile.lock:
```sh
touch Gemfile.lock
```
Ao se criar arquivos dentro do contâiner Docker o proprietário para edição se torna o contâiner, sendo assim você precisará rodar o comando abaixo para alterar essas permissões e você poder editar:
```sh
sudo chown -R $USER:$USER .
```
Criar o projeto:
```sh
docker-compose run --no-deps web rails new . --api --database=postgresql
```
Configurar o banco de dados, entrando no arquivo 'API/config/database.yml':
```sh
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password: password
  pool: 5

development:
  <<: *default
  database: app_development

test:
  <<: *default
  database: app_test
```

Entrar na bash no projeto:
```sh
docker-compose run --rm web bash
```
Instalar as gemas:
```sh
bundle
```
Criar o banco:
```sh
rails db:create
```
Sair da bash do projeto:
```sh
Ctrl + D
```
Subir o projeto:
```sh
docker-compose run --rm --service-ports web
```
Verificar as o projeto na rota [http://localhost:3000](http://localhost:3000)  
Verificar rotas do projeto [http://localhost:3000/rails/info/routes](http://localhost:3000/rails/info/routes)  
