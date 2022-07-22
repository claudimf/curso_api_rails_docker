Fazendo anotações no modelo      

No seu Gemfile no grupo de desenvolvimento e teste adicione a gema annotate:
```sh
group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'annotate'
end
```

Instale a gema:
```sh
docker-compose run --rm web rails g annotate:install
```

Será gerado o arquivo lib/tasks/auto_annotate_models.rake com as configurações do pacote.

Faça anotação nos seus modelos utilizando o comando "bundle exec" para resolver o conflito de incompatibilidade com a versão anterior do tzinfo:
```sh
docker-compose run --rm web bundle exec annotate --models
```

# Referências utilizadas
[1° Ruby on Rails - 6 MVC and You](https://github.com/ctran/annotate_models)  