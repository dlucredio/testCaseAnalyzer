# H1 A good test case is specific or atomic, i.e.,
# one test case should be testing one aspect of a requirement.

# How to measure:
# - number of assertions in a test case AND number of bug fixes in its history
# - But only observations with at least one assertion.
#   Some test cases did not have assertions accounted,
#   because they use an assert framework not considered
#   here (Junit, Truth, AssertJ, Hamcrest), or because
#   the assertion is too deep in the call hierarchy
# In the paper, this corresponds to metrics: assert(T) and bfCommits(T)

testH1 <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "h1", method="Wilcoxon")

  w = wilcox.test(dataEffective$finalNumberOfAssertions, dataIneffective$finalNumberOfAssertions, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$finalNumberOfAssertions, dataIneffective$finalNumberOfAssertions, paired = F, alternative = "greater")

  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  
  return(result)
}

