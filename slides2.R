#| label: libraries-for-participants
library(tidyverse)
library(colorspace)
library(patchwork)
library(broom)
library(palmerpenguins)
library(nullabor)
library(dslabs) # For stars data

#| fig-width: 8
#| fig-height: 5.5
#| out-width: 90%
set.seed(357)
ggplot(lineup(null_dist("temp", "exp",
                        list(rate = 1 / mean(dslabs::stars$temp))),
                        stars, n=15),
       aes(x=temp)) +
  geom_density(fill="black", alpha=0.7) +
  facet_wrap(~.sample, ncol=5, scales="free") +
  theme(axis.title = element_blank(),
        axis.text = element_blank())

# Make alternative lineups
ggplot(lineup(null_dist("temp", "exp",
  list(rate = 1 /
         mean(dslabs::stars$temp))),
  stars, n=15), aes(x=temp)) +
  geom_density(fill="black", alpha=0.7) +
  facet_wrap(~.sample, ncol=5, scales="free") +
  theme(axis.title = element_blank(),
        axis.text = element_blank())
ggplot(lineup(null_dist("temp", "exp",
  list(rate = 1 /
         mean(dslabs::stars$temp))),
  stars, n=15), aes(x=temp)) +
  geom_histogram(bins = 15) +
  facet_wrap(~.sample, ncol=5, scales="free") +
  theme(axis.title = element_blank(),
        axis.text = element_blank())
ggplot(lineup(null_dist("temp", "exp",
  list(rate = 1 /
         mean(dslabs::stars$temp))),
  stars, n=15), aes(x=.sample, y=temp)) +
  scale_x_continuous("sample", breaks=1:15) +
  geom_quasirandom() +
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank())

