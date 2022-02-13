function clase=Clasificar(mdl,feat)
%Recibe un modelo y una matriz de features a
%clasificar; cada columna corresponde a cada featura
%Devuelve la misma matriz con las etiquetas
% clase=feat;
% clase(:,size(feat,2)+1)=predict(mdl,feat); %Agrego la clasificación en la última columna
clase=predict(mdl,feat);
end