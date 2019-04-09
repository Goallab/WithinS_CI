# CREATE THE EXAMPLE DATA
set.seed(45)

# create example data

# group 1

sigma <- matrix(c(1,.3, .3, .3, .3, 1, .3, .3, .3, .3, 1, .3, .3, .3, .3, 1), ncol = 4)
mean <- c(.9, .6, .3, 0)
g1data <- rmvnorm(40, mean, sigma)
g1g <- 1
g1g[1:40] <- 1
g1g2 <- rep(c(1, 2), 20)
g1data <- cbind(g1data, g1g, g1g2)

# group 2

mean <- c(0, 0, 0, 0)
g2data <- rmvnorm(40, mean, sigma)
g2g <- 1
g2g[1:40] <- 2
g2g2 <- rep(c(1, 2), 20)
g2data <- cbind(g2data, g2g, g2g2)

# combine data group 1 and group 2 and make it a dataframe

totdata <- rbind(g1data, g2data)
totdata <- as.data.frame(totdata)
totdata$subject <- 1:nrow(totdata)
colnames(totdata) <- c("m1", "m2", "m3", "m4", "group1", "group2", "subject") 

# Create datasets with a different number of within and between subject variables
data_1w <- totdata %>%
  select(-c(m3, m4, group1, group2)) %>%
  gather(within1, DV, m1:m2) %>%
  mutate(within1 = ifelse(within1 == "m1", 1, 2)) %>%
  mutate(within1 = as.factor(within1))

data_1w1b <- totdata %>%
  select(-c(m3, m4, group2)) %>%
  gather(within1, DV, m1:m2) %>%
  mutate(within1 = ifelse(within1 == "m1", 1, 2)) %>%
  rename(between1 = group1) %>%
  mutate(within1 = as.factor(within1)) %>% 
  mutate(between1 = as.factor(between1))

data_2w2b <- totdata %>% 
  gather(within1, DV, m1:m2) %>% 
  gather(within2, DV, m3:m4) %>%
  mutate(within1 = ifelse(within1 == "m1", 1, 2),
         within2 = ifelse(within2 == "m3", 1, 2)) %>%
  rename(between1 = group1,
         between2 = group2) %>%
  mutate(within1 = as.factor(within1)) %>%
  mutate(within2 = as.factor(within2)) %>%
  mutate(between1 = as.factor(between1)) %>% 
  mutate(between2 = as.factor(between2))

# Remove unnecessary objects
rm(g1data, g2data, sigma, totdata, g1g, g1g2, g2g, g2g2, mean)