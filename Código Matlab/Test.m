function matriz=Test(mdl,matriz)
%Recibe un modelo discriminante lineal y una matriz AP a
%clasificar; devuelve la misma matriz con las etiquetas
matriz(:,3)=4*pi*matriz(:,1)./matriz(:,2).^2;
matriz(:,4)=predict(mdl,matriz(:,3));
end