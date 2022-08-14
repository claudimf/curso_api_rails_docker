Configurando Database Cleaner    

No seu Gemfile no grupo de teste adicione a gema database_cleaner-active_record:
```sh
group :test do
  gem 'database_cleaner-active_record'
end
```

No arquivo API/spec/rails_helper.rb adiciona o diretório support:
```sh
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
```

Crie o arquivo API/spec/support/database_cleaner.rb e coloque:
```sh
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:all, :cache_context) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before do |example|
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after do |example|
    DatabaseCleaner.clean
  end

  config.after(:all, :cache_context) do
    DatabaseCleaner.clean
  end
end
```

# Referências utilizadas
[1° Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner)  