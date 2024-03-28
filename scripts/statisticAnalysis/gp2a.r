# GP2. Independence: Test cases should be self-contained,
# independent of one another. A test case should also have
# all that is necessary for its execution;

# How to measure:
# - number of distinct method invocations AND number of bug fixes in its history
# - all observations
# In the paper, this corresponds to metrics: eCoupling(T) and bfCommits(T)

testGP2a <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "gp2a", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$numberOfDistinctMethodInvocations, dataIneffective$numberOfDistinctMethodInvocations, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$numberOfDistinctMethodInvocations, dataIneffective$numberOfDistinctMethodInvocations, paired = F, alternative = "greater")

  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  
  return(result)
}

