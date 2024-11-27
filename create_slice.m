function [image] = create_slice(domain,BV,WM,occupancy,slice_ind)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

i = slice_ind;

dx = 1; %slice thickness
%%Create image
wm_slice = squeeze(sum(WM(:,i-dx:i+dx,:),2));
bv_slice = squeeze(sum(BV(:,i-dx:i+dx,:),2));
brain_slice = squeeze(sum(domain(:,i-dx:i+dx,:),2));
cancer_slice = squeeze(sum(occupancy(:,i-dx:i+dx,:),2));

image = ones([size(wm_slice),3]);

%Add brain contour
idx = find(brain_slice > 2);
[r,c] = ind2sub(size(brain_slice),idx);
for i = 1:length(r)
    image(r(i),c(i),:) = 0.7;
end


% %Add wm as gray
[r,c] = ind2sub(size(wm_slice),find(wm_slice > 0));
for i = 1:length(r)
   image(r(i),c(i),:) = 0.95; 
end





%Add bv as red
[r,c] = ind2sub(size(bv_slice),find(bv_slice > 0));
for i = 1:length(r)
   image(r(i),c(i),1) = 0.8; 
   image(r(i),c(i),2) = 0;
   image(r(i),c(i),3) = 0;
end


%Add cancer cells
[r,c] = ind2sub(size(cancer_slice),find(cancer_slice > 0));
for i = 1:length(r)
   image(r(i),c(i),1) = 0;
   image(r(i),c(i),2) = 0.7;
   image(r(i),c(i),3) = 0;
end

image = imrotate(image,90);
end

