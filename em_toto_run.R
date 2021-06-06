library(dplyr)
library(tidyr)
library(stringr)
library(git2r)
library(DatawRappr)
library(readxl)

#Working Directory definieren
setwd("C:/Users/simon/OneDrive/Fussballdaten/em-toto-2021")

#Funktionen einlesen
source("functions.R", encoding = "UTF-8")

#Daten laden
tipps <- read_excel("Tipps/EM-Toto 2021 (Antworten).xlsx")

#Neues Dataframe erstellen
zwischenstand_dw <- data.frame("Spieler","Kampfname",99,"Europameister-Tipp","Wie weit kommt die Schweiz?")
colnames(zwischenstand_dw) <- c("Spieler","Kampfname","Punkte","Weltmeister-Tipp","Wie weit kommt die Schweiz?")

###Eintrag für jeden Spieler
for (p in 2:nrow(tipps)) {

score <- 0

###Punkte evaluieren für jedes Spiel
for (g in 5:40) {

if ( is.na(tipps[1,g]) == FALSE ) {

result_home <- as.numeric(trimws(str_split(tipps[1,g],":")[[1]][1]))
result_away <- as.numeric(trimws(str_split(tipps[1,g],":")[[1]][2]))
guess_home <- as.numeric(trimws(str_split(tipps[p,g],":")[[1]][1]))
guess_away <- as.numeric(trimws(str_split(tipps[p,g],":")[[1]][2]))

if ( (result_home == guess_home) & (result_away == guess_away) ) {
  
score <- score + 3  
  
} else if ( (result_home > result_away) & (guess_home > guess_away) ) {

score <- score + 1    

} else if ( (result_home < result_away) & (guess_home < guess_away) ) {
  
score <- score + 1 

} else if ( (result_home == result_away) & (guess_home == guess_away) ) {
  
  score <- score + 1 
  
}  


}

    
}

###Bonuspunkte Europameister
if ( is.na(tipps[1,41]) == FALSE ) {

if (tipps[1,41] == tipps[p,41]) { 
   
score <- score + 5

}
     
}  

###Bonuspunkte Wie weit kommt die Schweiz
if ( is.na(tipps[1,42]) == FALSE ) {
  
  if (tipps[1,42] == tipps[p,42]) { 
    
    score <- score + 5
    
  }
  
}  


  
#Data entry
player_data <- data.frame(tipps[p,3],tipps[p,4],score,tipps[p,41],tipps[p,42])
colnames(player_data) <- c("Spieler","Kampfname","Punkte","Weltmeister-Tipp","Wie weit kommt die Schweiz?")

zwischenstand_dw <- rbind(zwischenstand_dw,player_data)

}    


#Daten bearbeiten und speichern
zwischenstand_dw <- zwischenstand_dw[-1,]
zwischenstand_dw <- zwischenstand_dw[order(-zwischenstand_dw$Punkte),]
write.csv(zwischenstand_dw,"Output/zwischenstand_dw.csv", na = "", row.names = FALSE, fileEncoding = "UTF-8")
print(zwischenstand_dw)

#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
git2r::cred_token(token)
gitadd()
gitcommit()
gitpush()

#Datawrapper-Grafik veröffentlichen