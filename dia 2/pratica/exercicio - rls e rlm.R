# ajustes gerais
options(scipen = 9999999)
rm(list = ls())

## pacotes necessarios
# instalando pacote de gerenciador de pacotes, pacman
ifelse(!require(pacman),install.packages("pacman"),require(pacman))
p_load(tidyverse, here) # importando pacote que usaremos, tidyverse

# importando dados
# setwd() # CONFIGURE O SEU DIRETORIO DE TRABALHO

# o comando 'here()' faz com que trabalhemos onde esta o nosso codigo ou projeto

diretorio <- file.path(here(),"dia 2","pratica")
# diretorio <- file.path(here())

dados <- read_csv2(file.path(diretorio,"dados_acesso_esgoto.csv"))


# Analise exploratoria da base de dados -----------------------------------

dados |> skim()


# Modelos -----------------------------------------------------------------

# modelo 1 - pbf

modelo1 <- lm(
  acesso_esgoto ~ pbf,
  data = dados
)

summary(modelo1)

# modelo 2 - informalidade


modelo2 <- lm(
  acesso_esgoto ~ pbf + informalidade,
  data = dados
)

summary(modelo2)

# modelo 3 - em

modelo3 <- lm(
  acesso_esgoto ~ pbf + em,
  data = dados
)

summary(modelo3)

# modelo 4 - todos juntos

modelo4 <- lm(
  acesso_esgoto ~ pbf + informalidade + em,
  data = dados
)

summary(modelo4)


# Adicionando variaveis qualitativas --------------------------------------

# modelo 5 - municipio_rural

modelo5 <- lm(
  acesso_esgoto ~ pbf + municipio_rural,
  data = dados
)

summary(modelo5)

# modelo 6 - todos juntos

modelo6 <- lm(
  acesso_esgoto ~ pbf + informalidade + em + municipio_rural,
  data = dados
)

summary(modelo6)
