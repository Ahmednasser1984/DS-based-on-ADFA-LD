
clear all
clc
close all
dataset=load('ndata.mat');
dataset=dataset.dataset;
normdataset=zscore(dataset(:,1:10));
tclass=[];
tout=[];


class=dataset(:,11);
rt1=[];
rt2=[];
rt3=0;
nof=3;

qqq=[];
sss=[];
knnt=[];
svmt=[];
nbt=[];
trrt=[];
knntt=[];
svmtt=[];
nbtt=[];
trrtt=[];
% mRMR feature selection
if 0
fea=mrmr_mid_d(X, class', 5);
end
% Rough set feature selection
if 0
if_fuzzy=0;
neighbor=0.15;
inclusion=0.8;
fea=fs_neighbor(dataset,if_fuzzy,neighbor,inclusion);
end

for ff=2:10
    
newset=normdataset(:,1:ff);

k=10;
cvFolds = crossvalind('Kfold', class, k);   %# get indices of 10-fold CV
cp = classperf(class);       
cp2=classperf(class);  %# init performance tracker
cp3 = classperf(class);       
cp4=classperf(class); 
for i = 1:k                                  %# for each fold
    testIdx = (cvFolds == i);                %# get indices of test instances
    trainIdx = ~testIdx;                     %# get indices training instances
    train_patterns=newset(trainIdx,:);
       train_targets=class(trainIdx)';
% start classifiers
t = cputime;
    Class = knnclassify(newset(testIdx,:),train_patterns, train_targets',5) ;% kNN classifier
    knnt=[knnt cputime-t];
           t = cputime;
    SVMStruct = svmtrain(train_patterns, train_targets','Autoscale',true, 'Showplot',false, 'Method','QP', ...
                 'BoxConstraint',2e-1, 'Kernel_Function','rbf', 'RBF_Sigma',1);% SVM classifier
           t = cputime;
    Group = svmclassify(SVMStruct,newset(testIdx,:));
    svmt=[svmt cputime-t];
    
    O1 = NaiveBayes.fit(train_patterns,train_targets,'Distribution','kernel');% NB classifier
           t = cputime;
    C1 = O1.predict(newset(testIdx,:));
    nbt=[nbt cputime-t];

    ctree = fitctree(train_patterns,train_targets');% D-tree classifier
           t = cputime;
    Ynew = predict(ctree,newset(testIdx,:));
    trrt=[trrt cputime-t];
 
 % validation
    cp = classperf(cp, Class, testIdx);
    cp2 = classperf(cp2, Group, testIdx); 
    cp3 = classperf(cp3,  C1, testIdx);
    cp4 = classperf(cp4, Ynew, testIdx); 
 
 
end
knntt=[knntt mean(knnt)];
svmtt=[svmtt mean(svmt)];
nbtt=[nbtt mean(nbt)];
trrtt=[trrtt mean(trrt)];
Test=testIdx;
%RoC plot
plotroc([class(Test)';class(Test)';class(Test)';class(Test)'],[Class';Group';C1';Ynew'])
end

% calculate the performance metrics for each classifier
results=[cleval(cp) cleval(cp2) cleval(cp3) cleval(cp4)]
%plot runing time
subplot(2,2,1);
plot(knntt)
grid
legend('KNN')
xlabel('Number of features')
ylabel('Avarage prediction time [Sec]')
subplot(2,2,2);
plot(svmtt)
legend('SVM')
grid
xlabel('Number of features')
ylabel('Avarage prediction time [Sec]')
subplot(2,2,3);
plot(nbtt)
legend('NB')
grid
xlabel('Number of features')
ylabel('Avarage prediction time [Sec]')
subplot(2,2,4);
plot(trrtt)
legend('D-tree')
grid
xlabel('Number of features')
ylabel('Avarage prediction time [Sec]')
