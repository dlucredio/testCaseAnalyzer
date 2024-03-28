# GP5. Small footprint: The amount of code executed by a test
# case should be as small as possible

# How to measure:
# - Foot print AND number of bug fixes in its history
# - But only observations where the footprint was successfully
#   collected. Many projects could not be executed by our
#   automated scripts through JaCoCo.
# In the paper, this corresponds to metrics: footprint and bfCommits

testGP5 <- function(dataEffective, dataIneffective) {
  result = list(hipothesis = "gp5", method="Wilcoxon")  
  
  w = wilcox.test(dataEffective$LINE_covered, dataIneffective$LINE_covered, paired = F, alternative = "greater")

  resDelta <- cliff.delta(dataEffective$LINE_covered, dataIneffective$LINE_covered, paired = F, alternative = "greater")
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  return(result)
}

