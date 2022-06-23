# H6 Most test cases should be small in size (in terms of its lines of code).

# How to measure:
# - number of LOC in a test case AND number of bug fixes in its history
# In the paper, this corresponds to metrics: loc and bfCommits

testH6 <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "h6", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$CountLineCode, dataIneffective$CountLineCode, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$CountLineCode, dataIneffective$CountLineCode, paired = F, alternative = "greater")
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  return(result)
}

