# Base image com Ruby
FROM ruby:3.2

# Define o diretório de trabalho
WORKDIR /app

# Instala dependências do sistema operacional
RUN apt-get update -qq && apt-get install -y build-essential

# Copia o Gemfile e Gemfile.lock para instalar as dependências
COPY Gemfile Gemfile.lock lol-wrapper.gemspec ./

# Instala gems no sistema
RUN bundle install

# Copia o restante do código da gem
COPY . .

# Comando padrão
CMD ["bash"]
