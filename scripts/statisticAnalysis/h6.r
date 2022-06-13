# H6 Most test cases should be small in size (in terms of its lines of code).

# How to measure:
# - number of LOC in a test case AND number of bug fixes in its history
# In the paper, this corresponds to metrics: loc and bfCommits

testH6 <- function(locComplexityEntropyCommitsClones) {
  result = list(hipothesis = "h6",
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
  
  
  # For H6, we need the number of LOC
  locComplexityEntropyCommitsClones$CountLineCode = as.numeric(locComplexityEntropyCommitsClones$CountLineCode)

    # All observations
  data <- locComplexityEntropyCommitsClones
  result$numObservations = nrow(data)
  
  tryCatch(
  expr = {
      if(nrow(data) < 5000) {
        normalityLeft <- shapiro.test(data$CountLineCode)
        normalityRight <- shapiro.test(data$noCommitFixes)
      } else {
        normalityLeft <- shapiro.test(sample(data$CountLineCode,5000))
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
      hKendall <- cor.test(data$CountLineCode,
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
      hSpearman <- cor.test(data$CountLineCode,
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
      hPearson <- cor.test(data$CountLineCode,
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
  # <=0 and >1 = -9741
  # <=0 and >2 = -4500  
  # <=0 and >3 = -2203 
  # <=0 and >4 = -1534
  # <=0 and >5 = -791
  # <=0 and >6 = -221
  # <=0 and >7 = -19  !This is the best balancing
  # <=0 and >8 = 195
  
  result$conditionNumObservationsIneffective = "<=0"
  result$conditionNumObservationsEffective = ">7"
  
  dataIneffective <- data[data$noCommitFixes == 0,]
  dataEffective <- data[data$noCommitFixes >7,]
  
  result$numObservationsIneffective = nrow(dataIneffective)
  result$numObservationsEffective = nrow(dataEffective)
  result$balancing = nrow(dataIneffective)-nrow(dataEffective)
  
  w = wilcox.test(dataEffective$CountLineCode, dataIneffective$CountLineCode, paired = F)
  result$wilcox <- w$statistic
  result$wilcoxPvalue <- w$p.value
  resDelta <- cliff.delta(dataEffective$CountLineCode, dataIneffective$CountLineCode, paired = F)
  result$cliffDelta <- as.character(resDelta$magnitude)
  result$cliffEstimate <- resDelta$estimate  
  
  return(result)
}

