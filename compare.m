%% Sample script to compare simulation to binary tumor image
clear all; close all; clc;

load('simulations\simdata\run_demo.mat')

slice_ind = 140;
%Extract simulated tumor
tumor_sim = squeeze(occupancy(:,slice_ind:slice_ind,:));
tumor_sim = imrotate(tumor_sim,90); %To match tumor images orientation
tumor_sim = flip(tumor_sim,2);      %To match tumor images orientation
%%==Use single level without filtering==%%
sim = im2bw(tumor_sim,0.05);

load('raw data\binary_files\AZ40_1_binary.mat')



%%Custom similarity metric

%Binary tumor image
cc = bwconncomp(bin); %Obtain region properties of binary tumor image
stats = regionprops(cc,'Area','Perimeter','FilledArea','Solidity','Eccentricity');
Area = [stats.Area];
Perimeter = [stats.Perimeter];
FilledArea = [stats.FilledArea];
Solidity = [stats.Solidity];
Eccentricity = [stats.Eccentricity];
tumor_data = [cc.NumObjects, mean(Area), std(Area), mean(Eccentricity), std(Eccentricity), std(Perimeter), max(Perimeter), max(FilledArea)];

%Simulated tumor
cc = bwconncomp(sim); %Obtain region properties of simulated tumor
stats = regionprops(cc,'Area','Perimeter','FilledArea','Solidity','Eccentricity');
Area = [stats.Area];
Perimeter = [stats.Perimeter];
FilledArea = [stats.FilledArea];
Solidity = [stats.Solidity];
Eccentricity = [stats.Eccentricity];
sim_data = [cc.NumObjects, mean(Area), std(Area), mean(Eccentricity), std(Eccentricity), std(Perimeter), max(Perimeter), max(FilledArea)];


%Calculate MSE of difference of geometric vectors (our custom metric)
diff = (tumor_data-sim_data);
MSE = sqrt(sum(diff.^2));

%Jaccard index
J = jaccard(sim,bin);


%%Visualize the two tumors
load('combined_brain.mat')
slice_ind = 140;        %Which slice index we want to use in the simulated brain to be used for comparison.
domain_slice = squeeze(domain(:,slice_ind,:)); %Domain is stored in 'combined_brain.mat'
domain_slice = imrotate(domain_slice,90);
domain_slice = flip(domain_slice,2);

create_comparison_image(sim,bin,domain_slice)