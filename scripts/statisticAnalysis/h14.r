# H14 Each test case should have a small footprint, i.e., the amount of code it executes.

# How to measure:
# - Foot print AND number of bug fixes in its history
# - But only observations where the footprint was successfully
#   collected. Many projects could not be executed by our
#   automated scripts through JaCoCo.
# In the paper, this corresponds to metrics: footprint and bfCommits

testH14 <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "h14", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$LINE_covered, dataIneffective$LINE_covered, paired = F, alternative = "greater")

  resDelta <- cliff.delta(dataEffective$LINE_covered, dataIneffective$LINE_covered, paired = F, alternative = "greater")
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  return(result)
}

