##------------------------------------------
## Author: Matina Fragkogianni
## Date: 5-11-2018
##
## A function that performs permutation testing on the class labels during training of the Random forest
## @param data_fr A data frame containing gene expression values and sample class information
## @param  variables A string vector of features
## @param  iter number of permutations
## @return A list of model accuracies during training and testing
## 
##------------------------------------------

random.class.perm.test <- function(data_fr, variables, iter = 100) {
  
  ##------------------------------------------
  # Source files
  ##------------------------------------------
  source(file = "helpFunctions/run.RF.R")
  
  TrainAccuracy <- c()
  TestAccuracy <- c()
  for (i in 1:iter) {
    data_rep <- data_fr[, variables]
    data_rep$class <- data_fr$class
    
    set.seed(i)
    # Step 1: Get row numbers for the training data
    trainRowNumbers <- createDataPartition(data_rep$class, p = 0.7, list = FALSE)
    
    # Step 2: Create the training  dataset
    trainData <- data_rep[trainRowNumbers, ]
    dim(trainData)
    
    # shuffle class labels and assign them to the trainData matrix
    random_class <-
      sample(trainData$class, length(trainData$class), FALSE)
    trainData$class <- random_class
    
    # Step 3: Create the test dataset
    testData <- data_rep[-trainRowNumbers, ]
    dim(testData)
    
    cat("Running RF-RFE")
    cat(i)
    cat("\n")
    rf.model <- run.RF(trainData = trainData)
    
    train.acc <- getTrainPerf(rf.model)[[1]]
    
    TrainAccuracy[i] <- train.acc
    
    p <- predict(rf.model, testData)
    pred.conf <- confusionMatrix(data = p, reference = testData$class)
    
    TestAccuracy[i] <- pred.conf$overall[[1]]
  }
  
  return(list("TrainAccuracy" = TrainAccuracy, "TestAccuracy" = TestAccuracy))
}
