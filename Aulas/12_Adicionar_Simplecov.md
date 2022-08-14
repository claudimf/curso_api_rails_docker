Validar Models

No arquivo Gemfile.rb adicione:
```sh
group :test do
...
  gem 'simplecov', require: false
end
```

No arquivo spec_helper.rb adicione:
```sh
require 'simplecov'

unless ENV['DISABLE_COVERAGE'] ==  'true'
  SimpleCov.start 'rails'
end
```

No arquivo .gitignore adicione:
```sh
API/coverage/
```

Rode a suíte de testes:
```sh
docker-compose run --rm web rspec
```

Abra o arquivo do relatório de cobertura gerado(API/coverage/index.html) no seu Browser preferido

# Referências utilizadas
[1° SimpleCov — Gerando relatórios de cobertura de código para projetos Ruby](https://medium.com/@wdmeida/simplecov-an%C3%A1lise-de-cobertura-de-c%C3%B3digo-em-ruby-b310ec9a8c0a)  
