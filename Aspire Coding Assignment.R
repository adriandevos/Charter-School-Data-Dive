setwd("/Users/adriandevos/Desktop")
library(readxl)
library(ggplot2)
library(dplyr)
library(dummies)
library(data.frame)
hw<-read_xlsx('AspireHW.xlsx')
Improvements<-read_xlsx('improvements.xlsx')
cols<-c("SchoolYear", "Student_Grade_Level", "School","Region", 
        "AssessmentType", "AssessmentSubject", 
        "AssessmentName", "Student_Ethnicity", 
        "Student_is_FreeOrReducedLunch", "Language_Fluency",
        "Student_is_SPED", "ProficiencyLevelScore") 

hw[,cols] <- lapply(hw[,cols], as.factor) #Convert necessary columns to factors
Improvements[,cols] <- lapply(hw[,Improvements], as.factor) #Convert necessary columns to factors
hw <- subset(hw, hw$Region!="Memphis") #Remove Memphis, only one observation, not significant
hw <- subset(hw, hw$Language_Fluency!="-----") 
hw <- subset(hw, hw$Student_Ethnicity!="-----") 
hw <- subset(hw, AssessmentSubject !='ELA')
hw <- subset(hw, Student_Grade_Level != "12")
hw2016 <- subset(hw, hw$SchoolYear != '2016-2017') 
hw2017 <- subset(hw, SchoolYear != '2017-2018') 

Improvements <-subset(Improvements, Improvements$Region!="Memphis")


ggplot(Improvements[which(Improvements$`Math Score 2016-2017`>0),],aes(x=`ELA Score 2016-2017`, y=`Math Score 2016-2017`)) +
  geom_point()+
  geom_smooth(method='lm') +
  theme_minimal()
  

ggplot(Improvements[which(Improvements$`Math Score 2016-2017`>0),],aes(x= `ELA Score 2017-2018`, y= `Math Score 2017-2018`)) +
    geom_point() +
  geom_smooth(method='lm') +
  theme_minimal()


hw %>%
  ggplot(aes(x=PercentScore)) +
  geom_histogram(bins=20, fill='#A930DE', color="#e9ecef", alpha=.9) +
  theme_minimal() +
  ggtitle("Math Assessment Scores") 

hw %>%
  ggplot(aes(x=SchoolYear, y=PercentScore, fill=Region)) +
           geom_bar(stat="identity", position="dodge") +
           theme_minimal()
hw %>%
  ggplot(aes(x=SchoolYear, y=PercentScore, fill=Region)) +
  geom_boxplot(alpha=0.7) +
  theme_minimal() +
  scale_fill_brewer(palette="Set1")

hw %>%
  ggplot(aes(x=SchoolYear, y=PercentScore, fill=Student_is_SPED)) +
  geom_boxplot(alpha=0.7) +
  theme_minimal() +
  scale_fill_brewer(palette="Set1")

hw %>%
  ggplot(aes(x=SchoolYear, y=PercentScore, fill=Student_is_SPED)) +
  geom_boxplot(alpha=0.7) +
  theme_minimal() +
  scale_fill_brewer(palette="Set1")

model<-lm(PercentScore~Language_Fluency+
            Student_Ethnicity+Student_is_SPED + 
            Student_Grade_Level+
            Student_is_FreeOrReducedLunch+
            Region, 
          data=hw)

model1617<-lm(PercentScore~Language_Fluency+
            Student_Ethnicity+Student_is_SPED + 
            Student_Grade_Level+
            Student_is_FreeOrReducedLunch+
            Region, 
          data=hw2016)

model1718<- lm(PercentScore~Language_Fluency+
                 Student_Ethnicity+Student_is_SPED + 
                 Student_Grade_Level+
                 Student_is_FreeOrReducedLunch+
                 Region, 
               data=hw2017)


summary(model)
summary(model1617)
summary(model1718)
anova(model)
par(mfrow = c(2, 2))
plot(model)









