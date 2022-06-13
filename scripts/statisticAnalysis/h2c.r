# H2 Test cases in a test suite should be self-contained,
# i.e., independent of one another.
# This variant of H2 was NOT included in the paper as there was no clear justification for it.

# How to measure:
# - number of distinct test case method invocations in same class AND number of bug fixes in its history
# - all observations

testH2c <- function(staticAnalysisCommitsClones) {
  result = list(hipothesis = "h2c",
                numObservations = 0,
                normalityLeft = 0,
                normalityRight = 0,
                kendallTau = 0,
                kendallPValue = 0,
                spearmanRho = 0,
                spearmanPValue = 0,
                pearsonCor = 0,
                pearsonPValue = 0,
                numObservationsIneffective = 0,
                numObservationsEffective = 0,
                conditionNumObservationsIneffective = "",
                conditionNumObservationsEffective = "")  
  
  # For H2c, we need the number of distinct test case invocations in the same class
  staticAnalysisCommitsClones$numberOfDistinctTestCaseMethodInvocationsInSameClass = as.numeric(staticAnalysisCommitsClones$numberOfDistinctTestCaseMethodInvocationsInSameClass)

  # All observations
  data <- staticAnalysisCommitsClones
  result$numObservations = nrow(data)
  tryCatch(
  expr = {
      if(nrow(data) < 5000) {
        normalityLeft <- shapiro.test(data$numberOfDistinctTestCaseMethodInvocationsInSameClass)
        normalityRight <- shapiro.test(data$noCommitFixes)
      } else {
        normalityLeft <- shapiro.test(sample(data$numberOfDistinctTestCaseMethodInvocationsInSameClass,5000))
        normalityRight <- shapiro.test(sample(data$noCommitFixes,5000))
      }
      result$normalityLeft <- normalityLeft$p.value
      result$normalityRight <- normalityRight$p.value
    },
    warning = function(warning_condition) { 
      print(cat("...Warning during normality test: ",paste( unlist(warning_condition), collapse=' ')))
    },
    error = function(error_condition) {
      print(cat("...Error during normality test: ",paste( unlist(error_condition), collapse=' ')))
    },
    finally={ }
  )
  tryCatch(
    expr = {
      hKendall <- cor.test(data$numberOfDistinctTestCaseMethodInvocationsInSameClass,
                   data$noCommitFixes,
                   method="kendall",
                   exact=FALSE)
      result$kendallTau <- hKendall$estimate
      result$kendallPValue <- hKendall$p.value
    },
    warning = function(warning_condition) { 
      print(cat("...Warning during kendall test: ",paste( unlist(warning_condition), collapse=' ')))
    },
    error = function(error_condition) {
      print(cat("...Error during kendall test: ",paste( unlist(error_condition), collapse=' ')))
    },
    finally={ }
  )
  tryCatch(
    expr = {
      hSpearman <- cor.test(data$numberOfDistinctTestCaseMethodInvocationsInSameClass,
                            data$noCommitFixes,
                            method="spearman",
                            exact=FALSE)
      result$spearmanRho <- hSpearman$estimate
      result$spearmanPValue <- hSpearman$p.value
    },
    warning = function(warning_condition) { 
      print(cat("...Warning during spearman test: ",paste( unlist(warning_condition), collapse=' ')))
    },
    error = function(error_condition) {
      print(cat("...Error during spearman test: ",paste( unlist(error_condition), collapse=' ')))
    },
    finally={ }
  )
  tryCatch(
    expr = {
      hPearson <- cor.test(data$numberOfDistinctTestCaseMethodInvocationsInSameClass,
                             data$noCommitFixes,
                             method="pearson")
      result$pearsonCor <- hPearson$estimate
      result$pearsonPValue <- hPearson$p.value
    },
    warning = function(warning_condition) { 
      print(cat("...Warning during pearson test: ",paste( unlist(warning_condition), collapse=' ')))
    },
    error = function(error_condition) {
      print(cat("...Error during pearson test: ",paste( unlist(error_condition), collapse=' ')))
    },
    finally={ }
  )  
  
  ggplot(data,aes(noCommitFixes,noCommitFixes))+geom_bar(stat="identity",width=1)
  
  # Balancing
  # <=0 and >3 = -385 !This is the best balancing
  # <=0 and >4 =  402 
  
  result$conditionNumObservationsIneffective = "<=0"
  result$conditionNumObservationsEffective = ">3"
  
  dataIneffective <- data[data$noCommitFixes == 0,]
  dataEffective <- data[data$noCommitFixes >3,]
  
  result$numObservationsIneffective = nrow(dataIneffective)
  result$numObservationsEffective = nrow(dataEffective)
  result$balancing = nrow(dataIneffective)-nrow(dataEffective)
  
  w = wilcox.test(dataEffective$numberOfDistinctTestCaseMethodInvocationsInSameClass, dataIneffective$numberOfDistinctTestCaseMethodInvocationsInSameClass, paired = F)
  result$wilcox <- w$statistic
  result$wilcoxPvalue <- w$p.value
  resDelta <- cliff.delta(dataEffective$numberOfDistinctTestCaseMethodInvocationsInSameClass, dataIneffective$numberOfDistinctTestCaseMethodInvocationsInSameClass, paired = F)
  result$cliffDelta <- as.character(resDelta$magnitude)
  result$cliffEstimate <- resDelta$estimate
  
  return(result)
}

