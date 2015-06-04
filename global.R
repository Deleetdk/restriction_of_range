#global.R

#not using pacman
library(ggplot2)
library(devtools)
library(stringr)
library(grid)

#load data
data = read.csv("data.csv",row.names = 1) #load data

#title
title = "Understanding restriction of range"
