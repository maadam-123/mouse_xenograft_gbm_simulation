% Demo simulation
clear all; close all; clc;

%%Randomly generated parameters
% tsteps = 1800; %4 per day, 7 days for 40 weeks = 1120
tsteps = 300;


Pm = rand();                %Between 0 and 1
Pp = rand()*0.015;          %Between 0 and 0.015
bv_str = 1-sqrt(rand());    %Between 0 and 1
wm_str = (1-bv_str)*rand(); %Between 0 and 1-bv_str

params = [Pm, Pp, tsteps, bv_str, wm_str];

occupancy = SimulationFunction(params);

save(strcat('simulations/simdata/run_demo'),'occupancy');   %Save occupancy data for later use
T = table(Pm, Pp, tsteps, bv_str, wm_str, ...
          'VariableNames', {'Pm', 'Pp', 'tsteps', 'bv_str', 'wm_str'});
writetable(T,strcat('simulations/parameters/run_demo'));    %Save this run's parameters in a text file
%% Visualization
close all; clc;
load('combined_brain.mat'); %Loads the brain domain (used here for visualization)

slice_position = [100 120 140 160];
im = create_slice(domain,BV,WM,occupancy,slice_position(3));    %Shows a brain with white matter tracts (light grey) and blood vasculature (red).
imshow(flip(im,2))



