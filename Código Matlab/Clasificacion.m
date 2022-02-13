function [accuracy, mdl]=Modelo(feat)
%recibe los descriptores geometricos y devuelve un vector con el accuracy
%del K-fold y el accuracy del test, para ver si el modelo tiene o no
%overfitting.
%Devuelve también el modelo usando todos los descriptores que recibe
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
train_t=table(train(:,2),train(:,3),'VariableNames',{'FR' 'Clase'});
test_t=table(test(:,2),test(:,3),'VariableNames',{'FR' 'Clase'})

%Calculo el accuracy de K-fold
mdl=fitcdiscr(train_t,'Clase');
cv_mdl=crossval(mdl,'KFold',K);
cv_accuracy=1-kfoldLoss(cv_mdl); 

%Evalúo el modelo en el set de test y calculo el accuracy
test_accuracy=1-loss(mdl,test_t,'Clase');

accuracy=[cv_accuracy test_accuracy]
%Comparando cv_accuracy con test_accuracy, vemos que el train clasifica un 2% mejor; es decir,
%no hay demasiado overfitting, es razonable

end