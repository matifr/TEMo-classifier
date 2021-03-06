##------------------------------------------
## Author: Matina Fragkogianni
## Date: 1-10-2018
##
## A function to import and process a public dataset of isolated monocytes from periodontitis samples
## @param predictors A string vector of predictor features
## @return A dataframe containing gene expression and sample class information
## 
##------------------------------------------
  
periodontitis.data <- function(predictors){
  ##------------------------------------------
  # Load libraries
  ##------------------------------------------
  require(edgeR)
  require(caret)
  
  ##------------------------------------------
  # Source files
  ##------------------------------------------
  source(file = "helpFunctions//remove.dots.R")
  
  #### Load the DGE object containing the periodontitis dataset
  load(file = "Data/periodontitis_dge_obj.Rdata")
  
  d <- calcNormFactors(d, method = "upperquartile") 
  nrmData <- cpm(d,log=TRUE,prior.count=1)
  
  
  rownames(nrmData) <- remove.dots(nrmData)
  cat(paste("Number of predictors in the data: ",sum(rownames(nrmData) %in% predictors)))
  
  #### Create data frame for the data
  periodTestData <- t(nrmData)
  periodTestDataClass <- d$samples$group
  periodTestData <- data.frame(periodTestData, class = periodTestDataClass)
  
  return(periodTestData)
}