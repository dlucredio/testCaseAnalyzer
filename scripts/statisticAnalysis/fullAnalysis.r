library(ggplot2)
library(effsize)
library(Hmisc)

# Set working directory
setwd("C:\\Users\\dlucr\\GitProjects\\testCaseAnalyzer")

# Load other scripts
debugSource("scripts/statisticAnalysis/h1.r")
debugSource("scripts/statisticAnalysis/h2a.r")
debugSource("scripts/statisticAnalysis/h2b.r")
debugSource("scripts/statisticAnalysis/h3a.r")
debugSource("scripts/statisticAnalysis/h3b.r")
debugSource("scripts/statisticAnalysis/h6.r")
debugSource("scripts/statisticAnalysis/h7.r")
debugSource("scripts/statisticAnalysis/h10.r")
debugSource("scripts/statisticAnalysis/h14.r")
debugSource("scripts/statisticAnalysis/h18.r")

# Load file
dataset <- read.csv(file='files/mergedFinal.csv', stringsAsFactors = FALSE)

# For all hypotheses, we need noCommitFixes, let's convert them to numeric
dataset$noCommitFixes = as.numeric(dataset$noCommitFixes)

# Let's separate only the data with all data available
dataset <- dataset[dataset$hasCommitData == "yes", ]
dataset <- dataset[dataset$hasLocComplexityEntropy == "yes", ]

# For H1, we need to sum assertions with expected exceptions
dataset$numberOfAssertionsWithRecursion = as.numeric(dataset$numberOfAssertionsWithRecursion)
dataset$numberOfDistinctExpectedExceptions = as.numeric(dataset$numberOfDistinctExpectedExceptions)
dataset$finalNumberOfAssertions = dataset$numberOfAssertionsWithRecursion + dataset$numberOfDistinctExpectedExceptions

# For H2a, we need the number of distinct method invocations
dataset$numberOfDistinctMethodInvocations = as.numeric(dataset$numberOfDistinctMethodInvocations)

# For H2b, we need the number of distinct method invocations in the same class
dataset$numberOfDistinctMethodInvocationsInSameClass = as.numeric(dataset$numberOfDistinctMethodInvocationsInSameClass)

# For H2c, we need the number of distinct test case invocations in the same class
dataset$numberOfDistinctTestCaseMethodInvocationsInSameClass = as.numeric(dataset$numberOfDistinctTestCaseMethodInvocationsInSameClass)

# For H3a, we need the number of exceptions being thrown in a test case
dataset$numberOfExceptionsThrown = as.numeric(dataset$numberOfExceptionsThrown)

# For H3c abd H3d, we need the number of exceptions being expected or caught in a test case
dataset$numberOfExceptionsThrownAndCaughtPartial = as.numeric(dataset$numberOfExceptionsThrownAndCaughtPartial)
dataset$numberOfExceptionsThrownAndCaughtExact = as.numeric(dataset$numberOfExceptionsThrownAndCaughtExact)
dataset$numberOfDistinctExpectedExceptions = as.numeric(dataset$numberOfDistinctExpectedExceptions)
dataset$totalExceptions = dataset$numberOfExceptionsThrownAndCaughtPartial + dataset$numberOfExceptionsThrownAndCaughtExact + dataset$numberOfDistinctExpectedExceptions

# For H6, we need the number of LOC
dataset$CountLineCode = as.numeric(dataset$CountLineCode)

# For H7 and H10, we need the cyclomatic complexity
dataset$Cyclomatic = as.numeric(dataset$Cyclomatic)

# For H14, we need the coverage
dataset$LINE_covered = as.numeric(dataset$LINE_covered)

# For H18, we need readability, which is measured based on entropy
dataset$halsteadVolume = as.numeric(dataset$halsteadVolume)
dataset$CountLineCode = as.numeric(dataset$CountLineCode)
dataset$entropy = as.numeric(dataset$entropy)
dataset$readability = 8.87 - 0.033 * dataset$halsteadVolume + 0.4 * dataset$CountLineCode - 1.5 * dataset$entropy

write.csv(table(dataset$noCommitFixes),"./files/dataset.csv")


# Balancing
# <=0 and >1 = -9741
# <=0 and >2 = -4500  
# <=0 and >3 = -2203 
# <=0 and >4 = -1534
# <=0 and >5 = -791
# <=0 and >6 = -221
# <=0 and >7 = -19  !This is the best balancing
# <=0 and >8 = 195

dataIneffective <- dataset[dataset$noCommitFixes <=0,]
dataEffective <- dataset[dataset$noCommitFixes >5,]
nrow(dataIneffective)-nrow(dataEffective)

dataSimple <- dataset[dataset$Cyclomatic <=1,]
dataComplex <- dataset[dataset$Cyclomatic >1,]
nrow(dataSimple)-nrow(dataComplex)

datasetCoverage <- dataset[dataset$hasCoverageData=="yes",]
dataCoverageIneffective <- datasetCoverage[datasetCoverage$noCommitFixes <= 0,]
dataCoverageEffective <- datasetCoverage[datasetCoverage$noCommitFixes > 5,]
nrow(dataCoverageIneffective)-nrow(dataCoverageEffective)

# Initializing the result data frame
results <- data.frame()

print("Testing H1 for all projects")
results <- rbind(results, testH1(dataEffective, dataIneffective))

print("Testing H2a for all projects")
results <- rbind(results, testH2a(dataEffective, dataIneffective))

print("Testing H2b for all projects")
results <- rbind(results, testH2b(dataEffective, dataIneffective))

print("Testing H3a for all projects")
results <- rbind(results, testH3a(dataEffective, dataIneffective))

print("Testing H3b for all projects")
results <- rbind(results, testH3b(dataEffective, dataIneffective))

print("Testing H6 for all projects")
results <- rbind(results, testH6(dataEffective, dataIneffective))

print("Testing H7 for all projects")
results <- rbind(results, testH7(dataset))

print("Testing H10 for all projects")
results <- rbind(results, testH10(dataEffective, dataIneffective))

print("Testing H14 for all projects")
results <- rbind(results, testH14(dataCoverageEffective, dataCoverageIneffective))

print("Testing H18 for all projects")
results <- rbind(results, testH18(dataEffective, dataIneffective))

print("Writing to CSV file")
write.csv(results,"files/analysisResults.csv", row.names = TRUE)

print("Done!")