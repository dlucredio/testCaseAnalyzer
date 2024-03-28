# GP4. Small size: Test cases should be small in size,
# as large test cases might be difficult to understand
# and maintain. They should also avoid including unnecessary steps.

# How to measure:
# - number of LOC in a test case AND number of bug fixes in its history
# In the paper, this corresponds to metrics: loc and bfCommits

testGP4a <- function(dataEffective, dataIneffective) {
  result = list(goodPractice = "gp4a")  
  
  # Hypothesis = effective test cases have less loc than ineffective ones
  # Therefore we expect a negative delta
  altHypothesis = "two.sided"
  expectedDelta = "negative"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  
  w = wilcox.test(dataEffective$CountLineCode, dataIneffective$CountLineCode, , paired = FALSE, alternative = altHypothesis)
  resDelta <- cliff.delta(dataEffective$CountLineCode, dataIneffective$CountLineCode, , paired = FALSE, alternative = altHypothesis)
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

