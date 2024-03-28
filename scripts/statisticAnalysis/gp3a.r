# GP3. Normal/exceptional flow: Test cases should check normal and exceptional flow

# How to measure:
# - number of methods invoked with exception handling in a test case AND number of bug fixes in its history
# - all observations
# In the paper, this corresponds to metrics: invWithEx and bfCommits


testGP3a <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "gp3a", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$numberOfExceptionsThrown, dataIneffective$numberOfExceptionsThrown, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$numberOfExceptionsThrown, dataIneffective$numberOfExceptionsThrown, paired = F, alternative = "greater")

  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  
  return(result)
}

