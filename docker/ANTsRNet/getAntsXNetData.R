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
