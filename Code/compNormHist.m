function normHist = compNormHist(I,s)
t=16;
normHist=zeros(t^size(I,3),size(s,2));
I=uint16(I);
n=1;
cropI=(imcrop(I,[s(1,n)-s(3,n),s(2,n)-s(4,n),2*s(3,n),2*s(4,n)]));

K=zeros(size(cropI,1)*size(cropI,2),size(s,2));
K(1:numel(cropI)/size(cropI,3),n)=reshape((cropI(:,:,1)/t)*t^2+(cropI(:,:,2)/t)*t+(cropI(:,:,3)/t),size(cropI,1)*size(cropI,2),1);;
for n=2:size(s,2)
    cropI=(imcrop(I,[s(1,n)-s(3,n),s(2,n)-s(4,n),2*s(3,n),2*s(4,n)]));
    K(1:numel(cropI)/size(cropI,3),n)=reshape((cropI(:,:,1)/t)*t^2+(cropI(:,:,2)/t)*t+(cropI(:,:,3)/t),size(cropI,1)*size(cropI,2),1);;
end
normHist=histc(K,0:(t^3-1));
normHist=normHist./repmat(sum(normHist),t^3,1);
end

% 
% function normHist = compNormHist(I,s)
% t=16;
% I=uint16(I);
% W=2*s(3,1);
% H=2*s(4,1);
% N=size(s,2);
% 
% K=zeros((1+W)*(1+H),N);
% for n=1:size(s,2)
%     cropI=(imcrop(I,[s(1,1)-W/2,s(2,1)-H/2,W,H]));
% 
%     numelCropI=size(cropI,1)*size(cropI,2);
%     if (numelCropI==0)%(1+W)*(1+H))
%         k=(cropI(:,:,1)/t)*t^2+(cropI(:,:,2)/t)*t+(cropI(:,:,3)/t);
% 
%         histi=histc(k(:),0:4095);
% 
%        cropI=zeros(0,0,3);
%     end
%     K(1:numelCropI,n)=reshape((cropI(:,:,1)/t)*t^2+(cropI(:,:,2)/t)*t+(cropI(:,:,3)/t),numelCropI,1);
% end
% normHist=histc(K,0:(t^3-1));
% normHist=normHist./repmat(sum(normHist),t^3,1);
% end