# GP3. Normal/exceptional flow: Test cases should check normal and exceptional flow

# How to measure:
# - number of methods invoked with exception handling that are thrown and caught in a test case AND number of bug fixes in its history
# In the paper, this corresponds to metrics: invWithExC and bfCommits

testGP3b <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "gp3b", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$totalExceptions, dataIneffective$totalExceptions, paired = F, alternative = "less")
  resDelta <- cliff.delta(dataEffective$totalExceptions, dataIneffective$totalExceptions, paired = F, alternative = "less")
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate  
  return(result)
}

