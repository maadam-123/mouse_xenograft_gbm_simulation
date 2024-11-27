function [] = create_comparison_image(sim,bin,sim_domain)
% %@create_comparison_image Creates a good looking image that compares a
% %simulation (sim) with a real binary tumor (bin).
% %   Detailed explanation goes here
% sim, bin and sim_domain must have the same size (182 x 250)



brain_contour = bwperim(sim_domain);
[r,c] = size(sim);
img = ones([r,c,3]);
% cmap = [0, 1, 0; 0, 0, 1; 1, 1, 0]; 
cmap = [0.4, 0.15, 0.1 ;0.95, 0.95, 0;0, 0.85, 0]; %First is simulated tumor, Second is Real tumor, third is overlap

for i = 1:r
    for j = 1:c
        
        if sim_domain(i,j) > 0 %If we are inside the brain
           img(i,j,1) = 0.7; img(i,j,2) = 0.7; img(i,j,3) = 0.7; %Grey background 
        end
        
        if sim(i,j) > 0 %If there is simulated tumor
           img(i,j,1) = cmap(1,1); img(i,j,2) = cmap(1,2); img(i,j,3) = cmap(1,3);
        end
        
        if bin(i,j) > 0 %If there is real tumor
            img(i,j,1) = cmap(2,1); img(i,j,2) = cmap(2,2); img(i,j,3) = cmap(2,3);
        end
        
        if sim(i,j) > 0 && bin(i,j) > 0 %If there is overlap
            img(i,j,1) = cmap(3,1); img(i,j,2) = cmap(3,2); img(i,j,3) = cmap(3,3);
        end
        
        if brain_contour(i,j) > 0
           img(i,j,1) = 0; img(i,j,2) = 0; img(i,j,3) = 0; 
        end
        
    end
end


close all;
imshow(img)
Names = ["Simulated tumor", "Real tumor", "Overlap"];
hSp = gca
cLims = [0 3]; %// cLims is a bit different here!
axis image; set(hSp,'XTick',[],'YTick',[]);
caxis(hSp,cLims);
colormap(hSp, cmap);
cb = colorbar;
cb.TickLabels = Names
cb.Ticks = (hSp.CLim(1):hSp.CLim(2))+0.5; %// Set the tick positions

end