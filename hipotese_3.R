#Load test results
#Code1
results_c1_200s <- read.table("./test_results/code1/test_results_seed_70274_maxcputime_200_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c1_400s <- read.table("./test_results/code1/test_results_seed_26547_maxcputime_400_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c1_600s <- read.table("./test_results/code1/test_results_seed_94196_maxcputime_600_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c1_800s <- read.table("./test_results/code1/test_results_seed_45138_maxcputime_800_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c1_1000s <- read.table("./test_results/code1/test_results_seed_91636_maxcputime_1000_code1.txt",header=TRUE,fileEncoding="UTF-16LE")

#Code2
results_c2_200s <- read.table("./test_results/code2/test_results_seed_89341_maxcputime_200_code2.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2_400s <- read.table("./test_results/code2/test_results_seed_11797_maxcputime_400_code2.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2_600s <- read.table("./test_results/code2/test_results_seed_12742_maxcputime_600_code2.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2_800s <- read.table("./test_results/code2/test_results_seed_85290_maxcputime_800_code2.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2_1000s <- read.table("./test_results/code2/test_results_seed_39386_maxcputime_1000_code2.txt",header=TRUE,fileEncoding="UTF-16LE")

unsolved_sum = sum(table(results_c1_200s$nslots)[1],table(results_c1_400s$nslots)[1],table(results_c1_600s$nslots)[1],table(results_c1_800s$nslots)[1], table(results_c1_1000s$nslots)[1])

unsolved = c(table(results_c1_200s$nslots)[1], table(results_c1_400s$nslots)[1], table(results_c1_600s$nslots)[1], table(results_c1_800s$nslots)[1],table(results_c1_1000s$nslots)[1], unsolved_sum)

solved_sum = sum(nrow(results_c1_200s)-unsolved[1],nrow(results_c1_400s)-unsolved[2],nrow(results_c1_600s)-unsolved[3],nrow(results_c1_800s)-unsolved[4],nrow(results_c1_200s)-unsolved[5])

solved = c(nrow(results_c1_200s)-unsolved[1],nrow(results_c1_400s)-unsolved[2],nrow(results_c1_600s)-unsolved[3],nrow(results_c1_800s)-unsolved[4],nrow(results_c1_200s)-unsolved[5], solved_sum)

total = c(sum(unsolved[1]+solved[1]),sum(unsolved[2]+solved[2]),sum(unsolved[3]+solved[3]),sum(unsolved[4]+solved[4]),sum(unsolved[5]+solved[5]),sum(unsolved[6]+solved[6]))

dataf = data.frame(rbind(solved, unsolved, total))
names(dataf)[1]<-"200"
names(dataf)[2]<-"400"
names(dataf)[3]<-"600"
names(dataf)[4]<-"800"
names(dataf)[5]<-"1000"
names(dataf)[6]<-"Total"

#H0: A proporção de casos resolvidos para os vários max runtimtes é a mesma
#H1: As várias proporções são diferentes
#Alpha = 0.05

chisq.test(dataf)
