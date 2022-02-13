%% Armo el clasificador en base a las ya clasificadas
feat=Feat_conoc;
%Calculo los 2 accuracy del clasificador y el modelo, que luego se usará sobre las imágenes completas
[acc_FR_dis acc_FR_tr acc_FR_nb mdl_FR]=Modelo(feat(:,[1 3])); %Considerando solo FR
[acc_Ec_dis acc_Ec_tr acc_Ec_nb mdl_Ec]=Modelo(feat(:,[2 3])); %Considerando solo Ec (eccentricidad)
[acc_FR_Ec_dis acc_FR_Ec_tr acc_FR_Ec_nb mdl_FR_Ec]=Modelo(feat(:,1:3)); %Considerando ambos, FR y Ec. Este clasifica mejor (tiene mejor accuracy)

[acc_El_dis acc_El_tr acc_El_nb mdl_El]=Modelo([feat(:,2)./feat(:,3) feat(:,3)]); %Considerando solo elipsidad (FR/Ec)
%Con la elipsidad anda peor, tiene peor accuracy que con los demás.
%Acá vienen los demás modelos con otras features

%% trabajo con las no clasificadas
%for p=1:5
%folder='C:\Users\server\Desktop\PDI\ProyectoFinal\PDI\Imagenes\'
%filePattern = fullfile(folder, '*.jpg');
%file=dir(filePattern);
%filename=fullfile(file(p).folder,file(p).name);
%im=imread(filename);

im=imread('C:\Users\server\Desktop\PDI\ProyectoFinal\PDI\Imagenes\001source.jpg');
%  im=imread('C:\Users\server\Desktop\PDI\ProyectoFinal\PDI\Imagenes\c0001.jpg');
im_elim=EliminarWBC(im);
im_pre=Preproc(im_elim);
[AP im_AP]=FeaturesExtraction(im_pre);

%Separo entre las que estan juntas
[im_AP_ind,im_AP_peg]=individuales(AP(:,1:2),im_AP);

%% Clasifico las células individuales (que ya estan separadas)
% clas_indiv=Clasificar(mdl_FR,4*pi*AP(:,1)./AP(:,2).^2); %Con FR solamente
% clas_indiv=Ensamble([feat(:,1) feat(:,3)],4*pi*AP(:,1)./AP(:,2).^2); %Con FR solamente
% clas_indiv=Ensamble([feat(:,1:2) feat(:,3)],[4*pi*AP(:,1)./AP(:,2).^2 AP(:,3)]); %Con Fr+Ec
clas_indiv=Clasificar(mdl_FR_Ec,[4*pi*AP(:,1)./AP(:,2).^2 AP(:,3)]); %Con Fr+Ec
%Comparando a ojo las clasificaciones de ambos, funciona mejor el segundo,
%ya que el primero clasifica algunas como C cuando en realidad son O,
%mientras que esas mismas el segundo las clasifica como O (ver con imagen 5)

%% Borro las clasificaciones correspondientes a las celulas pegadas
clas_indiv(:,2)=clas_indiv;
clas_indiv(:,1)=1:size(clas_indiv,1);
for i=1:size(clas_indiv,1) %Borro los datos de las que están pegadas
    ind=find(im_AP_peg==i);
    if(isempty(ind)==0) %Si está en la imágen con células pegadas
        clas_indiv(i,:)=0; %La elimino de la clasificación de las individuales
    end
end
clas_indiv( ~any(clas_indiv,2), : ) = [];  %elimino filas que estan en 0

%% Calculo features de las células pegadas
%Acá viene wshed y demás
%im_peg=wshed();
%feat_peg=FeaturesExtraction(im_peg);

%% Grafico la imagen ya clasificada
figure()
im_etiq=imresize(im,0.25);
stats=regionprops(im_AP,'BoundingBox');
for k = 1 : length(stats)
    aux=find(clas_indiv(:,1)==k);
    if(isempty(aux)==0) %si la célula k no es de ninguna célula despegada
thisBB = stats(k).BoundingBox;
rec=im_etiq(round(thisBB(2)):round(thisBB(4)+thisBB(2)),round(thisBB(1)):round(thisBB(1)+thisBB(3)),:);
if(clas_indiv(aux,2)==1)
    im_clas=insertText(rec,[1,1],'C','Fontsize',20,'BoxOpacity',0,'TextColor','white');
elseif(clas_indiv(aux,2)==2)
    im_clas=insertText(rec,[1,1],'E','Fontsize',20,'BoxOpacity',0,'TextColor','white');
elseif(clas_indiv(aux,2)==3)
    im_clas=insertText(rec,[1,1],'O','Fontsize',20,'BoxOpacity',0,'TextColor','white');
end
im_etiq(round(thisBB(2)):round(thisBB(4)+thisBB(2)),round(thisBB(1)):round(thisBB(1)+thisBB(3)),:)=im_clas;
end
end
imshow(im_etiq)

for k = 1 : length(stats)
 aux=find(clas_indiv(:,1)==k);
 thisBB = stats(k).BoundingBox;
 if(isempty(aux)==0)
 rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','g','LineWidth',1 )
 else
 rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','r','LineWidth',1 )    
 end
end

%end