# H7 Large test cases are often hard to understand and maintain.

# How to measure:
# - number of LOC in a test case AND Cyclomatic complexity
# In the paper, this corresponds to metrics: loc and cycl

testH7 <- function(locComplexityEntropyCommitsClones) {
  result = list(hipothesis = "h7",
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
  
  
  # For H7, we need the number of LOC and cyclomatic complexity
  locComplexityEntropyCommitsClones$CountLineCode = as.numeric(locComplexityEntropyCommitsClones$CountLineCode)
  locComplexityEntropyCommitsClones$Cyclomatic = as.numeric(locComplexityEntropyCommitsClones$Cyclomatic)
  

  # All observations
  data <- locComplexityEntropyCommitsClones
  result$numObservations = nrow(data)
  
  tryCatch(
  expr = {
      if(nrow(data) < 5000) {
        normalityLeft <- shapiro.test(data$CountLineCode)
        normalityRight <- shapiro.test(data$Cyclomatic)
      } else {
        normalityLeft <- shapiro.test(sample(data$CountLineCode,5000))
        normalityRight <- shapiro.test(sample(data$Cyclomatic,5000))
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
                   data$Cyclomatic,
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
                            data$Cyclomatic,
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
                             data$Cyclomatic,
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
  
  ggplot(data,aes(Cyclomatic,Cyclomatic))+geom_bar(stat="identity",width=1)
 
   # Balancing
  # <=1 and >1 = 21277   !This is the best balancing (the only one possible, actually)
  # <=0 and >2 = 21983  

    result$conditionNumObservationsIneffective = "<=1"
  result$conditionNumObservationsEffective = ">1"
  
  dataIneffective <- data[data$Cyclomatic <= 1,]
  dataEffective <- data[data$Cyclomatic >1,]
  
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

