# GP6. Understandability: Test cases should be easy to read
# and understand by both testers and developers

# How to measure:
# - Readability AND number of bug fixes in its history
# In the paper, this corresponds to metrics: read and bfCommits

testGP6 <- function(dataEffective, dataIneffective) {
  result = list(goodPractice = "gp6")  
  
  # Hypothesis = effective test cases have more readability than ineffective ones
  # Therefore we expect a positive delta
  altHypothesis = "two.sided"
  expectedDelta = "positive"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  
  w = wilcox.test(dataEffective$readability, dataIneffective$readability, , paired = FALSE, alternative = altHypothesis)

  resDelta <- cliff.delta(dataEffective$readability, dataIneffective$readability, , paired = FALSE, alternative = altHypothesis)
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

