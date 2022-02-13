function [acc_dis, acc_tr, acc_nb , mdl_tr]=Modelo(feat)
%recibe los descriptores geometricos y devuelve un vector con el accuracy
%del K-fold y el accuracy del test, para ver si el modelo tiene o no
%overfitting, calculado con tres modelos: discriminante lineal,arbol binario y Naive-Bayes.
%Devuelve también el modelo (elegir el de mejor acc) usando todos los descriptores que recibe
% 1: redonda
% 2: elongada
% 3: otra

%separo 90% train y 10% test
rng('default')
ind=size(feat,1);
k=round(ind*0.1);
ind=randperm(ind);
test=feat(ind(1:k),:);
train=feat(ind(k+1:end),:);

%Calculo el accuracy de K-fold
K=5;
%% Discriminante lineal
mdl_dis=fitcdiscr(train(:,1:size(train,2)-1),train(:,size(train,2))); %Discriminante lineal

cv_mdl_dis=crossval(mdl_dis,'KFold',K);
cv_accuracy_dis=1-kfoldLoss(cv_mdl_dis); 

%Evalúo el modelo en el set de test y calculo el accuracy
test_accuracy_dis=1-loss(mdl_dis,test(:,1:size(test,2)-1),test(:,size(test,2)));

acc_dis=[cv_accuracy_dis test_accuracy_dis];

%% Arbol de decisión binario
mdl_tr=fitctree(train(:,1:size(train,2)-1),train(:,size(train,2))); %Arbol de decisión

cv_mdl_tr=crossval(mdl_tr,'KFold',K);
cv_accuracy_tr=1-kfoldLoss(cv_mdl_tr); 

%Evalúo el modelo en el set de test y calculo el accuracy
test_accuracy_tr=1-loss(mdl_tr,test(:,1:size(test,2)-1),test(:,size(test,2)));

acc_tr=[cv_accuracy_tr test_accuracy_tr];
%% Clasificador Naive-Bayes
mdl_nb=fitcnb(train(:,1:size(train,2)-1),train(:,size(train,2))); %Regla de Naive-Bayes

cv_mdl_nb=crossval(mdl_nb,'KFold',K);
cv_accuracy_nb=1-kfoldLoss(cv_mdl_nb); 

%Evalúo el modelo en el set de test y calculo el accuracy
test_accuracy_nb=1-loss(mdl_nb,test(:,1:size(test,2)-1),test(:,size(test,2)));

acc_nb=[cv_accuracy_nb test_accuracy_nb];
end