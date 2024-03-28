library(ggplot2)
library(effsize)
library(Hmisc) 

# Set working directory
setwd("/Users/dlucr/GitProjects/testCaseAnalyzer")

# Load other scripts
debugSource("scripts/statisticAnalysis/gp1.r")
debugSource("scripts/statisticAnalysis/gp2a.r")
debugSource("scripts/statisticAnalysis/gp2b.r")
debugSource("scripts/statisticAnalysis/gp3a.r")
debugSource("scripts/statisticAnalysis/gp3b.r")
debugSource("scripts/statisticAnalysis/gp4a.r")
debugSource("scripts/statisticAnalysis/gp4b.r")
debugSource("scripts/statisticAnalysis/gp5.r")
debugSource("scripts/statisticAnalysis/gp6.r")
debugSource("scripts/statisticAnalysis/gp7.r")

# Load file
dataset <- read.csv(file='files/mergedFinal.csv', stringsAsFactors = FALSE)

# For all hypotheses, we need noCommitFixes, let's convert them to numeric
dataset$noCommitFixes = as.numeric(dataset$noCommitFixes)

# Let's separate only the data with all data available
dataset <- dataset[dataset$hasLocComplexityEntropy == "yes", ]
#dataset <- dataset[dataset$hasCommitData == "yes", ]

# For GP1, we need to sum assertions with expected exceptions
dataset$numberOfAssertionsWithRecursion = as.numeric(dataset$numberOfAssertionsWithRecursion)
dataset$numberOfDistinctExpectedExceptions = as.numeric(dataset$numberOfDistinctExpectedExceptions)
dataset$finalNumberOfAssertions = dataset$numberOfAssertionsWithRecursion + dataset$numberOfDistinctExpectedExceptions

# For GP2a, we need the number of distinct method invocations
dataset$numberOfDistinctMethodInvocations = as.numeric(dataset$numberOfDistinctMethodInvocations)

# For GP2b, we need the number of distinct method invocations in the same class
dataset$numberOfDistinctMethodInvocationsInSameClass = as.numeric(dataset$numberOfDistinctMethodInvocationsInSameClass)

# For GP2c, we need the number of distinct test case invocations in the same class
dataset$numberOfDistinctTestCaseMethodInvocationsInSameClass = as.numeric(dataset$numberOfDistinctTestCaseMethodInvocationsInSameClass)

# For GP3a, we need the number of exceptions being thrown in a test case
dataset$numberOfExceptionsThrown = as.numeric(dataset$numberOfExceptionsThrown)

# For GP3b, we need the number of exceptions being expected or caught in a test case
dataset$numberOfExceptionsThrownAndCaughtPartial = as.numeric(dataset$numberOfExceptionsThrownAndCaughtPartial)
dataset$numberOfExceptionsThrownAndCaughtExact = as.numeric(dataset$numberOfExceptionsThrownAndCaughtExact)
dataset$numberOfDistinctExpectedExceptions = as.numeric(dataset$numberOfDistinctExpectedExceptions)
dataset$totalExceptions = dataset$numberOfExceptionsThrownAndCaughtPartial + dataset$numberOfExceptionsThrownAndCaughtExact + dataset$numberOfDistinctExpectedExceptions

# For GP4a, we need the number of LOC
dataset$CountLineCode = as.numeric(dataset$CountLineCode)

# For GP7, we need the cyclomatic complexity
dataset$Cyclomatic = as.numeric(dataset$Cyclomatic)

# For GP5, we need the coverage
dataset$LINE_covered = as.numeric(dataset$LINE_covered)

# For GP4b and GP6, we need readability, which is measured based on entropy
dataset$halsteadVolume = as.numeric(dataset$halsteadVolume)
dataset$CountLineCode = as.numeric(dataset$CountLineCode)
dataset$entropy = as.numeric(dataset$entropy)
dataset$readability = 8.87 - 0.033 * dataset$halsteadVolume + 0.4 * dataset$CountLineCode - 1.5 * dataset$entropy

write.csv(table(dataset$noCommitFixes),"./files/dataset.csv")

nrow(dataset)

# Balancing
# <=1 and >1 = -1701
# <=1 and >2 = 457 <- This is the best balancing
# <=1 and >3 = 1145

dataIneffective <- dataset[dataset$noCommitFixes <=0,]
dataEffective <- dataset[dataset$noCommitFixes >=1,]
nrow(dataIneffective)
nrow(dataEffective)
nrow(dataIneffective)-nrow(dataEffective)

# This next dataset involves readability. This is a metric with
# continues values, therefore we can split the data into
# readable vs unreadable by looking at the quartiles
quantile(dataset$readability)

# This yields the following separation
dataUnreadable <- dataset[dataset$readability < -7.373041,]
dataReadable <- dataset[dataset$readability > 2.437962,]

# Balancing
# <=1 and >1 = -1564
# <=1 and >2 = 56 <- this is the best balancing
# <=1 and >2 = 484
datasetCoverage <- dataset[dataset$hasCoverageData=="yes",]
nrow(datasetCoverage)
dataCoverageIneffective <- datasetCoverage[datasetCoverage$noCommitFixes <= 1,]
dataCoverageEffective <- datasetCoverage[datasetCoverage$noCommitFixes > 2,]
nrow(dataCoverageIneffective)
nrow(dataCoverageEffective)
nrow(dataCoverageIneffective)-nrow(dataCoverageEffective)

# Initializing the result data frame
results <- data.frame()

print("Testing GP1 for all projects")
results <- rbind(results, testGP1(dataEffective, dataIneffective))

print("Testing GP2a for all projects")
results <- rbind(results, testGP2a(dataEffective, dataIneffective))

print("Testing GP2b for all projects")
results <- rbind(results, testGP2b(dataEffective, dataIneffective))

print("Testing GP3a for all projects")
results <- rbind(results, testGP3a(dataEffective, dataIneffective))

print("Testing GP3b for all projects")
results <- rbind(results, testGP3b(dataEffective, dataIneffective))

print("Testing GP4a for all projects")
results <- rbind(results, testGP4a(dataEffective, dataIneffective))

print("Testing GP4b for all projects")
results <- rbind(results, testGP4b(dataReadable, dataUnreadable))

print("Testing GP5 for all projects")
results <- rbind(results, testGP5(dataCoverageEffective, dataCoverageIneffective))

print("Testing GP6 for all projects")
results <- rbind(results, testGP6(dataEffective, dataIneffective))

print("Testing GP7 for all projects")
results <- rbind(results, testGP7(dataEffective, dataIneffective))

print("Writing to CSV file")
write.csv(results,"files/analysisResults.csv", row.names = TRUE)

print("Done!")

