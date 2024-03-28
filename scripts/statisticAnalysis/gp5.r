# GP5. Small footprint: The amount of code executed by a test
# case should be as small as possible

# How to measure:
# - Foot print AND number of bug fixes in its history
# - But only observations where the footprint was successfully
#   collected. Many projects could not be executed by our
#   automated scripts through JaCoCo.
# In the paper, this corresponds to metrics: footprint and bfCommits

testGP5 <- function(dataEffective, dataIneffective) {
  result = list(goodPractice = "gp5")  
  
  # Hypothesis = effective test cases have smaller footprint
  # Therefore we expect a negative delta
  altHypothesis = "two.sided"
  expectedDelta = "negative"
  # altHypothesis = "less"
  # altHypothesis = "greater"
  
  
  w = wilcox.test(dataEffective$LINE_covered, dataIneffective$LINE_covered, , paired = FALSE, alternative = altHypothesis)

  resDelta <- cliff.delta(dataEffective$LINE_covered, dataIneffective$LINE_covered, , paired = FALSE, alternative = altHypothesis)
  result$observations <- nrow(dataEffective) + nrow(dataIneffective)
  result$statistic <- w$statistic
  result$pvalue <- w$p.value
  result$delta <- as.character(resDelta$magnitude)
  result$estimate <- resDelta$estimate
  result$expectedDelta <- expectedDelta
  
  return(result)
}

