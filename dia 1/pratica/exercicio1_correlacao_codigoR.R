
# ajustes gerais
options(scipen = 99999)

# pacotes necessarios
library(pacman)
p_load(tidyverse)

# importando dados
margarina = c(8.2,7,6.5,5.3,5.2,4,4.6,4.5,4.2,3.7)
divorcio = c(5,4.7,4.6,4.4,4.3,4.1,4.2,4.2,4.2,4.1)
anos = seq(from = 2000,to = 2009,by = 1)
label_margarina = "Consumo per capita de margarina nos EUA"
label_divorcio = "Taxa de divórcio no estado de Maine (EUA)"

# criando base de dados com essas informações
# obs: vamos criar uma base de classe 'tibble' por ser mais facil de trabalhar com pipelines

base <- tibble(
  margarina,
  divorcio,
  anos
)



## plotando ambos em um mesmo gráfico

# plot graph of them here!!!!!!!

## Exploração dos dados
# Querosene X Esquilo

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
