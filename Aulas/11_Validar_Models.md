Validar Models

No arquivo Gemfile no grupo de teste e desenvolvimento adicione o byebug para que possamos debugar a aplicação:
```sh
group :development, :test do
...
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end
```
Apague e recrie o arquivo Gemfile.lock:
```sh
rm -rf Gemfile.lock
touch Gemfile.lock
docker-compose build
```

Crie o arquivo spec/support/factory_bot.rb:
```sh
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

Crie o arquivo spec/models/user_spec.rb e adicione:
```sh
require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'has a valid factory' do
    let(:user) { create(:user) }

    it 'it gets valid' do
      expect(user.valid?).to eq true
    end

    it 'it gets created' do
      expect(user.new_record?).to eq false
    end
  end

  describe 'validations' do
    context 'have_many' do
      it { should have_many(:contacts).dependent(:destroy) }
    end
  end

end
```

Crie o arquivo spec/models/contact_spec.rb e adicione:
```sh
require 'rails_helper'

RSpec.describe Contact, type: :model do

  describe 'has a valid factory' do
    let(:contact) { create(:contact) }

    it 'it gets valid' do
      expect(contact.valid?).to eq true
    end

    it 'it gets created' do
      expect(contact.new_record?).to eq false
    end
  end

  describe 'validations' do
    context 'of attributes' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:user) }
    end
    context 'belong_to' do
      it { should belong_to(:user) }
    end
  end

end
```

Faça anotação do seu arquivo rodando:
```sh
docker-compose run --rm web bundle exec annotate --models
```

# Referências utilizadas
[1° Debugando com o ByeBug](https://medium.com/automa%C3%A7%C3%A3o-com-batista/debugando-com-o-byebug-2257ae37c3e)  
[2° Gem Byebug](https://github.com/deivid-rodriguez/byebug)  
[3° Shoulda Matchers validations](https://matchers.shoulda.io/)  
[4° Shoulda Matchers](https://makandracards.com/makandra/38645-testing-activerecord-validations-with-rspec)  