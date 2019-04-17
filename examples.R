### Dependencies----
# For within_ci.R
if (!require(dplyr)) {install.packages(dplyr); library(dplyr)}
if (!require(rlang)) {install.packages(rlang); library(rlang)}
# For examples.R
if (!require(ggplot2)) {install.packages(ggplot2); library(ggplot2)}
# For createdata.R
if (!require(mvtnorm)) {install.packages(mvtnorm); library(mvtnorm)}
if (!require(tidyr)) {install.packages(tidyr); library(tidyr)}

### Function----
source("within_ci.R")
source("createdata.R")

### Examples----

# Note: the example data set contains two between subject variables and two within subject variables. 
# The number of variables specified in the function MUST correspond to the number that is present in the dataframe. 
# Accordingly, if you have a design with three IVs, but you're interested in a two-way interaction between two of the
# variable, the data needs to be collapsed over the third variable to render correct results. 


# Examples: 

# One within factor, no between factors
df <- data_1w
summary_data <- within_ci(.data = df,
           .subject = subject,
           .value = DV,
           .ws_factors = within1)
ggplot(data = summary_data,
       aes(x = within1,
           y = sample_mean)) + 
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge(width = 1)) + 
  geom_errorbar(position = position_dodge(width = 1),
           width = .1,
           aes(ymin = sample_mean - CI,
           ymax = sample_mean + CI)) + 
  labs(y = "DV",title = "Example bar plot - one within subject variable") + 
  theme_classic() 

# One within factor, one between factor
df <- data_1w1b
within_ci(.data = df,
           .subject = subject,
           .value = DV,
           .ws_factors = within1,
           .bs_factors = between1) %>%
  ggplot(aes(x = between1,
             y = sample_mean,
             group = within1)) + 
  geom_bar(stat = "identity",
           position = position_dodge(width = 1),
           color = "black",
           aes(fill = within1)) + 
  geom_errorbar(position = position_dodge(width = 1),
           width = .1,
           aes(ymin = sample_mean - CI,
           ymax = sample_mean + CI)) + 
  scale_fill_manual(values = c("white", "grey")) + 
  labs(y = "DV",
       title = "Example bar plot - one within one between") + 
  theme_classic() 

# Multiple within and between factors
data_2w2b %>%
  within_ci(.data = .,
           .subject = subject,
           .value = DV,
           .ws_factors = c(within1, within2),
           .bs_factors = c(between1, between2)) %>%
  ggplot(aes(x = within1,
             y = sample_mean,
             group = within2)) + 
  geom_bar(stat = "identity",
              position = position_dodge(width = 1),
              color = "black",
              aes(fill = within2)) + 
  geom_errorbar(position = position_dodge(width = 1),
                width = .1,
                aes(ymin = sample_mean - CI,
                    ymax = sample_mean + CI)) + 
  scale_fill_manual(values = c("white", "grey")) + 
  labs(y = "DV",
       title = "Example bar plot - two within two between") + 
  theme_classic() +
  facet_grid(between1 ~ between2)
