Criar arquivo e coloque o seguinte conteúdo:
```sh
module Api::V1
  class ApiController < ApplicationController
  end
end
```

No arquivo API/config/application.rb adicione o seguinte conteúdo:
```sh
config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*',
    headers: :any,
    methods: %i(get post put patch delete options head)
  end
end
config.middleware.use Rack::Attack
```
Crie um arquivo chamado rack_attack.rb no seu API/config/initializers/rack_attack.rb e coloque nele:
```sh
class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Allow all local traffic
  safelist('allow-localhost') do |req|
      '127.0.0.1' == req.ip || '::1' == req.ip
  end

  # Allow an IP address to make 10 requests every 10 seconds

  throttle('req/ip', limit: 5, period: 5) do |req|
      req.ip
  end

  # Throttle login attempts by email address
  #throttle("logins/email", limit: 5, period: 20.seconds) do |req|
  #  if req.path == '/users/sign_in' && req.post?
  #    req.params['email'].presence
  #  end
  #end
end
```
Adicione as gemas necessárias para o rack-cors e rack-attack, então no arquivo Gemfile adicione:
```sh
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'rack-attack'
```
Instale as novas gemas:
```sh
docker-compose run --rm web bundle
```