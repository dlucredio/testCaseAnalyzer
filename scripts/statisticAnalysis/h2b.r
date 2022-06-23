# H2 Test cases in a test suite should be self-contained,
# i.e., independent of one another.

# How to measure:
# - number of distinct method invocations in same class AND number of bug fixes in its history
# - all observations
# In the paper, this corresponds to metrics: eCouplingTC(T) and bfCommits(T)

testH2b <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "h2b", method="Wilcoxon")
  
  w = wilcox.test(dataEffective$numberOfDistinctMethodInvocationsInSameClass, dataIneffective$numberOfDistinctMethodInvocationsInSameClass, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$numberOfDistinctMethodInvocationsInSameClass, dataIneffective$numberOfDistinctMethodInvocationsInSameClass, paired = F, alternative = "greater")

  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  
  return(result)
}

