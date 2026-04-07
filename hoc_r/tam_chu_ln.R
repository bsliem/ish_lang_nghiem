library(tidyverse)

start      <- function(x) { paste(x, "→ Án") }
calm       <- function(x) { paste(x, "→ Bất động") }
purify     <- function(x) { paste(x, "→ Thanh tịnh") }
power_up   <- function(x) { paste(x, "→ Uy lực") }
reinforce  <- function(x) { paste(x, "→ Kim cang") }
hold       <- function(x) { paste(x, "→ Trì") }
lock       <- function(x) { paste(x, "→ Kết") }
destroy    <- function(x) { paste(x, "→ Phá") }
complete   <- function(x) { paste(x, "→ Thành tựu") }

"Tâm" %>%
  start() %>%
  calm() %>%
  purify() %>%
  power_up() %>%
  reinforce() %>%
  hold() %>%
  lock() %>%
  destroy() %>%
  complete()

library(glue)
library(purrr)

chu <- tribble(
  ~id, ~han, ~viet, ~nghia,
  545, "唵", "Án", "Khởi tâm",
  546, "不動", "A na lệ", "Bất động",
  547, "清淨", "Tỳ xá đề", "Thanh tịnh",
  548, "威力", "Bệ ra", "Uy lực",
  549, "金剛", "Bạt xà ra", "Kim cang",
  550, "持", "Đà rị", "Trì",
  551, "結結", "Bàn đà bàn đà nể", "Kết",
  552, "金剛手破", "Bạt xà ra bán ni phấn", "Phá",
  553, "威攝破", "Hổ hồng đô lô ung phấn", "Phá sạch",
  554, "成就", "Ta bà ha", "Thành tựu"
)

cat("\n🧘‍♂️ BẮT ĐẦU TỤNG (console mode)\n\n")

walk(1:nrow(chu), function(i) {
  line <- chu[i,]
  
  cat(glue(
    "{line$id}. {line$viet}  ({line$han})  → {line$nghia}\n"
  ))
  
  Sys.sleep(0.7)  # nhịp tụng
})

cat("\n🌸 Hoàn tất – Thành tựu\n")