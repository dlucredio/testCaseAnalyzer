# H2 Test cases in a test suite should be self-contained,
# i.e., independent of one another.

# How to measure:
# - number of distinct method invocations in same class AND number of bug fixes in its history
# - all observations
# In the paper, this corresponds to metrics: eCouplingTC(T) and bfCommits(T)

testH2b <- function(staticAnalysisCommitsClones) {
  result = list(numObservations = 0,
                normalityLeft = 0,
                normalityRight = 0,
                kendallTau = 0,
                kendallPValue = 0,
                spearmanRho = 0,
                spearmanPValue = 0,
                pearsonCor = 0,
                pearsonPValue = 0)
  
  # For H2b, we need the number of distinct method invocations in the same class
  staticAnalysisCommitsClones$numberOfDistinctMethodInvocationsInSameClass = as.numeric(staticAnalysisCommitsClones$numberOfDistinctMethodInvocationsInSameClass)

  # All observations
  data <- staticAnalysisCommitsClones
  result$numObservations = nrow(data)
  tryCatch(
  expr = {
      if(nrow(data) < 5000) {
        normalityLeft <- shapiro.test(data$numberOfDistinctMethodInvocationsInSameClass)
        normalityRight <- shapiro.test(data$noCommitFixes)
      } else {
        normalityLeft <- shapiro.test(sample(data$numberOfDistinctMethodInvocationsInSameClass,5000))
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
      hKendall <- cor.test(data$numberOfDistinctMethodInvocationsInSameClass,
                   data$noCommitFixes,
                   method="kendall",
                   exact=FALSE)
      result$kendallTau <- hKendall$estimate
      result$kendallPValue <- hKendall$p.value
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
      hSpearman <- cor.test(data$numberOfDistinctMethodInvocationsInSameClass,
                            data$noCommitFixes,
                            method="spearman",
                            exact=FALSE)
      result$spearmanRho <- hSpearman$estimate
      result$spearmanPValue <- hSpearman$p.value
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
      hPearson <- cor.test(data$numberOfDistinctMethodInvocationsInSameClass,
                             data$noCommitFixes,
                             method="pearson")
      result$pearsonCor <- hPearson$estimate
      result$pearsonPValue <- hPearson$p.value
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

