# H3 Good test cases should check for normal and exceptional flow.

# How to measure:
# - number of methods invoked with exception handling in a test case AND number of bug fixes in its history
# - all observations
# In the paper, this corresponds to metrics: invWithEx and bfCommits


testH3a <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "h3a", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$numberOfExceptionsThrown, dataIneffective$numberOfExceptionsThrown, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$numberOfExceptionsThrown, dataIneffective$numberOfExceptionsThrown, paired = F, alternative = "greater")
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  
  return(result)
}

