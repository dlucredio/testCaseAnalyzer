library(ggplot2)
library(effsize)

# Set working directory
setwd("C:\\Users\\dlucr\\GitProjects\\testCaseAnalyzer")

# Load other scripts
debugSource("scripts/statisticAnalysis/h1.r")
debugSource("scripts/statisticAnalysis/h2a.r")
debugSource("scripts/statisticAnalysis/h2b.r")
debugSource("scripts/statisticAnalysis/h2c.r")
debugSource("scripts/statisticAnalysis/h3a.r")
debugSource("scripts/statisticAnalysis/h3b.r")
debugSource("scripts/statisticAnalysis/h3c.r")
debugSource("scripts/statisticAnalysis/h3d.r")
debugSource("scripts/statisticAnalysis/h6.r")
debugSource("scripts/statisticAnalysis/h7.r")
debugSource("scripts/statisticAnalysis/h10.r")
debugSource("scripts/statisticAnalysis/h14.r")
debugSource("scripts/statisticAnalysis/h18.r")

# Load files
staticAnalysisCommitsClones <- read.csv(file='files/staticAnalysisCommitsClones.csv', stringsAsFactors = FALSE)
staticAnalysisCommitsClonesCoverage <- read.csv(file='files/staticAnalysisCommitsClonesCoverage.csv', stringsAsFactors = FALSE)
locComplexityEntropyCommitsClones <- read.csv(file='files/locComplexityEntropyCommitsClones.csv', stringsAsFactors = FALSE)

# Let's separate only the data with commit data available
staticAnalysisCommitsClones <- staticAnalysisCommitsClones[staticAnalysisCommitsClones$hasCommitData == "yes", ]

# For all hypotheses, we need noCommitFixes, let's convert them to numeric
staticAnalysisCommitsClones$noCommitFixes = as.numeric(staticAnalysisCommitsClones$noCommitFixes)
staticAnalysisCommitsClonesCoverage$noCommitFixes = as.numeric(staticAnalysisCommitsClonesCoverage$noCommitFixes)
locComplexityEntropyCommitsClones$noCommitFixes = as.numeric(locComplexityEntropyCommitsClones$noCommitFixes)

# Initializing the result data frame
results <- data.frame()

print("Testing H1 for all projects")
results <- rbind(results, testH1(staticAnalysisCommitsClones))

print("Testing H2a for all projects")
results <- rbind(results, testH2a(staticAnalysisCommitsClones))

print("Testing H2b for all projects")
results <- rbind(results, testH2b(staticAnalysisCommitsClones))

print("Testing H2c for all projects")
results <- rbind(results, testH2c(staticAnalysisCommitsClones))

print("Testing H3a for all projects")
results <- rbind(results, testH3a(staticAnalysisCommitsClones))

print("Testing H3b for all projects")
results <- rbind(results, testH3b(staticAnalysisCommitsClones))

print("Testing H3c for all projects")
results <- rbind(results, testH3c(staticAnalysisCommitsClones))

print("Testing H3d for all projects")
results <- rbind(results, testH3d(staticAnalysisCommitsClones))

print("Testing H6 for all projects")
results <- rbind(results, testH6(locComplexityEntropyCommitsClones))

print("Testing H7 for all projects")
results <- rbind(results, testH7(locComplexityEntropyCommitsClones))

print("Testing H10 for all projects")
results <- rbind(results, testH10(locComplexityEntropyCommitsClones))

print("Testing H14 for all projects")
results <- rbind(results, testH14(staticAnalysisCommitsClonesCoverage))

print("Testing H18 for all projects")
results <- rbind(results, testH18(locComplexityEntropyCommitsClones))

print("Writing to CSV file")
write.csv(results,"files/analysisResults.csv", row.names = TRUE)


print("Done!")