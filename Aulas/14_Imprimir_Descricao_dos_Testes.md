Apresentar a descrição dos testes

Para apresentar a descrição dos testes quando se roda a suíte temos as seguintes alternativas:

1° Para todos os testes adicione no arquivo API/.rspec.
```sh
--color
--format documentation
```

2° Rodar apenas em arquivos específicos.
Formato:
```sh
docker-compose run --rm web rspec endereco_do_arquivo_de_testes --format documentation
```
Exemplo:
```sh
docker-compose run --rm web rspec spec/requests/contacts_spec.rb --format documentation
```

# Referências utilizadas
[1° Rspec - format option](https://relishapp.com/rspec/rspec-core/v/2-5/docs/command-line/format-option)  