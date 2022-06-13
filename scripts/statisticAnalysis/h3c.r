# H3 Good test cases should check for normal and exceptional flow.

# How to measure:
# - Number of exceptions being caught or expected AND number of bug fixes in its history
# - All observations
# In the paper, this corresponds to metrics: invWithExC and bfCommits

testH3c <- function(staticAnalysisCommitsClones) {
  result = list(hipothesis = "h3c",
                numObservations = 0,
                normalityLeft = 0,
                normalityRight = 0,
                kendallTau = 0,
                kendallPValue = 0,
                spearmanRho = 0,
                spearmanPValue = 0,
                pearsonCor = 0,
                pearsonPValue = 0,
                numObservationsIneffective = 0,
                numObservationsEffective = 0,
                conditionNumObservationsIneffective = "",
                conditionNumObservationsEffective = "")  
  
  
  # For H3c, we need the number of exceptions being expected or caught in a test case
  staticAnalysisCommitsClones$numberOfExceptionsThrownAndCaughtPartial = as.numeric(staticAnalysisCommitsClones$numberOfExceptionsThrownAndCaughtPartial)
  staticAnalysisCommitsClones$numberOfExceptionsThrownAndCaughtExact = as.numeric(staticAnalysisCommitsClones$numberOfExceptionsThrownAndCaughtExact)
  staticAnalysisCommitsClones$numberOfDistinctExpectedExceptions = as.numeric(staticAnalysisCommitsClones$numberOfDistinctExpectedExceptions)
  staticAnalysisCommitsClones$totalExceptions = staticAnalysisCommitsClones$numberOfExceptionsThrownAndCaughtPartial + staticAnalysisCommitsClones$numberOfExceptionsThrownAndCaughtExact + staticAnalysisCommitsClones$numberOfDistinctExpectedExceptions
  
  # All observations
  data <- staticAnalysisCommitsClones

  result$numObservations = nrow(data)
  tryCatch(
  expr = {
      if(nrow(data) < 5000) {
        normalityLeft <- shapiro.test(data$totalExceptions)
        normalityRight <- shapiro.test(data$noCommitFixes)
      } else {
        normalityLeft <- shapiro.test(sample(data$totalExceptions,5000))
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
      hKendall <- cor.test(data$totalExceptions,
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
      hSpearman <- cor.test(data$totalExceptions,
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
      hPearson <- cor.test(data$totalExceptions,
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
  
  ggplot(data,aes(noCommitFixes,noCommitFixes))+geom_bar(stat="identity",width=1)
  
  # Balancing
  # <=0 and >2 = -2014  
  # <=0 and >3 = -385 !This is the best balancing
  # <=0 and >4 = 402 
  
  result$conditionNumObservationsIneffective = "<=0"
  result$conditionNumObservationsEffective = ">3"
  
  dataIneffective <- data[data$noCommitFixes == 0,]
  dataEffective <- data[data$noCommitFixes >3,]
  
  result$numObservationsIneffective = nrow(dataIneffective)
  result$numObservationsEffective = nrow(dataEffective)
  result$balancing = nrow(dataIneffective)-nrow(dataEffective)
  
  w = wilcox.test(dataEffective$totalExceptions, dataIneffective$totalExceptions, paired = F)
  result$wilcox <- w$statistic
  result$wilcoxPvalue <- w$p.value
  resDelta <- cliff.delta(dataEffective$totalExceptions, dataIneffective$totalExceptions, paired = F)
  result$cliffDelta <- as.character(resDelta$magnitude)
  result$cliffEstimate <- resDelta$estimate
  
  return(result)
}

