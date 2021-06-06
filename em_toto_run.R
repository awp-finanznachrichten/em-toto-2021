library(dplyr)
library(tidyr)
library(stringr)
library(git2r)
library(DatawRappr)

#Working Directory definieren
setwd("C:/Users/simon/OneDrive/Fussballdaten/em-toto-2021")

#Funktionen einlesen
source("functions.R", encoding = "UTF-8")

#Make Commit
token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
git2r::cred_token(token)
gitadd()
gitcommit()
gitpush()