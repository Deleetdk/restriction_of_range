#global.R

library(pacman)
p_load(ggplot2, devtools, grid, stringr)

data = read.csv("data.csv",row.names = 1) #load data
title = "Understanding restriction of range"
