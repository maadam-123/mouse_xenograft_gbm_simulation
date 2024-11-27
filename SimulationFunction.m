function [occupancy] = SimulationFunction(params)
%SimulationFunction Performs a stochastic simulation of cell
%migration/proliferation in a brain with both white matter tracts and blood
%vessels.
%   @params:    params(1) = Pm (migration)
%               params(2) = Pp_base (proliferation)
%               params(3) = time steps
%               params(4) = bv_str (blood vessel preference parameter)
%               params(5) = wm_str (white matter preference parameter)

%% ====Start simulation==== %%
disp('Sim started')
load('combined_brain.mat'); %Contains WM and BV data

%%==Parameters==%%
Pm_base = params(1);
Pp_base = params(2);
K = 3;
tsteps = params(3);
bv_str = params(4);
wm_str = params(5);
dirs = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1]; %Possible migration directions


% prolif_sphere = zeros(size(domain));
% rad = 10;
% center = [100 100 100];
% for i = center(1)-rad:center(1)+rad
%     for j = center(2)-rad:center(2)+rad
%         for k = center(3)-rad:center(3)+rad
%             if sqrt( (center(1)-i)^2 + (center(2)-j)^2 + (center(3)-k)^2 ) < rad
%                 prolif_sphere(i,j,k) = 1;
%             end
%         end
%     end
% end


%%==Create initial conditions (SPHERE)==%%
[Lx,Ly,Lz] = size(domain);
initpos = [94, 133, 115];

occupancy = zeros(Lx,Ly,Lz); %Array to keep track of number of cells in each voxel. Does not keep track of which cell it is
P = [];
radius = 8;

for i = initpos(1)-radius:1:initpos(1)+radius
    for j = initpos(2)-radius:1:initpos(2)+radius
        for k = initpos(3)-radius:1:initpos(3)+radius
            
            stop = 1;
            if sqrt( (i-initpos(1))^2 + (j-initpos(2))^2 + (k - initpos(3))^2) <= radius
                local = [i j k].*ones(K,3);
                P = [P; local]; %Coordinate of all cells in a list (x,y,z)
                occupancy(i,j,k) = K;
                stop = 1;
            end
        end
    end
end
data_temp = P;

% %%==Create initial conditions (SQUARE) ==%%
% [Lx,Ly,Lz] = size(domain);
% initpos = [94, 133, 101];
% % initpos = [120, 133, 101];
% occupancy = zeros(Lx,Ly,Lz); %Array to keep track of number of cells in each voxel. Does not keep track of which cell it is
% P = [];
% offset = 5;
%
% for i = initpos(1)-offset:1:initpos(1)+offset
%     for j = initpos(2)-offset:1:initpos(2)+offset;
%         for k = initpos(3)-offset:1:initpos(3)+offset
%             local = [i j k].*ones(K,3);
%             P = [P; local]; %Coordinate of all cells in a list (x,y,z)
%             occupancy(i,j,k) = K;
%         end
%     end
% end
%
% data_temp = P;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Start time loop
for t = 2:tsteps
    %     t
    P = data_temp; %Contains a list of (x,y,z) of all N cells
    
    [N,~] = size(P);    %Current number of agents
    birthindex = [];    %Keeps track of all cells to produce offspring
    birthpos = [];
    
    for i = 1:N         %For |agents|
        
        
        %%==Choose agent at random and read its position==%%
        j = randi([1 N]);
        pos = P(j,:); %Read (x,y,z) of cell j
        
        %%==Compute number of cells in current voxel==%%
        nloc = occupancy(pos(1),pos(2),pos(3));
        
        
        %%==Proliferation event==%%
        if nloc < K %Strictly less than K (cannot proliferate if voxel  is full)
            
            %If there the cell is close to a blood vessel
            %             sphere = circshift(prolif_sphere,[pos(1)-100,pos(2)-100,pos(3)-100]);
            %             box = zeros(size(BV));
            %             box(sphere > 0) = 1; %Proliferation is increased in this region
            
            %             d = 3;
            %             box = BV(pos(1)-d:pos(1)+d, pos(2)-d:pos(2)+d, pos(3)-d:pos(3)+d);
            %             Pp = Pp_base*(1 + sum(box(:))/(numel(box)));
            Pp = Pp_base;
            
            
            
            if rand() < Pp %Proliferate randomly with prob Pp
                birthindex = [birthindex; j];   %This is the index from P (index of cell proliferated).
                birthpos = [birthpos; pos];     %These will be added after the current time-step
                occupancy(pos(1),pos(2),pos(3)) = occupancy(pos(1),pos(2),pos(3)) + 1;
            end
        end
        
        
        Pm = Pm_base;
        %%==Perform Mobility event==%%
        if rand() < Pm %Move with probability Pm

            bv_probs = squeeze(bv_field(pos(1),pos(2),pos(3),:));
            wm_probs = squeeze(wm_field(pos(1),pos(2),pos(3),:));
            
            probs = (ones(6,1)/6)*(1-bv_str-wm_str) + bv_str*bv_probs + wm_str*wm_probs;
            stop = 1;
            probs = probs./sum(probs);  %Rescale so it sums to 1
            
            %%Pick a direction at random
            r = rand();
            inds = find(cumsum(probs) > r);
            stop = 1;
            dir = dirs(inds(1),:);
            
            newpos = P(j,:) + dir;  %New cell position
            %Check if the cell can move
            if domain(newpos(1),newpos(2),newpos(3)) > 0 %Check so it moves within brain domain
                if occupancy(newpos(1),newpos(2),newpos(3)) < K %Check that target voxel is not full
                    P(j,:) = newpos;
                    occupancy(pos(1),pos(2),pos(3)) = occupancy(pos(1),pos(2),pos(3)) - 1; %Remove it from old position
                    occupancy(newpos(1),newpos(2),newpos(3)) = occupancy(newpos(1),newpos(2),newpos(3)) + 1; %Add it into new position
                end
            end
            
        end %End motility event
    end %End "For i = 1:N (number of agents)
    P = [P; birthpos]; %Extend P to include new born cells
    data_temp = P;
    
end

end

