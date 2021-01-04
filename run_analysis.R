#Cargar Features y Activity
features_labels <- read.table("./UCI HAR Dataset/features.txt")
activities_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Cargar train data

#train data
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt") 

#Descripcion de campos (STEP 4)
colnames(train_data) <- features$V2 

#agregar activity labels en train data
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt") 
train_data$activity <- activity_train$V1

#agregar subjects en train data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
train_data$subject <- factor(subject_train$V1)

#Cargar test data

#test data
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

#Descripcion de campos (STEP 4)
colnames(test_data) <- features$V2 

#agregar activity labels en test data
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
test_data$activity <- activity_test$V1

#agregar subjects en test data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_data$subject <- factor(subject_test$V1)

#union de train y test data (STEP 1)
union_data <- rbind(test_data, train_data)

#nombre columnas (STEP 2)
column.names <- colnames(union_data)

#Filtrar columnas con mean y std de la Data final (union_data)
column.names.filtered <- grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
dataset.filtered <- union_data[, column.names.filtered] 

#Añadir descriptivo de las actividades (STEP 3)
dataset.filtered$activitylabel <- factor(dataset.filtered$activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#Crear dataset agregado por cada Activity y Subject, tomando el promedio de cada variable
features.colnames = grep("std\\(\\)|mean\\(\\)", column.names, value=TRUE)
dataset.melt <-melt(dataset.filtered, id = c('activitylabel', 'subject'), measure.vars = features.colnames)
dataset.tidy <- dcast(dataset.melt, activitylabel + subject ~ variable, mean)

#Crear archivo de Data anterior 
write.table(dataset.tidy, file = "tidydataset.txt", row.names = FALSE)