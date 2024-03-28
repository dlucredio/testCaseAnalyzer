# Simplicity: Tests should be simple, with as few steps as possible.
# Complex test cases can have bugs, be difficult to develop and maintain.

# How to measure:
# - Cyclomatic complexity AND number of bug fixes in its history
# In the paper, this corresponds to metrics: cycl and bfCommits

testGP7 <- function(dataEffective, dataIneffective) {
  result = list(goodPractice = "gp7")  
  
  # Hypothesis = effective test cases have less complexity than ineffective ones
  # Therefore we expect a negative delta
  altHypothesis = "two.sided"
  expectedDelta = "negative"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  
  w = wilcox.test(dataEffective$Cyclomatic, dataIneffective$Cyclomatic, , paired = FALSE, alternative = altHypothesis)
  resDelta <- cliff.delta(dataEffective$Cyclomatic, dataIneffective$Cyclomatic, , paired = FALSE, alternative = altHypothesis)
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

