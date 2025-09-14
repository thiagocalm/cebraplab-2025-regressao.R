
# ajustes gerais
options(scipen = 99999)

## pacotes necessarios
# instalando pacote de gerenciador de pacotes, pacman
ifelse(!require(pacman),install.packages("pacman"),require(pacman))
p_load(tidyverse) # importando pacote que usaremos, tidyverse

# importando dados
base <- read_csv2("dados_correlacao.csv")
anos = seq(from = 2000,to = 2009,by = 1) # anos
label_margarina = "Consumo per capita de margarina nos EUA" # rótulo da variavel
label_divorcio = "Taxa de divórcio no estado de Maine (EUA)" # rótulo da variavel

# criando base de dados com essas informações
# obs: vamos criar uma base de classe 'tibble' por ser mais facil de trabalhar com pipelines

base <- as.tibble(base)

## Exploração dos dados
# Margarina X divorcio

# Como são duas variáveis contínuas, optarei por plotar ambas em um gráfico de dispersão

base |>
  ggplot() +
  aes(x = margarina, y = divorcio, color = anos) +
  geom_point( size = 4, alpha = .5) +
  labs(
    x = label_margarina,
    y = label_divorcio,
    caption = "Fonte: https://www.tylervigen.com/spurious/correlation/5920"
  ) +
  theme_classic() +
  theme(
    legend.title = element_blank(),
    axis.title.y = element_text(color = "grey33",face = "bold"),
    axis.title.x = element_text(color = "red4",face = "bold")
  )

## Análise de correlação entre as duas variáveis

cor.test(base$margarina, base$divorcio) # teste de correlação, default 'Pearson'

# Uau! Como explicar isso?
