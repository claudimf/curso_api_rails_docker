Configurando Shoulda Matchers    

No seu API/spec/rails_helper.rb adicione:
```sh
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

# Referências utilizadas
[1° Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers)  
[2° Shoulda Matchers](https://matchers.shoulda.io/)  
[3° Documentação do Rspec no Relishapp](https://relishapp.com/rspec)  