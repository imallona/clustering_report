


app <- readRDS("apptainer-performance-results.rds")
con <- readRDS("conda-performance-results.rds")
env <- readRDS("envmodules-performance-results.rds")

library(dplyr)
library(ggplot2)




df <- app %>% select(data, method, seconds) %>% 
  full_join(con %>% select(data, method, seconds),
            by = c("data", "method"), suffix = c(".apptainer",".conda")) %>%
  full_join(env %>% select(data, method, seconds),
            by = c("data", "method"))

colnames(df)[5] <- "seconds.envmodules"


ggplot(df, aes(x=seconds.apptainer,
               y=seconds.conda,
               colour = data)) +
  geom_point(size = 3) +
  scale_x_log10() +
  scale_y_log10() +
  geom_abline() +
  facet_wrap(~method) +
  theme(legend.position = "none")


ggplot(df %>% filter(seconds.apptainer>50 | seconds.conda>50 | seconds.envmodules>50), 
       aes(x=seconds.conda,
               y=seconds.envmodules,
               colour = data)) +
  geom_point(size = 3) +
  scale_x_log10() +
  scale_y_log10() +
  geom_abline() +
  facet_wrap(~method) +
  theme(legend.position = "none")



ggplot(df %>% filter(seconds.apptainer>50 | seconds.conda>50), 
       aes(x=seconds.apptainer,
               y=seconds.conda,
               colour = data)) +
  geom_point(size = 3) +
  scale_x_log10() +
  scale_y_log10() +
  geom_abline() +
  facet_wrap(~method) +
  theme(legend.position = "none")



app <- readRDS("apptainer-metrics-results.rds")
con <- readRDS("conda-metrics-results.rds")
env <- readRDS("envmodules-metrics-results.rds")




df <- app %>% select(data, method, metric, k) %>% 
  full_join(con %>% select(data, method, metric, k),
            by = c("data", "method", "metric"), 
            suffix = c(".apptainer",".conda")) %>%
  full_join(env %>% select(data, method, metric, k),
            by = c("data", "method", "metric"))
            
colnames(df)[ncol(df)] <- "k.envmodules"

ggplot(df, aes(x=k.apptainer,
               y=k.conda,
               colour = data)) +
  geom_point(size = 3) +
  geom_abline() +
  theme(legend.position = "none") +
  facet_wrap(~metric, scales = "free")

ggplot(df, aes(x=k.envmodules,
               y=k.conda,
               colour = data)) +
  geom_point(size = 3) +
  geom_abline() +
  theme(legend.position = "none") +
  facet_wrap(~metric, scales = "free")


ggplot(df, aes(x=k.apptainer,
               y=k.conda,
               colour = data,
               fill = method)) +
  geom_point(size = 3) +
  geom_abline() +
  theme(legend.position = "none") +
  facet_wrap(~method, scales = "free")


ggplot(df %>% filter(method %in% names(big_diffs)), aes(x=k.apptainer,
               y=k.conda,
               colour = data,
               fill = method)) +
  geom_point(size = 3) +
  geom_abline() +
  theme(legend.position = "none") +
  facet_grid(method ~ metric, scales = "free_y")


(df %>% filter(abs(k.apptainer-k.conda) > .001) %>% 
  pull(method) %>% table() -> big_diffs)

# ggplot(df %>% filter(method %in% names(big_diffs)), 
#        aes(y=k.apptainer-k.conda,
#                x=data,
#                colour = data,
#                fill = method)) +
#   geom_point(size = 3) +
#   geom_abline() +
#   theme(legend.position = "none") +
#   facet_wrap(~metric, scales = "free")


ggplot(df, aes(y=k.apptainer-k.conda,
               x=method,
               colour = method)) +
  geom_point(size = 3) +
  geom_abline() +
  theme(legend.position = "bottom") +
  facet_wrap(~metric, scales = "free")


ggplot(df, aes(y=k.apptainer-k.conda,
               x=data,
               colour = data)) +
  geom_point(size = 3) +
  geom_abline() +
  theme(legend.position = "bottom") +
  facet_wrap(~metric, scales = "free")
