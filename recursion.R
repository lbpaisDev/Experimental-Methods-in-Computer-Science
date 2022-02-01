#FCTUC -Mestrado em Engenharia Informática - Metodologias e Experimentação e Informática
#Joana Brás - 2021179983
#Renato Ferreira - 2015228102
#Leandro Pais - 2017251509

library(scatterplot3d)

#--- PHASE 0 - Load and separate data

#Load up tests results as a table
#A table is created for each test file
results_c1_200s <- read.table("./test_results/code1/test_results_seed_27427_maxcputime_200_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c1_400s <- read.table("./test_results/code1/test_results_seed_32693_maxcputime_400_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c1_600s <- read.table("./test_results/code1/test_results_seed_11039_maxcputime_600_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c1_800s <- read.table("./test_results/code1/test_results_seed_86016_maxcputime_800_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c1_1000s <- read.table("./test_results/code1/test_results_seed_23287_maxcputime_1000_code1.txt",header=TRUE,fileEncoding="UTF-16LE")

results_c2_200s <- read.table("./test_results/code2/test_results_seed_14309_maxcputime_200_code2.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2_400s <- read.table("./test_results/code2/test_results_seed_31864_maxcputime_400_code2.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2_600s <- read.table("./test_results/code2/test_results_seed_88967_maxcputime_600_code2.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2_800s <- read.table("./test_results/code2/test_results_seed_57723_maxcputime_800_code2.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2_1000s <- read.table("./test_results/code2/test_results_seed_61985_maxcputime_1000_code2.txt",header=TRUE,fileEncoding="UTF-16LE")

#--- PHASE 1 - Analyze dependent variable "Number of solved cases"

#Get number of solved cases for each runtime code1 and code2
c1_solved_cases = c(
  length(which(results_c1_200s$nslots != -1)),
  length(which(results_c1_400s$nslots != -1)),
  length(which(results_c1_600s$nslots != -1)),
  length(which(results_c1_800s$nslots != -1)),
  length(which(results_c1_1000s$nslots != -1))
)

c2_solved_cases = c(
  length(which(results_c2_200s$nslots != -1)),
  length(which(results_c2_400s$nslots != -1)),
  length(which(results_c2_600s$nslots != -1)),
  length(which(results_c2_800s$nslots != -1)),
  length(which(results_c2_1000s$nslots != -1))
)

#Plot solved cases for code1 vs solved cases for code2
#Create matrix to hold data to be ploted
plot_matrix <- matrix(, nrow = 2, ncol = 5)

#First row gets the number of solved cases for each max runtime code1
plot_matrix[1,] <- c1_solved_cases

#Second row does the same for code2
plot_matrix[2,] <- c2_solved_cases

#Note that the "beside" argument has to be kept "TRUE" in order to place the bars side by side
barplot(plot_matrix, names.arg =  c(200,400,600,800,1000), beside = TRUE, ylim = c(0,200),col = c("peachpuff", "skyblue"), legend.text = c("Code1", "Code2"), xlab = "Max Runtime(s)", ylab = "Number of Solved Cases")

#--- PHASE 2 - Analyze dependent variable "Time" 
#We chose the results with more solved cases to be more representative
scatterplot3d(results_c1_1000s$prob, results_c1_1000s$nexams, results_c1_1000s$time)
scatterplot3d(results_c2_1000s$prob, results_c2_1000s$nexams, results_c2_1000s$time)

#Remove 0 values that will generate NaNs when logarithm is applied
results_c1_1000s_filtered <- subset(results_c1_1000s, time != 0)
results_c2_1000s_filtered <- subset(results_c2_1000s, time != 0)

x=1:length(results_c1_1000s$time)
plot(x, results_c1_1000s$time)

#3-way regression for code1
lr_c1_3d.out <- lm(results_c1_1000s_filtered$time ~ results_c1_1000s_filtered$nexams + results_c1_1000s_filtered$prob)
summary(lr_c1_3d.out)

#model equation y = 3.27e^-276*67120495^nexames*2.96^+179^prob

#3-way regression for code2
lr_c2_3d.out <- lm(results_c2_1000s_filtered$time ~ results_c2_1000s_filtered$nexams + results_c2_1000s_filtered$prob)
summary(lr_c2_3d.out)

#model equation y = 4.23e^-240*14976607^nexames*7.747^+155^prob

#Exponential model
#Code1
lr_c1_3d_exp.out <- lm(log(results_c1_1000s_filtered$time) ~ results_c1_1000s_filtered$nexams + results_c1_1000s_filtered$prob)
summary(lr_c1_3d_exp.out)

#model equation y = 3.13e^-9*1.681456^nexames*259938.4^prob

#Code2
lr_c2_3d_exp.out <- lm(log(results_c2_1000s_filtered$time) ~ results_c2_1000s_filtered$nexams + results_c2_1000s_filtered$prob)
summary(lr_c2_3d_exp.out)

#model equation y = 8.964442e-09*1.648111^nexames*113633.1^prob

results_c1_1000s_frame = data.frame(results_c1_1000s)
results_c2_1000s_frame = data.frame(results_c2_1000s)

#Remove 0 values that will generate NaNs when logarithm is applied
results_c1_1000s_frame$time[results_c1_1000s_frame$time==0] <- 0.0001
results_c2_1000s_frame$time[results_c2_1000s_frame$time==0] <- 0.0001

x=1:length(results_c1_1000s_frame$time)
plot(x, results_c1_1000s_frame$time)

#3-way regression for code1
lr_c1_3d.out <- lm(results_c1_1000s_frame$time ~ results_c1_1000s_frame$nexams + results_c1_1000s_frame$prob)
summary(lr_c1_3d.out)

#3-way regression for code2
lr_c2_3d.out <- lm(results_c2_1000s_frame$time ~ results_c2_1000s_frame$nexams + results_c2_1000s_frame$prob)
summary(lr_c2_3d.out)

#Exponential model
#Code1
lr_c1_3d_exp.out <- lm(log(results_c1_1000s_frame$time) ~ log(results_c1_1000s_frame$nexams) * log(results_c1_1000s_frame$prob))
summary(lr_c1_3d_exp.out)

#Code2
lr_c2_3d_exp.out <- lm(log(results_c2_1000s_frame$time) ~ log(results_c2_1000s_frame$nexams) * log(results_c2_1000s_frame$prob))
summary(lr_c2_3d_exp.out)


