# GP2. Independence: Test cases should be self-contained,
# independent of one another. A test case should also have
# all that is necessary for its execution;

# How to measure:
# - number of distinct method invocations in same class AND number of bug fixes in its history
# - all observations
# In the paper, this corresponds to metrics: eCouplingTC(T) and bfCommits(T)

testGP2b <- function(dataEffective, dataIneffective) {
  result = list(goodPractice = "gp2b")
  
  # Hypothesis = effective test cases have less coupling in the same class than ineffective ones
  # Therefore we expect a negative delta
  altHypothesis = "two.sided"
  expectedDelta = "negative"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  
  w = wilcox.test(dataEffective$numberOfDistinctMethodInvocationsInSameClass, dataIneffective$numberOfDistinctMethodInvocationsInSameClass, , paired = FALSE, alternative = altHypothesis)
  resDelta <- cliff.delta(dataEffective$numberOfDistinctMethodInvocationsInSameClass, dataIneffective$numberOfDistinctMethodInvocationsInSameClass, , paired = FALSE, alternative = altHypothesis)

  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

