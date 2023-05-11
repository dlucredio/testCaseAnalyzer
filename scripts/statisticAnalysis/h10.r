# H10 Increased complexity in a test case can lead to bugs in the testcode itself.

# How to measure:
# - Cyclomatic complexity AND number of bug fixes in its history
# In the paper, this corresponds to metrics: cycl and bfCommits

testH10 <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "h10", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$Cyclomatic, dataIneffective$Cyclomatic, paired = F, alternative = "greater")
  resDelta <- cliff.delta(dataEffective$Cyclomatic, dataIneffective$Cyclomatic, paired = F, alternative = "greater")
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  return(result)
}

