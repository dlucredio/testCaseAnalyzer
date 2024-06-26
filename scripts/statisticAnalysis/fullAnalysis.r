# Set working directory
setwd("~/GitProjects/testCaseAnalyzer")

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

# Initializing the result data frames
resulth1 <- data.frame()
resulth2a <- data.frame()
resulth2b <- data.frame()
resulth2c <- data.frame()
resulth3a <- data.frame()
resulth3b <- data.frame()
resulth3c <- data.frame()
resulth3d <- data.frame()
resulth6 <- data.frame()
resulth7 <- data.frame()
resulth10 <- data.frame()
resulth14 <- data.frame()
resulth18 <- data.frame()

# First, for all projects together
print("Testing H1 for all projects")
h = testH1(staticAnalysisCommitsClones)
resulth1 <- rbind(resulth1, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H2a for all projects")
h = testH2a(staticAnalysisCommitsClones)
resulth2a <- rbind(resulth2a, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H2b for all projects")
h = testH2b(staticAnalysisCommitsClones)
resulth2b <- rbind(resulth2b, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H2c for all projects")
h = testH2c(staticAnalysisCommitsClones)
resulth2c <- rbind(resulth2c, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H3a for all projects")
h = testH3a(staticAnalysisCommitsClones)
resulth3a <- rbind(resulth3a, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H3b for all projects")
h = testH3b(staticAnalysisCommitsClones)
resulth3b <- rbind(resulth3b, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H3c for all projects")
h = testH3c(staticAnalysisCommitsClones)
resulth3c <- rbind(resulth3c, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H3d for all projects")
h = testH3d(staticAnalysisCommitsClones)
resulth3d <- rbind(resulth3d, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H6 for all projects")
h = testH6(locComplexityEntropyCommitsClones)
resulth6 <- rbind(resulth6, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H7 for all projects")
h = testH7(locComplexityEntropyCommitsClones)
resulth7 <- rbind(resulth7, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H10 for all projects")
h = testH10(locComplexityEntropyCommitsClones)
resulth10 <- rbind(resulth10, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H14 for all projects")
h = testH14(staticAnalysisCommitsClonesCoverage)
resulth14 <- rbind(resulth14, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

print("Testing H18 for all projects")
h = testH18(locComplexityEntropyCommitsClones)
resulth18 <- rbind(resulth18, data.frame(project="all",obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

projects <- unique(staticAnalysisCommitsClones$mainProjectName)
for (p in projects) {
  print(sprintf("Testing H1 for project %s",p))
  h = testH1(staticAnalysisCommitsClones[staticAnalysisCommitsClones$mainProjectName == p,])
  resulth1 <- rbind(resulth1, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))
  
  print(sprintf("Testing H2a for project %s",p))
  h = testH2a(staticAnalysisCommitsClones[staticAnalysisCommitsClones$mainProjectName == p,])
  resulth2a <- rbind(resulth2a, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))
  
  print(sprintf("Testing H2b for project %s",p))
  h = testH2b(staticAnalysisCommitsClones[staticAnalysisCommitsClones$mainProjectName == p,])
  resulth2b <- rbind(resulth2b, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

  print(sprintf("Testing H2c for project %s",p))
  h = testH2c(staticAnalysisCommitsClones[staticAnalysisCommitsClones$mainProjectName == p,])
  resulth2c <- rbind(resulth2c, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

  print(sprintf("Testing H3a for project %s",p))
  h = testH3a(staticAnalysisCommitsClones[staticAnalysisCommitsClones$mainProjectName == p,])
  resulth3a <- rbind(resulth3a, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

  print(sprintf("Testing H3b for project %s",p))
  h = testH3b(staticAnalysisCommitsClones[staticAnalysisCommitsClones$mainProjectName == p,])
  resulth3b <- rbind(resulth3b, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

  print(sprintf("Testing H3c for project %s",p))
  h = testH3c(staticAnalysisCommitsClones[staticAnalysisCommitsClones$mainProjectName == p,])
  resulth3c <- rbind(resulth3c, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

  print(sprintf("Testing H3d for project %s",p))
  h = testH3d(staticAnalysisCommitsClones[staticAnalysisCommitsClones$mainProjectName == p,])
  resulth3d <- rbind(resulth3d, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))
}

projects <- unique(locComplexityEntropyCommitsClones$projectName)
for (p in projects) {
  print(sprintf("Testing H6 for project %s",p))
  h = testH6(locComplexityEntropyCommitsClones[locComplexityEntropyCommitsClones$projectName == p,])
  resulth6 <- rbind(resulth6, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

  print(sprintf("Testing H7 for project %s",p))
  h = testH7(locComplexityEntropyCommitsClones[locComplexityEntropyCommitsClones$projectName == p,])
  resulth7 <- rbind(resulth7, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

  print(sprintf("Testing H10 for project %s",p))
  h = testH10(locComplexityEntropyCommitsClones[locComplexityEntropyCommitsClones$projectName == p,])
  resulth10 <- rbind(resulth10, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

  print(sprintf("Testing H18 for project %s",p))
  h = testH18(locComplexityEntropyCommitsClones[locComplexityEntropyCommitsClones$projectName == p,])
  resulth18 <- rbind(resulth18, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))
}

projects <- unique(staticAnalysisCommitsClonesCoverage$mainProjectName)
for (p in projects) {
  print(sprintf("Testing H14 for project %s",p))
  h = testH14(staticAnalysisCommitsClonesCoverage[staticAnalysisCommitsClonesCoverage$mainProjectName == p,])
  resulth14 <- rbind(resulth14, data.frame(project=p,obs=h$numObservations,normalityLeft=h$normalityLeft,normalityRight=h$normalityRight,kendallTau=h$kendallTau,kendallPValue=h$kendallPValue,spearmanRho=h$spearmanRho,spearmanPValue=h$spearmanPValue,pearsonCor=h$pearsonCor,pearsonPValue=h$pearsonPValue))

}

print("Writing to CSV files")

write.csv(resulth1,"files/analysisResultH01.csv", row.names = TRUE)
write.csv(resulth2a,"files/analysisResultH02a.csv", row.names = TRUE)
write.csv(resulth2b,"files/analysisResultH02b.csv", row.names = TRUE)
write.csv(resulth2c,"files/analysisResultH02c.csv", row.names = TRUE)
write.csv(resulth3a,"files/analysisResultH03a.csv", row.names = TRUE)
write.csv(resulth3b,"files/analysisResultH03b.csv", row.names = TRUE)
write.csv(resulth3c,"files/analysisResultH03c.csv", row.names = TRUE)
write.csv(resulth3d,"files/analysisResultH03d.csv", row.names = TRUE)
write.csv(resulth6,"files/analysisResultH06.csv", row.names = TRUE)
write.csv(resulth7,"files/analysisResultH07.csv", row.names = TRUE)
write.csv(resulth10,"files/analysisResultH10.csv", row.names = TRUE)
write.csv(resulth14,"files/analysisResultH14.csv", row.names = TRUE)
write.csv(resulth18,"files/analysisResultH18.csv", row.names = TRUE)

print("Done!")