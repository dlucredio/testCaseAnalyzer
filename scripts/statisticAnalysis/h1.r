# H1 A good test case is specific or atomic, i.e.,
# one test case should be testing one aspect of a requirement.

# How to measure:
# - number of assertions in a test case AND number of bug fixes in its history
# - But only observations with at least one assertion.
#   Some test cases did not have assertions accounted,
#   because they use an assert framework not considered
#   here (Junit, Truth, AssertJ, Hamcrest), or because
#   the assertion is too deep in the call hierarchy

testH1 <- function(staticAnalysisCommitsClones) {
  result = list(numObservations = 0,
                normalityLeft = 0,
                normalityRight = 0,
                kendallTau = 0,
                kendallPValue = 0,
                spearmanRho = 0,
                spearmanPValue = 0,
                pearsonCor = 0,
                pearsonPValue = 0)

  # For H1, we need to sum assertions with expected exceptions
  staticAnalysisCommitsClones$numberOfAssertionsWithRecursion = as.numeric(staticAnalysisCommitsClones$numberOfAssertionsWithRecursion)
  staticAnalysisCommitsClones$numberOfDistinctExpectedExceptions = as.numeric(staticAnalysisCommitsClones$numberOfDistinctExpectedExceptions)
  staticAnalysisCommitsClones$finalNumberOfAssertions = staticAnalysisCommitsClones$numberOfAssertionsWithRecursion + staticAnalysisCommitsClones$numberOfDistinctExpectedExceptions

  # Only observations with at least one assertion
  data <- staticAnalysisCommitsClones[staticAnalysisCommitsClones$finalNumberOfAssertions != 0,]
  
  result$numObservations = nrow(data)
  tryCatch(
  expr = {
      if(nrow(data) < 5000) {
        normalityLeft <- shapiro.test(data$finalNumberOfAssertions)
        normalityRight <- shapiro.test(data$noCommitFixes)
      } else {
        normalityLeft <- shapiro.test(sample(data$finalNumberOfAssertions,5000))
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
      hKendall <- cor.test(data$finalNumberOfAssertions,
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
      hSpearman <- cor.test(data$finalNumberOfAssertions,
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
      hPearson <- cor.test(data$finalNumberOfAssertions,
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

