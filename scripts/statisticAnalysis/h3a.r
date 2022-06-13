# H3 Good test cases should check for normal and exceptional flow.

# How to measure:
# - number of methods invoked with exception handling in a test case AND number of bug fixes in its history
# - all observations
# In the paper, this corresponds to metrics: invWithEx and bfCommits


testH3a <- function(staticAnalysisCommitsClones) {
  result = list(hipothesis = "h3a",
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
  
  
  # For H3a, we need the number of exceptions being thrown in a test case
  staticAnalysisCommitsClones$numberOfExceptionsThrown = as.numeric(staticAnalysisCommitsClones$numberOfExceptionsThrown)

  # All observations
  data <- staticAnalysisCommitsClones
  result$numObservations = nrow(data)
  tryCatch(
  expr = {
      if(nrow(data) < 5000) {
        normalityLeft <- shapiro.test(data$numberOfExceptionsThrown)
        normalityRight <- shapiro.test(data$noCommitFixes)
      } else {
        normalityLeft <- shapiro.test(sample(data$numberOfExceptionsThrown,5000))
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
      hKendall <- cor.test(data$numberOfExceptionsThrown,
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
      hSpearman <- cor.test(data$numberOfExceptionsThrown,
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
      hPearson <- cor.test(data$numberOfExceptionsThrown,
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
  # <=0 and >3 = -385  !This is the best balancing
  # <=0 and >4 = 402

  result$conditionNumObservationsIneffective = "<=0"
  result$conditionNumObservationsEffective = ">3"
  
  dataIneffective <- data[data$noCommitFixes == 0,]
  dataEffective <- data[data$noCommitFixes >3,]
  
  result$numObservationsIneffective = nrow(dataIneffective)
  result$numObservationsEffective = nrow(dataEffective)
  result$balancing = nrow(dataIneffective)-nrow(dataEffective)
  
  w = wilcox.test(dataEffective$numberOfExceptionsThrown, dataIneffective$numberOfExceptionsThrown, paired = F)
  result$wilcox <- w$statistic
  result$wilcoxPvalue <- w$p.value
  resDelta <- cliff.delta(dataEffective$numberOfExceptionsThrown, dataIneffective$numberOfExceptionsThrown, paired = F)
  result$cliffDelta <- as.character(resDelta$magnitude)
  result$cliffEstimate <- resDelta$estimate
  
  return(result)
}

