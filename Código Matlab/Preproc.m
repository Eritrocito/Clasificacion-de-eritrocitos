function [im_fil]=Preproc(im)
%Recibe la imagen en escala de grises, luego de haber eliminado los
%leucocitos con EliminarWBC


% Umbralización
U=graythresh(im);
im_bin=imbinarize(im,U);
% im_bin=imcomplement(im_bin);


% Filtrado morfológico
SE=strel('disk',4);
im_fil=imopen(im_bin,SE);


% Elimino células ruido
[label n]=bwlabel(im_fil,4);
for i=1:n
ind=find(label==i);
    if(size(ind,1)<200) %defino un umbral empírico
        im_fil(ind)=0;
    end
end

% rectangulos
im_fil=imclearborder(im_fil); %Elimino las células sobre el borde, ya que probablemente esten cortadas y no son representativas
end