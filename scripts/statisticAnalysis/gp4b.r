# GP4. Small size: Test cases should be small in size,
# as large test cases might be difficult to understand
# and maintain. They should also avoid including unnecessary steps.

# How to measure:
# - number of LOC in a test case AND readability
# In the paper, this corresponds to metrics: loc and read

testGP4b <- function(dataReadable, dataUnreadable) {
  result = list(goodPractice = "gp4b")  
  
  # Hypothesis = readable test cases have less loc than unreadable ones
  # Therefore we expect a negative delta
  altHypothesis = "two.sided"
  expectedDelta = "negative"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  
  w = wilcox.test(dataReadable$CountLineCode, dataUnreadable$CountLineCode, paired = F, alternative = "less")
  resDelta <- cliff.delta(dataReadable$CountLineCode, dataUnreadable$CountLineCode, paired = F, alternative = "less")
  result$observations <- nrow(dataReadable) + nrow(dataUnreadable)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

