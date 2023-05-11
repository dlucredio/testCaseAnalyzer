# H7 Large test cases are often hard to understand and maintain.

# How to measure:
# - number of LOC in a test case AND Cyclomatic complexity
# In the paper, this corresponds to metrics: loc and cycl

testH7 <- function(data) {
  result = list(hipothesis = "h7", method="Kendall")  
  
  hKendall <- cor.test(data$CountLineCode,
                       data$Cyclomatic,
                       method="kendall",
                       exact=FALSE)

  
  result$observations <- nrow(data)
  result$statistic <- hKendall$estimate
  result$pvalue <- hKendall$p.value
  result$delta <- ""
  result$estimate <- ""  
  
  return(result)
}

