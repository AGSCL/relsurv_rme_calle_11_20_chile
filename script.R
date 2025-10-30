smr_resumen <- tibble::tibble(
  Criterio = c(
    "Total ajustado por grupos de edad y sexo",
    "Total ajustado por grupos de edad, sexo y año calendario",
    "Total ajustado por edad, sexo y año calendario",
    "Total ajustado por grupos de edad y sexo, por causas",
    "Total ajustado por grupos de edad y sexo, por causas",
    "Desagregado por edad, ajustando por sexo",
    "Desagregado por edad, ajustando por sexo",
    "Desagregado por edad, ajustando por sexo",
    "Desagregado por edad, ajustando por sexo",
    "Desagregado por edad, ajustando por sexo y año calendario",
    "Desagregado por edad, ajustando por sexo y año calendario",
    "Desagregado por edad, ajustando por sexo y año calendario",
    "Desagregado por edad, ajustando por sexo y año calendario",
    "Desagregado por sexo, ajustando por grupo de edad",
    "Desagregado por sexo, ajustando por grupo de edad",
    "Desagregado por sexo, ajustando por grupo de edad y año calendario",
    "Desagregado por sexo, ajustando por grupo de edad y año calendario",
    "Desagregado por sexo, ajustando por edad y año calendario",
    "Desagregado por sexo, ajustando por edad y año calendario"
  ),
  Categoría = c(
    NA, NA, NA,
    "externas", "no-externas",
    "18-29", "30-44", "45-59", "60-78",
    "18-29", "30-44", "45-59", "60-78",
    "Mujeres", "Hombres",
    "Mujeres", "Hombres",
    "Mujeres", "Hombres"
  ),
  Observado = c(172, 133, 132, 35, 137, 6, 38, 83, 45, 5, 36, 63, 29, 16, 156, 12, 121, 12, 120),
  Esperado = c(5187, 4017, 4013, 5187, 5187, 621, 2161, 1953, 451, 512, 1685, 1486, 333, 647, 4540, 498, 3519, 498, 3515),
  `Años-persona` = c(23, 17, 15, 4, 19, 1, 4, 10, 9, 0, 3, 7, 7, 1, 22, 1, 16, 1, 14),
  SMR = c(
    "7.45 (6.39–8.62)",
    "8.01 (6.72–9.45)",
    "9.01 (7.56–10.64)",
    "9.03 (6.36–12.36)",
    "7.11 (5.99–8.37)",
    "10.77 (4.28–21.82)",
    "10.79 (7.72–14.60)",
    "8.63 (6.91–10.63)",
    "4.79 (3.52–6.33)",
    "11.17 (4.00–24.00)",
    "13.55 (9.60–18.48)",
    "9.03 (6.98–11.44)",
    "4.44 (3.02–6.26)",
    "14.00 (8.21–22.02)",
    "7.11 (6.05–8.29)",
    "14.76 (7.91–24.76)",
    "7.66 (6.37–9.11)",
    "16.42 (8.79–27.53)",
    "8.62 (7.17–10.26)"
  )
)


# 1) Orden final (Totales arriba). Elimina la línea con `sections_order <- rev(sections_order)`
sections_order <- c(
  "Totales",
  "Por causas (aj. por sexo y edad)",
  "Edad (aj. por sexo)",
  "Sexo (aj. por grupo de edad)"
)

capitalize_first_letter_robust <- function(x) {
  # 1. Limpiar espacios al inicio y final
  x_clean <- trimws(x)
  
  # 2. Capitalizar la primera letra
  first_letter <- toupper(substring(x_clean, 1, 1))
  
  # 3. Tomar el resto de la cadena a partir del segundo caracter
  rest_of_string <- substring(x_clean, 2)
  
  return(paste0(first_letter, rest_of_string))
}


# --- (después de tu asignación manual de `smr_resumen$section <- c(...)`) ---

# 3) Mantener solo esas secciones y fijar el orden como factor
keep_sections <- sections_order
smr_resumen2 <- smr_resumen|>
  dplyr::rename("res"="Criterio", "label"="Categoría", "obs"="Observado", "exp"="Esperado", "py"="Años-persona")|>
  dplyr::filter(section %in% keep_sections) |>
  dplyr::mutate(section = factor(section, levels = sections_order))|> 
  dplyr::filter(!section %in% c("Total ajustado por grupos de edad, sexo y año calendario", "Total ajustado por edad, sexo y año calendario"))|> 
  dplyr::mutate(section= dplyr::case_when(grepl("causas",section)~"Por causas (aj. por sexo\ny grupos de edad)",
                                          TRUE~section))|> 
  dplyr::mutate(section= gsub("grupo de","grupos de", section))|> 
  dplyr::mutate(label = gsub("^Total", "", label))|>
  dplyr::mutate(label = sapply(label, capitalize_first_letter_robust))


sections_order <- c(
  "Totales",
  "Por causas (aj. por sexo\ny grupos de edad)",
  "Edad (aj. por sexo)",
  "Sexo (aj. por grupos de edad)"
)

# Create display
display_list <- list()
y <- 0
for (sec in sections_order) {
  header <- tibble(section = sec, label = NA_character_, obs = NA_real_, py = NA_real_, exp = NA_real_,
                   rme = NA_real_, lo = NA_real_, hi = NA_real_, is_header = TRUE, y = y)
  display_list <- append(display_list, list(header))
  y <- y + 1
  
  items <- smr_resumen2 %>% filter(section == sec)
  if (nrow(items) > 0) {
    items <- items %>% mutate(is_header = FALSE, y = seq(y, by = 1, length.out = n()))
    display_list <- append(display_list, list(items))
    y <- y + nrow(items)
  }
  y <- y + 0.2
}
display <- bind_rows(display_list)
df_plot  <- display %>% dplyr::filter(!is_header)
headers  <- display %>% dplyr::filter(is_header) %>% dplyr::arrange(y)

# Colors
# 2) Paleta sincronizada con los nombres EXACTOS
section_cols <- c(
  "Totales"                           = "#A17C6C80",
  "Por causas (aj. por sexo y edad)"  = "#906F0080",
  "Edad (aj. por sexo)"               = "#5FA9B380",
  "Sexo (aj. por grupo de edad)"      = "#D2A899"
)

# Calculate limits, start from 0.5
min_lo <- min(df_plot$lo, na.rm = TRUE)
max_hi <- max(df_plot$hi, na.rm = TRUE)
xmin <- 0.5  # Force start at 0.5
xmax <- exp(log(max_hi) + 0.0 * (log(max_hi) - log(min_lo)))

# Rects
rects <- headers %>%
  transmute(
    section,
    ymin = y + 0.4,
    ymax = lead(y) - 0.4
  )
rects$ymax[is.na(rects$ymax)] <- max(display$y, na.rm = TRUE) + 0.6
rects <- rects %>%
  mutate(xmin = xmin * 1.005,
         xmax = xmax / 1.005)

# Labels position (moved left)
x_left_lab <- xmin * 0.5  # Moved further left

cap_h <- 0.25

p2 <- ggplot() +
  geom_rect(data = rects,
            aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            inherit.aes = FALSE, fill = "#f7f7f7", color = NA, alpha = 0.6) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "#444444", linewidth = 1) +
  
  geom_segment(data = df_plot,
               aes(x = lo, xend = hi, y = y, yend = y, color = section),
               linewidth = 0.9) +
  geom_segment(data = df_plot,
               aes(x = lo, xend = lo, y = y - cap_h, yend = y + cap_h, color = section),
               linewidth = 0.9) +
  geom_segment(data = df_plot,
               aes(x = hi, xend = hi, y = y - cap_h, yend = y + cap_h, color = section),
               linewidth = 0.9) +
  
  geom_point(data = df_plot,
             aes(x = rme, y = y, fill = section, color = section),
             shape = 22, size=3,stroke = 0.6) +
  
  # Label over point with RME to 1 decimal, larger size
  geom_text(data = df_plot,
            aes(x = rme, y = y + 0.3, label = sprintf("%.1f", rme)),
            size = 5, color = "black", hjust = 0.5, vjust = 0) +
  
  geom_text(data = df_plot,
            aes(x = x_left_lab-.25, y = y, label = paste0("  ", label)),
            hjust = 0, vjust = 0.5, size = 3.6, color = "#222222", inherit.aes = FALSE) +
  
  geom_text(data = left_join(headers, rects[, c("section", "ymax")], by = "section") %>% mutate(y = ymax + .4),
            aes(x = x_left_lab-.25, y = y, label = section),
            hjust = 0, vjust = 0.5, fontface = "bold", size = 4.0, inherit.aes = FALSE) +
  
  scale_color_manual(values = section_cols, name = "Sección") +
  scale_fill_manual(values = section_cols, guide = "none") +
  #scale_size(range = c(2.6, 6.2), guide = "none") +
  
  scale_x_continuous(
    trans = scales::log_trans(base = exp(1)),
    breaks = c(0.5, 1, 2, 4, 8, 16),
    labels = function(x) format(x, big.mark = ".", decimal.mark = ",", trim = TRUE),
    expand = ggplot2::expansion(mult = c(0.3, 0.0))  # No expansion
  ) +
  coord_cartesian(xlim = c(0.5, xmax)) +  # Force xlim from 0.5
  labs(
    title = NULL,
    subtitle = NULL,
    x = "RME (IC 95%), escala logarítmica",
    y = NULL
  ) +
  theme_minimal(base_size = 15) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    plot.title.position = "plot",
    legend.position = "none"
  )

print(p2)