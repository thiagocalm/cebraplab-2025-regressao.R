options(scipen = 9999999)
rm(list = ls())
gc()
getwd()

# pacotes

library(pacman)
p_load(tidyverse, arrow)

# lendo dados

dados <- read_parquet(file.path("dia 2","pratica","base_violencia_desigualdade.parquet"))
df_pop_2010 <- read_parquet(file.path("dia 2","pratica","pop_2010_indicadores.parquet"))

# Filtrando dados ano 2015:2018

dados <- dados |>
  filter(ano %in% 2015:2018)

# tratamento de variaveis

cods_uf <- tibble(cod = c("11","12","13","14","15","16","17","21","22","23","24","25","26","27",
                          "28","29","31","32","33","35","41","42","43","50","51","52","53"),
                  names = c("Rondônia","Acre","Amazonas", "Roraima","Pará","Amapá","Tocantins","Maranhão",
                            "Piauí", "Ceará","Rio Grande do Norte","Paraíba","Pernambuco","Alagoas","Sergipe",
                            "Bahia","Minas Gerais","Espírito Santo","Rio de Janeiro","São Paulo","Paraná","Santa Catarina",
                            "Rio Grande do Sul","Mato Grosso do Sul","Mato Grosso","Goiás","Distrito Federal"))


dados <- dados |>
  mutate(
    uf = factor(uf, levels = cods_uf$cod, labels = cods_uf$names),
    regiao = factor(regiao, levels = c(1:5), labels = c("Norte","Nordeste","Sudeste","Sul","Centro-Oeste")),
    tamanho_pequeno = case_when(pop_faixas <= 3 ~ "Sim", TRUE ~ "Não"),
    pop_faixas = factor(
      pop_faixas,
      levels = 1:6,
      labels = c("Até 4.999","5.000-9.999","10.000-24.999","25.000-49.999","50.000-99.999","A partir de 100.000")
    )
  )

# juntando dados

dados <- dados %>%
  left_join(
    df_pop_2010 %>%
      mutate(
        cd_municipio_6digitos = as.numeric(str_sub(codigo_geografico, 1,6)),
        regiao = str_sub(codigo_geografico, 1,1),
        uf = str_sub(codigo_geografico, 1,2),
        uf = factor(uf, levels = cods_uf$cod, labels = cods_uf$names),
        prop_pop_negra_jovem = prop_pop_negra_jovem/100
      ) %>%
      select(-c(nivel_geografico, codigo_geografico, regiao)),
    by = c("uf","cd_municipio_6digitos"),
    keep = FALSE
  )

# selecionando variaveis

colnames(dados)

variaveis <- c("ano","regiao","pop_faixas","tamanho_pequeno","indicador_em","indicador_acesso_esgoto",
               "indicador_pbf","indicador_renda_outras_fontes","indicador_desocupados","indicador_informalidade",
               "indicador_pop_rural")

dados <- dados |>
  select(all_of(variaveis))

# filtrando para não ter 0 para esgoto

dados <- dados |>
  filter(indicador_acesso_esgoto > 0) |>
  na.omit()

# renomeando variaveis

dados <- dados |>
  select(
    ano, regiao, pop_faixas, tamanho_pequeno, 'em' = indicador_em, 'acesso_esgoto' = indicador_acesso_esgoto,
    'pbf' = indicador_pbf, 'desocupados' = indicador_desocupados, 'informalidade' = indicador_informalidade,
    indicador_pop_rural
  ) |>
  mutate(
    municipio_rural = case_when(indicador_pop_rural >= 40 ~ "Rural", TRUE ~ "Urbano")
  ) |>
  select(-tamanho_pequeno, -indicador_pop_rural)


# Exportacao dos dados ----------------------------------------------------

write_csv2(dados,file.path("dia 2","pratica","dados_acesso_esgoto.csv"))
