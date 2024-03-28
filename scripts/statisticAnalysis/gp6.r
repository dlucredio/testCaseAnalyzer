# GP6. Understandability: Test cases should be easy to read
# and understand by both testers and developers

# How to measure:
# - Readability AND number of bug fixes in its history
# In the paper, this corresponds to metrics: read and bfCommits

testGP6 <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "gp6", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$readability, dataIneffective$readability, paired = F, alternative = "less")

  resDelta <- cliff.delta(dataEffective$readability, dataIneffective$readability, paired = F, alternative = "less")
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  return(result)
}

