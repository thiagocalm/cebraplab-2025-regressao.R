#' VARIAVEIS QUE VAMOS CRIAR!
#' dependente: se o domicilio tinha crianca de 0-3 anos ou nao
#' independentes (vamos usar as informacoes da pessoa responsavel do domicilio)
#' - rendimento per capita domiciliar
#' - idade
#' - sexo
#' - numero de pessoas no domicilio
#' - escolaridade (baixa, media e alta)
#' - estava ocupado ou nao
#' - raca (negro - ppi - ou branco)

options(scipen = 9999999)
rm(list = ls())
gc()
getwd()

# pacotes

library(pacman)
p_load(tidyverse, arrow)

# lendo dados

dados <- read_parquet(file.path("dia 4","pratica","pnadc_2020_visita_5.parquet"))

# Filtrando dados para uf de ACRE

dados <- dados |>
  filter(
    uf == 12
  )

## variaveis

# id variables

dados <- dados |>
  mutate(
    id_dom = as.numeric(paste0(upa, v1008, v1014)),
    id_pes = as.numeric(paste0(upa, v1008, v1014, v2003))
  )

# filho 0-3

dados <- dados |>
  mutate(
    idade_3 = case_when(v2009 %in% 0:3 ~ 1, TRUE ~ 0)
  ) |>
  mutate(
    crianca_03 = max(idade_3),
    .by = id_dom
  ) |>
  mutate(
    crianca_03 = factor(crianca_03, levels = c(0,1), labels = c("NaoTem","Tem"))
  )


# idade

dados <- dados |>
  mutate(
    idade = mean(v2009),
    .by = id_dom
  )

# sexo

dados <- dados |>
  mutate(
    sexoF = case_when(v2007 == 2 ~ 1, TRUE ~ 0)
  ) |>
  mutate(
    sexoF = factor(sexoF, levels = c(0,1), labels = c("Masculino","Feminino"))
  )

# raca

dados <- dados |>
  mutate(
    racaPPI = case_when(v2010 %in% c(2,4,5) ~ 1, TRUE ~ 0)
  ) |>
  mutate(
    racaPPI = factor(racaPPI, levels = c(0,1), labels = c("naoPPI","PPI"))
  )

# rendimento domiciliar per capita

dados <- dados |>
  mutate(
    rendimento = vd5002
  )

# ln(rendimento)

dados <- dados |>
  mutate(
    rendimentoLN = case_when(rendimento == 0 ~ 0.1, TRUE ~ rendimento)
  ) |>
  mutate(rendimentoLN = log(rendimentoLN))

# ocupado

dados <- dados |>
  mutate(
    ocupacao = case_when(
      vd4002 == 1 ~ 1, # ocupado
      TRUE ~ 0
    )
  ) |>
  mutate(
    ocupacao = factor(ocupacao, levels = c(0,1), labels = c("NaoOcupado","Ocupado"))
  )

# escolaridade

dados <- dados |>
  mutate(
    escolaridade = case_when(
      vd3004 <= 2 ~ 1, # baixo
      vd3004 %in% 3:5 ~ 2, # medio
      vd3004 > 5 ~ 3 # alto
    )
  ) |>
  mutate(
    escolaridade = factor(escolaridade, levels = c(1,2,3), labels = c("Baixo","Medio","Alto"))
  )

# numero de pessoas no domcilio

dados <- dados |>
  mutate(
    pessoasN = vd2003
  )

## selecionando variaveis

dados <- dados |>
  filter(v2003 == 1) |>
  select(id_dom, crianca_03, idade, sexoF, racaPPI, rendimento,rendimentoLN, ocupacao, escolaridade, pessoasN)

# Exportacao dos dados ----------------------------------------------------

write_csv2(dados,file.path("dia 4","pratica","dados_oferta_creche.csv"))
