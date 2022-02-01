#MEI-Metodologias e Experimentação em Informática
#Leandro Pais - 2017251509

#Hypothesis to be tested
#H0 :χTempoProcessamentoCodigo1-χTempoProcessamentoCodigo2=0
#H1 :χTempoProcessamentoCodigo1-χTempoProcessamentoCodigo2!=0
#Conf.level=0.95

#Load test results
#Code1
results_c1_1000s <- read.table("./test_results/code1/test_results_seed_91636_maxcputime_1000_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
#Code2
results_c2_1000s <- read.table("./test_results/code2/test_results_seed_39386_maxcputime_1000_code2.txt",header=TRUE,fileEncoding="UTF-16LE")

c1_ids = rep("Code1", length(results_c1_1000s$time))
c2_ids = rep("Code2", length(results_c2_1000s$time))

times_dframe_c1 = data.frame(results_c1_1000s$time, results_c1_1000s$nexams, results_c1_1000s$prob, c1_ids, "A")
times_dframe_c2 = data.frame(results_c2_1000s$time, results_c2_1000s$nexams, results_c2_1000s$prob, c2_ids, "B")

names(times_dframe_c1)[1]<-"Time"
names(times_dframe_c1)[2]<-"Exams"
names(times_dframe_c1)[3]<-"Prob"
names(times_dframe_c1)[4]<-"Program"
names(times_dframe_c1)[5]<-"Code"

names(times_dframe_c2)[1]<-"Time"
names(times_dframe_c2)[2]<-"Exams"
names(times_dframe_c2)[3]<-"Prob"
names(times_dframe_c2)[4]<-"Program"
names(times_dframe_c2)[5]<-"Code"

times_dframe = rbind(times_dframe_c1, times_dframe_c2)
boxplot(Time~Program*Prob, data=times_dframe)
boxplot(Time~Prob, data=times_dframe)

interaction.plot(times_dframe$Exams, times_dframe$Prob, times_dframe$Time)

aov.out = aov(Time~factor(Exams)*factor(Prob)*factor(Program), data = times_dframe)
summary(aov.out)
plot(aov.out)

#Randomization test
#Get three way anova to adjust p-values
aov.out = aov(Time~factor(Exams)*factor(Prob)*factor(Program), data = times_dframe)
summary(aov.out)

#F-values
FExams = summary(aov.out)[[1]]$F[1]
FProb = summary(aov.out)[[1]]$F[2]
FProgram = summary(aov.out)[[1]]$F[3]
FEPP = summary(aov.out)[[1]]$F[7]

#Initialize p-values
pvalueExams=0
pvalueProb=0
pvalueProgram=0
pvalueFEPP=0

for(i in 1:5000){
  #Randomized sample
  times_dframe$Time = sample(times_dframe$Time)
  
  #Three way anova for randomized sample
  aov.out = aov(Time~factor(Exams)*factor(Prob)*factor(Program), data = times_dframe)
  summary(aov.out)
  
  #Get F-values for aov randomized sample
  pFExams = summary(aov.out)[[1]]$F[1]
  pFProb = summary(aov.out)[[1]]$F[2]
  pFProgram = summary(aov.out)[[1]]$F[3]
  pFEPP = summary(aov.out)[[1]]$F[7]
  
  if(pFExams>=FExams){
    pvalueExams=pvalueExams+1
  }

  if(pFProb>=FProb){
    pvalueProb=pvalueProb+1
  }

  if(pFProgram>=FProgram){
    pvalueProgram=pvalueProgram+1
  }
  
  if(pFEPP>=FEPP){
    pvalueFEPP=pvalueFEPP+1
  }
}

print(pvalueExams/5000)
print(pvalueProb/5000)
print(pvalueProgram/5000)
print(pvalueFEPP/5000)

#Reject H0