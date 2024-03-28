# GP3. Normal/exceptional flow: Test cases should check normal and exceptional flow

# How to measure:
# - number of methods invoked with exception handling in a test case AND number of bug fixes in its history
# - all observations
# In the paper, this corresponds to metrics: invWithEx and bfCommits


testGP3a <- function(dataEffective, dataIneffective) {
  result = list(goodPractice = "gp3a")  
  
  # Hypothesis = effective test cases have more exception handling than ineffective ones
  # Therefore we expect a positive delta
  altHypothesis = "two.sided"
  expectedDelta = "positive"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  
  w = wilcox.test(dataEffective$numberOfExceptionsThrown, dataIneffective$numberOfExceptionsThrown, , paired = FALSE, alternative = altHypothesis)
  resDelta <- cliff.delta(dataEffective$numberOfExceptionsThrown, dataIneffective$numberOfExceptionsThrown, , paired = FALSE, alternative = altHypothesis)

  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

