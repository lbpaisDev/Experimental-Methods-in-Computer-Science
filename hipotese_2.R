#Load up tests results as a table
#A table is created for each test file
results_c1 <- read.table("C:/Users/Asus/Documents/Mestrado/1oano/MEI/MEI_META_3/test_results/test_results_seed_39423_maxcputime_50_code1.txt",header=TRUE,fileEncoding="UTF-16LE")
results_c2 <- read.table("C:/Users/Asus/Documents/Mestrado/1oano/MEI/MEI_META_3/test_results/test_results_seed_72851_maxcputime_50_code2.txt",header=TRUE,fileEncoding="UTF-16LE")



probs <- c(0.4,0.45,0.5,0.55)

#Paranetros para alterar: 

t_exec=0.6 #t_exec é o tempo de execução até o qual queremos que se encontrem os dados 
propor=0.5 #proporção que pretendemos atingir
results_to_use=results_c2 #results_to_use é o código que pretendemos correr (codigo 1: results_to_use=results_c1; codigo 2: results_to_use=results_c2)

#Formalização é H0: proporção de dados menores que t_exec <= propor


#Teste de hipótese nula
proporcao=c(propor,propor,propor,propor)

for (i in 1:length(probs)) {
  below=0
  for (j in 1:length(results_to_use[,1])) {
    if (results_to_use[j,2]==probs[i] & results_to_use[j,5]<=t_exec) {
      below=below+1
      if (i == 1)
        all_below <- below
    }
  }
  if (i>1)
    all_below <- c(all_below, below)
}

prop.test(x = all_below,n = c(100,100,100,100),p = proporcao, alternative = "greater")


#Post-hoc

for (i in 1:length(probs)) {
  below=0
  for (j in 1:length(results_to_use[,1])) {
    if (results_to_use[j,2]==probs[i] & results_to_use[j,5]<=t_exec) {
      below=below+1
    }
  }
  
  print(prop.test(x = below,n = 100,p = propor, alternative = "greater"))
  
}


