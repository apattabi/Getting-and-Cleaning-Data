###Reading features into data frame features_info
features_info<-read.table("features.txt",sep="")
##Reading activity labels into activity_labels dataframe
activty_labels<-read.table("activity_labels.txt")
##Reading train and test DFs
X_train<-read.table("train/X_train.txt")
X_test<-read.table("test/X_test.txt")
##Combining the train and test data
X_train_test<-rbind(X_train,X_test)
###Naming the variables of train and test data-561 variables
names(X_train_test)<-features_info$V2
##Filtering variable names only that has mean or std included in the name
mean_std_cols<-grep("mean|std",names(X_train_test))
##Filtering the data with only mean and std deviation column
X_mean_std<-X_train_test[,mean_std_cols]

##Combining y_train and y_test
y_train<-read.table("train/y_train.txt")
y_test<-read.table("test/y.test.txt")
y_train_test<-rbind(y_train,y_test)
###Converting the activity numbers to labels by using activity label dataframe in y_train_test data
y_train_test$V1<-factor(y_train_test$V1,labels=activty_labels$V2)
###Naming the variable in y_train_test to "activity"
names(y_train_test)<-c("activity")

##Combining X and Y data
data_XY_mean_std<-cbind(X_mean_std,y_train_test)

###Reading subjects and adding to the main data frame
subject_train<-read.table("train/subject_train.txt")
subject_test<-read.table("test/subject_test.txt")
subjects_train_test<-rbind(subject_train,subject_test)

##Combining the subjects info to form untidy_data_frame
untidy_data_set<-cbind(data_XY_mean_std,subjects_train_test)
###Converting subjects variable to factor
untidy_data_set$V1<-factor(untidy_data_set$V1)
###Removing brackets and minus signs from variable names
names(untidy_data_set)<-gsub("\\(\\)","",names(untidy_data_set))
names(untidy_data_set)<-gsub("-","_",names(untidy_data_set))
###Naming V1 variable to Subject
untidy_data_set<-rename(untidy_data_set,Subject=V1)

##variable names which has mean and std as part of the name
var_names<-grep("mean|std",names(untidy_data_set),value=TRUE)
###Reshaping the data with IDs as activity and subject
melt_untidy<-melt(untidy_data_set,id=c("activity","Subject"),measure.vars=var_names)

##Creating tidy data frame : for every subject, for every activity, mean of other variables.
tidy_data<-dcast(melt_untidy,Subject+activity~variable,mean)

##Saving it to a txt file.
write.table(tidy_data,file="tidydataset.txt",row.names=FALSE)

