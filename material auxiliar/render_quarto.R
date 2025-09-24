# path
input_path = file.path(here::here(),"dia 4","slides")

quarto::quarto_render(input = file.path(input_path,"4. avaliacao de modelos e logit.qmd"))

pagedown::chrome_print(
  file.path(input_path,"4. avaliacao de modelos e logit.html"),
  options = list(
    printBackground = FALSE,
    preferCSSPageSize = FALSE,
    paperWidth = 8.3, paperHeight = 11.7,
    marginTop = 0.0, marginBottom = 0.0,
    marginLeft = 0.0, marginRight = 0.0
  )
)
