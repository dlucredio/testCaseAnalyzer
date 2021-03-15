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

# Load files
staticAnalysisCommitsClones <- read.csv(file='files/staticAnalysisCommitsClones.csv', stringsAsFactors = FALSE)
staticAnalysisCommitsClonesCoverage <- read.csv(file='files/staticAnalysisCommitsClonesCoverage.csv', stringsAsFactors = FALSE)
locComplexityEntropyCommitsClones <- read.csv(file='files/locComplexityEntropyCommitsClones.csv', stringsAsFactors = FALSE)

# Let's separate only the data with commit data available
staticAnalysisCommitsClones <- staticAnalysisCommitsClones[staticAnalysisCommitsClones$hasCommitData == "yes", ]

# Let's calculate additional columns needed for the hypotheses and convert data types

# For all hypotheses, we need noCommitFixes
staticAnalysisCommitsClones$noCommitFixes = as.numeric(staticAnalysisCommitsClones$noCommitFixes)
staticAnalysisCommitsClonesCoverage$noCommitFixes = as.numeric(staticAnalysisCommitsClonesCoverage$noCommitFixes)
locComplexityEntropyCommitsClones$noCommitFixes = as.numeric(locComplexityEntropyCommitsClones$noCommitFixes)

resulth1 <- data.frame()
resulth2a <- data.frame()
resulth2b <- data.frame()
resulth2c <- data.frame()
resulth3a <- data.frame()
resulth3b <- data.frame()
resulth3c <- data.frame()
resulth3d <- data.frame()

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

print("Writing to CSV files")

write.csv(resulth1,"files/analysisResultH1.csv", row.names = TRUE)
write.csv(resulth2a,"files/analysisResultH2a.csv", row.names = TRUE)
write.csv(resulth2b,"files/analysisResultH2b.csv", row.names = TRUE)
write.csv(resulth2c,"files/analysisResultH2c.csv", row.names = TRUE)
write.csv(resulth3a,"files/analysisResultH3a.csv", row.names = TRUE)
write.csv(resulth3b,"files/analysisResultH3b.csv", row.names = TRUE)
write.csv(resulth3c,"files/analysisResultH3c.csv", row.names = TRUE)
write.csv(resulth3d,"files/analysisResultH3d.csv", row.names = TRUE)

print("Done!")