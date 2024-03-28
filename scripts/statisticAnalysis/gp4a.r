# GP4. Small size: Test cases should be small in size,
# as large test cases might be difficult to understand
# and maintain. They should also avoid including unnecessary steps.

# How to measure:
# - number of LOC in a test case AND number of bug fixes in its history
# In the paper, this corresponds to metrics: loc and bfCommits

testGP4a <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "gp4a", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$CountLineCode, dataIneffective$CountLineCode, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$CountLineCode, dataIneffective$CountLineCode, paired = F, alternative = "greater")
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  return(result)
}

