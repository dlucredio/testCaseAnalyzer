# H3 Good test cases should check for normal and exceptional flow.

# How to measure:
# - number of methods invoked with exception handling in a test case AND number of bug fixes in its history
# - Only observations with at least one exception thrown.
#   Because this is a neglected area, the number of test
#   cases exploring exception handling is too low.
# In the paper, this corresponds to metrics: invWithExC and bfCommits

testH3b <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "h3b", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$totalExceptions, dataIneffective$totalExceptions, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$totalExceptions, dataIneffective$totalExceptions, paired = F, alternative = "greater")
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate  
  return(result)
}

