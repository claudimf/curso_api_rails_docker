Validar Factories

No seu API/spec/rails_helper.rb adicione:
```sh
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FactoryBot do
  it { FactoryBot.lint(traits: true) }
end
```

Vá no terminal e rode os tests de formal geral:
```sh
docker-compose run --rm web rspec
```

Ou de forma específica:
```sh
docker-compose run --rm web rspec spec/factories_spec.rb
```

# Referências utilizadas
[1° How to Lint FactoryBot Factories with RSpec](https://mikerogers.io/2019/11/05/how-to-test-factory-bot-factories-with-rspec)  
[2° Working Effectively with Data Factories Using FactoryBot](https://semaphoreci.com/community/tutorials/working-effectively-with-data-factories-using-factorygirl)  
[3° Usando Traits com FactoryBot](https://www.campuscode.com.br/conteudos/usando-traits-com-factorybot)  