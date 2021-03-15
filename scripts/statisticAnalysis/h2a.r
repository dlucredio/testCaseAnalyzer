# H2 Test cases in a test suite should be self-contained,
# i.e., independent of one another.

# How to measure:
# - number of distinct method invocations AND number of bug fixes in its history
# - all observations

testH2a <- function(staticAnalysisCommitsClones) {
  result = list(numObservations = 0,
                normalityLeft = 0,
                normalityRight = 0,
                kendallTau = 0,
                kendallPValue = 0,
                spearmanRho = 0,
                spearmanPValue = 0,
                pearsonCor = 0,
                pearsonPValue = 0)
  
  
  # For H2a, we need the number of distinct method invocations
  staticAnalysisCommitsClones$numberOfDistinctMethodInvocations = as.numeric(staticAnalysisCommitsClones$numberOfDistinctMethodInvocations)

  # All observations
  data <- staticAnalysisCommitsClones
  result$numObservations = nrow(data)
  tryCatch(
  expr = {
      if(nrow(data) < 5000) {
        normalityLeft <- shapiro.test(data$numberOfDistinctMethodInvocations)
        normalityRight <- shapiro.test(data$noCommitFixes)
      } else {
        normalityLeft <- shapiro.test(sample(data$numberOfDistinctMethodInvocations,5000))
        normalityRight <- shapiro.test(sample(data$noCommitFixes,5000))
      }
      result$normalityLeft <- normalityLeft$p.value
      result$normalityRight <- normalityRight$p.value
    },
    warning = function(warning_condition) { 
      print(cat("...Warning during normality test: ",paste( unlist(warning_condition), collapse=' ')))
    },
    error = function(error_condition) {
      print(cat("...Error during normality test: ",paste( unlist(error_condition), collapse=' ')))
    },
    finally={ }
  )
  tryCatch(
    expr = {
      h1Kendall <- cor.test(data$numberOfDistinctMethodInvocations,
                   data$noCommitFixes,
                   method="kendall",
                   exact=FALSE)
      result$kendallTau <- h1Kendall$estimate
      result$kendallPValue <- h1Kendall$p.value
    },
    warning = function(warning_condition) { 
      print(cat("...Warning during kendall test: ",paste( unlist(warning_condition), collapse=' ')))
    },
    error = function(error_condition) {
      print(cat("...Error during kendall test: ",paste( unlist(error_condition), collapse=' ')))
    },
    finally={ }
  )
  tryCatch(
    expr = {
      h1Spearman <- cor.test(data$numberOfDistinctMethodInvocations,
                            data$noCommitFixes,
                            method="spearman",
                            exact=FALSE)
      result$spearmanRho <- h1Spearman$estimate
      result$spearmanPValue <- h1Spearman$p.value
    },
    warning = function(warning_condition) { 
      print(cat("...Warning during spearman test: ",paste( unlist(warning_condition), collapse=' ')))
    },
    error = function(error_condition) {
      print(cat("...Error during spearman test: ",paste( unlist(error_condition), collapse=' ')))
    },
    finally={ }
  )
  tryCatch(
    expr = {
      h1Pearson <- cor.test(data$numberOfDistinctMethodInvocations,
                             data$noCommitFixes,
                             method="pearson")
      result$pearsonCor <- h1Pearson$estimate
      result$pearsonPValue <- h1Pearson$p.value
    },
    warning = function(warning_condition) { 
      print(cat("...Warning during pearson test: ",paste( unlist(warning_condition), collapse=' ')))
    },
    error = function(error_condition) {
      print(cat("...Error during pearson test: ",paste( unlist(error_condition), collapse=' ')))
    },
    finally={ }
  )  
  
  return(result)
}

