# GP3. Normal/exceptional flow: Test cases should check normal and exceptional flow

# How to measure:
# - number of methods invoked with exception handling that are thrown and caught in a test case AND number of bug fixes in its history
# In the paper, this corresponds to metrics: invWithExC and bfCommits

testGP3b <- function(dataEffective, dataIneffective) {
  result = list(goodPractice = "gp3b")  
  
  # Hypothesis = effective test cases have more exception handling being thrown and caught than ineffective ones
  # Therefore we expect a positive delta
  altHypothesis = "two.sided"
  expectedDelta = "positive"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  
  w = wilcox.test(dataEffective$totalExceptions, dataIneffective$totalExceptions, , paired = FALSE, alternative = altHypothesis)
  resDelta <- cliff.delta(dataEffective$totalExceptions, dataIneffective$totalExceptions, , paired = FALSE, alternative = altHypothesis)
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

