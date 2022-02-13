function [im_indiv,im_pegadas]=individuales(AP,im_AP)
%Recibe im_AP y la matriz AP devuelta por AreaPerimetro

%Hago un histograma de las áreas
%h=histogram(AP(:,1),'NumBins',2000,'BinLimits',[0 max(AP(:,1))]);
fd=fitdist(AP(:,1),'Normal');
med=fd.mu;
sd=fd.sigma;
Umin=med-1.5*sd;
Umax=med+1.5*sd;

%Busco umbral para el factor de redondez
%(no es necesario por ahora)


im_indiv=im_AP;
im_pegadas=im_AP;
%AP_indiv=AP;
n=max(im_AP(:));

%Hay que discriminar por area
for i=1:n
    ind=find(im_AP==i);
   if(AP(i,1)<Umin||AP(i,1)>Umax)
       im_indiv(ind)=0;
   elseif (AP(i,1)>Umin&&AP(i,1)<Umax)
       im_pegadas(ind)=0;
   end
end

%size(unique(AP(:,1))
end
