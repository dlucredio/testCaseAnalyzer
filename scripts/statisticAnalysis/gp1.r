# GP1. Atomicity: A test case should not attempt to test
# multiple requirements at once, only one or two. Ideally,
# test cases should be atomic (i.e. have a single aspect
# or requirement being tested);


# How to measure:
# - number of assertions in a test case AND number of bug fixes in its history
# - But only observations with at least one assertion.
#   Some test cases did not have assertions accounted,
#   because they use an assert framework not considered
#   here (Junit, Truth, AssertJ, Hamcrest), or because
#   the assertion is too deep in the call hierarchy
# In the paper, this corresponds to metrics: assert(T) and bfCommits(T)

testGP1 <- function(dataEffective, dataIneffective) {
  result = list(goodPractice = "gp1")
  
  # Hypothesis = effective test cases have less assertions than ineffective ones
  # Therefore we expect a negative delta
  altHypothesis = "two.sided"
  expectedDelta = "negative"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  w = wilcox.test(dataEffective$finalNumberOfAssertions, dataIneffective$finalNumberOfAssertions, paired = FALSE, alternative = altHypothesis)
  resDelta <- cliff.delta(dataEffective$finalNumberOfAssertions, dataIneffective$finalNumberOfAssertions, paired = FALSE, alternative = altHypothesis)

  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

