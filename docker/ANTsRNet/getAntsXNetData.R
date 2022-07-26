#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0) {
    print("Usage: getANTsXNetData /path/to/data [doInstall=1]")
    exit(1)
}

outputDir = args[1]
doInstall = args[2]

if (doInstall == 0) {
    exit(0)
}

dataPath = paste("outputDir", "ANTsXNet", sep="/")

library(ANTsRNet)

allData = ANTsRNet::getANTsXNetData()
allData = allData[-which(allData == "show")]

for (entry in allData) {
  print(paste("Downloading", entry, sep = " "))
  ANTsRNet::getANTsXNetData(entry, antsxnetCacheDirectory=dataPath)
}
allNetworks = ANTsRNet::getPretrainedNetwork()
allNetworks = allNetworks[-which(allNetworks == "sixTissueOctantBrainSegmentationWithPriors2")]
allNetworks = allNetworks[-which(allNetworks == "show")]

for (entry in allNetworks) {
  print(paste("Downloading", entry, sep = " "))
  ANTsRNet::getPretrainedNetwork(entry, antsxnetCacheDirectory=dataPath)
}