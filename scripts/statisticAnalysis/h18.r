# H18 A good test case should be readable and understandable

# How to measure:
# - Readability AND number of bug fixes in its history
# In the paper, this corresponds to metrics: read and bfCommits

testH18 <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "h18", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$readability, dataIneffective$readability, paired = F, alternative = "greater")

  resDelta <- cliff.delta(dataEffective$readability, dataIneffective$readability, paired = F, alternative = "greater")
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  return(result)
}

