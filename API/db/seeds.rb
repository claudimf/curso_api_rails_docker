# frozen_string_literal: true

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
# Recriar banco
# docker-compose run --rm web rails db:drop db:create db:migrate db:seed