function clase_ens=Ensamble(clasif, no_clasif)
%recibe los descriptores geometricos y devuelve un vector con el accuracy
%del K-fold y el accuracy del test, para ver si el modelo tiene o no
%overfitting, calculado con tres modelos: discriminante lineal,arbol binario y Naive-Bayes.
%Devuelve también el modelo (elegir el de mejor acc) usando todos los descriptores que recibe
% 1: redonda
% 2: elongada
% 3: otra
%% Armo los modelos con el train de las celulas ya clasificadas
%separo 90% train y 10% test
rng('default')
ind=size(clasif,1);
k=round(ind*0.1);
ind=randperm(ind);
test=clasif(ind(1:k),:);
train=clasif(ind(k+1:end),:);

%Calculo el accuracy de K-fold
K=5;

% Clasificador KNN
mdl_knn=fitcknn(train(:,1:size(train,2)-1),train(:,size(train,2))); %Regla de Naive-Bayes

cv_mdl_knn=crossval(mdl_knn,'KFold',K);
acc_knn=1-kfoldLoss(cv_mdl_knn); 

test_accuracy_knn=1-loss(mdl_knn,test(:,1:size(test,2)-1),test(:,size(test,2)));

% Discriminante lineal
mdl_dis=fitcdiscr(train(:,1:size(train,2)-1),train(:,size(train,2))); %Discriminante lineal

cv_mdl_dis=crossval(mdl_dis,'KFold',K);
acc_dis=1-kfoldLoss(cv_mdl_dis); 

test_accuracy_dis=1-loss(mdl_dis,test(:,1:size(test,2)-1),test(:,size(test,2)));

%Arbol de decisión binario
mdl_tr=fitctree(train(:,1:size(train,2)-1),train(:,size(train,2))); %Arbol de decisión

cv_mdl_tr=crossval(mdl_tr,'KFold',K);
acc_tr=1-kfoldLoss(cv_mdl_tr); 

test_accuracy_tr=1-loss(mdl_tr,test(:,1:size(test,2)-1),test(:,size(test,2)));

% Clasificador Naive-Bayes
mdl_nb=fitcnb(train(:,1:size(train,2)-1),train(:,size(train,2))); %Regla de Naive-Bayes

cv_mdl_nb=crossval(mdl_nb,'KFold',K);
acc_nb=1-kfoldLoss(cv_mdl_nb);

test_accuracy_nb=1-loss(mdl_nb,test(:,1:size(test,2)-1),test(:,size(test,2)));

%% Clasifico el test con un ensamble de clasificadores
clase_knn=predict(mdl_knn,test(:,1:size(test,2)-1));
clase_dis=predict(mdl_dis,test(:,1:size(test,2)-1));
clase_tr=predict(mdl_tr,test(:,1:size(test,2)-1));
clase_nb=predict(mdl_nb,test(:,1:size(test,2)-1));

clase_ens=[clase_knn clase_dis clase_tr clase_nb];
clase_ens=mode(clase_ens,2);

acc=mean(test(:,size(test,2))==clase_ens);


%% Clasifico las no clasificadas con un ensamble de clasificadores
clase_knn=predict(mdl_knn,no_clasif);
clase_dis=predict(mdl_dis,no_clasif);
clase_tr=predict(mdl_tr,no_clasif);
clase_nb=predict(mdl_nb,no_clasif);

clase_ens=[clase_knn clase_dis clase_tr clase_nb];
clase_ens=mode(clase_ens,2);
end