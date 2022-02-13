function [mdl] = Train()
%Genera (y devuelve) un modelo entrenado con los datos conocidos, que luego
%se usará para predecir con los datos desconocidos
s1=202;
s2=209;
s3=211;
ap(1:s1,3)=1; %circulares
ap(s1+1:s1+s2,3)=2; %elongadas
ap(s1+s2+1:s1+s2+s3,3)=3;%otras

%% Calculo circulares
for p=1:s1
folder='C:\Users\server\Desktop\PDI\ProyectoFinal\erythrocytesIDB1\individual cells\circular\'
filePattern = fullfile(folder, '*.jpg');
file=dir(filePattern);
filename=fullfile(file(p).folder,file(p).name);
im=imread(filename);
im_pre=Preproc(imcomplement(rgb2gray(im)));
SE=strel('disk',20);
im_limpia=imclose(im_pre,SE);
[AP im_AP]=AreaPerimetro(im_limpia);
ap(p,1:2)=AP(1:2);
end

%% Calculo elongadas
for p=1:s2
folder='C:\Users\server\Desktop\PDI\ProyectoFinal\erythrocytesIDB1\individual cells\elongated\'
filePattern = fullfile(folder, '*.jpg');
file=dir(filePattern);
filename=fullfile(file(p).folder,file(p).name);
im=imread(filename);
im_pre=Preproc(imcomplement(rgb2gray(im)));
SE=strel('disk',10);
im_limpia=imclose(im_pre,SE);
[AP im_AP]=AreaPerimetro(im_limpia);
ap(s1+p,1:2)=AP(1:2);
 end

%% Calculo otras
for p=1:s3
folder='C:\Users\server\Desktop\PDI\ProyectoFinal\erythrocytesIDB1\individual cells\other\'
filePattern = fullfile(folder, '*.jpg');
file=dir(filePattern);
filename=fullfile(file(p).folder,file(p).name);
im=imread(filename);
im_pre=Preproc(imcomplement(rgb2gray(im)));
SE=strel('disk',10);
im_limpia=imclose(im_pre,SE);
[AP im_AP]=AreaPerimetro(im_limpia);
ap(s1+s2+p,1:2)=AP(1:2);
end

%% Chequeo normalidad para poder usar LDA
%Esto se puede mostrar en el .ppt
histogram(FR(1:s1))
histogram(FR(s1+1:s1+s2))
histogram(FR(s1+s2+1:s1+s2+s3))

%Hago un test Shapiro-Wilk
[H,pvalue,W]=swtest(FR(1:s1),0.05)
[H,pvalue,W]=swtest(FR(s1+1:s1+s2))
[H,pvalue,W]=swtest(FR(s1+s2+1:s1+s2+s3))
%Según este test, la clase 1 y 3 no tienen distribución normal; habría que
%usar otro clasificador
%probar fitncb

%% Armo la tabla 
% ap(any(isnan(ap), 2), :) = [];
FR=4*pi*ap(:,1)./ap(:,2).^2;
Clase=ap(:,3);
mdl=fitcdiscr(FR,Clase);
