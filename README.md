# hiringLetter

This package holds one unique function, a shiny app function for individuals on a hiring committee to interactively set qualifications to filter candidates for a position. 
The default qualifications available in the hire function are age, work experience, and current role. 
The output is filtered tables of accepted and rejected individuals with customized acceptance and rejection letter templates. 
The letter template is designed based on a S4 class. This package utilizes two libraries: dplyr and shiny. 

### Example use of function

install.packages("hiringLetter")

library(hiringLetter)

hireLetter(myData)

#Sample dataframe - myData

name <- c("Josephine", "Carl", "John", "Sienna", "Christa")

age <- c(23,45,78,25,24)

experience <- c(1,5,6,3,4)

role <- c("Project Manager", "Civil Engineer", "Chef", "Civil Engineer", "Civil Engineer")

myData <- data.frame(name, age, experience, role)
