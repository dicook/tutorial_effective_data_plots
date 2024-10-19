#| label: libraries-for-participants
library(tidyverse)
library(colorspace)
library(patchwork)
library(broom)
library(palmerpenguins)
library(ggbeeswarm)
library(vcd)
library(nullabor)
library(MASS)
library(colorspace)
library(conflicted)
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::select)
conflicts_prefer(dplyr::slice)
conflicts_prefer(dplyr::rename)
conflicts_prefer(dplyr::mutate)
conflicts_prefer(dplyr::summarise)

# Exercise 1
file = "data/2021Census_G33_VIC_LGA.csv"
hh_income <- read_csv(file)
ggplot(hh_income) +
  geom_histogram(
    aes(Tot_Family_households))
ggplot(hh_income) +
  geom_histogram(
    aes(Tot_Non_family_households))

# Solution code: TRY NOT TO LOOK!
#
#
#
#
#
#
hh_tidy <- hh_income |>
  select(LGA_CODE_2021,
         Tot_Family_households,
         Tot_Non_family_households) |>
  pivot_longer(cols=contains("Tot"),
               names_to="hh_type",
               values_to="count") |>
  mutate(hh_type = str_remove(hh_type, "Tot_")) |>
  mutate(hh_type = str_remove(hh_type, "_households")) |>
  mutate(hh_type = str_remove(hh_type, "_family"))
ggplot(hh_tidy, aes(x=count)) +
  geom_histogram() +
  facet_wrap(~hh_type, ncol=1)
ggplot(hh_tidy, aes(x=count,
                    colour=hh_type,
                    fill=hh_type)) +
  geom_density(alpha=0.5) +
  scale_color_discrete_divergingx() +
  scale_fill_discrete_divergingx()
ggplot(hh_tidy, aes(x=hh_type,
                    y=count)) +
  geom_boxplot()
ggplot(hh_tidy, aes(x=hh_type,
                    y=count)) +
  geom_quasirandom()

#
hhi_check <- hh_income |>
  select(LGA_CODE_2021,
         contains("_Tot"), -Tot_Tot) |>
  pivot_longer(cols=contains("Tot"),
               names_to="income_cat",
               values_to="count") |>
  group_by(LGA_CODE_2021) |>
  mutate(p = count/sum(count)) |>
  dplyr::filter(!(income_cat %in%
                    c("Partial", "All", "Negative"))) |>
  summarise(sp = sum(p))

#
hhi_tidy <- hh_income |>
  select(LGA_CODE_2021,
         contains("_Tot"), -Tot_Tot) |>
  pivot_longer(cols=contains("Tot"),
               names_to="income_cat",
               values_to="count") |>
  mutate(income_cat = str_remove(income_cat, "_Tot")) |>
  mutate(income_cat = str_remove(income_cat, "HI_")) |>
  mutate(income_cat = str_remove(income_cat, "_Nil_income")) |>
  mutate(income_cat = str_remove(income_cat, "_income_stated")) |>
  mutate(income_cat = str_remove(income_cat, "_incomes_not_stated")) |>
  group_by(income_cat) |>
  mutate(prop = count/sum(count)) |>
  dplyr::filter(!(income_cat %in%
                    c("Partial", "All", "Negative"))) |>
  separate(income_cat, into=c("cmin", "cmax")) |>
  mutate(cmax = str_replace(cmax, "more", "5000")) |>
  mutate(income = (as.numeric(cmin) +
                     as.numeric(cmax))/2) |>
  select(-cmin, cmax)

hhi_tidy |>
  dplyr::filter(LGA_CODE_2021 %in%
                  sample(unique(hhi_tidy$LGA_CODE_2021), 8)) |>
  ggplot(aes(x=income, y=count)) +
  facet_wrap(~LGA_CODE_2021, ncol=4) +
  geom_line()
