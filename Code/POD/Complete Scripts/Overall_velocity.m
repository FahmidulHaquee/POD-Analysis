% Performing POD on overall velocity

% 1. Pre-Process Raw Data
% 2. Create Snapshot Matrix
% 3. Extract and Remove NaN rows
% 4. Subtract Temporal Mean
% 5. Apply POD Algorithm 
% 6. Plot Sigma Values
% 7. Extract Significant Modes
% 8. Insert NaN rows back into POD Modes 
% 9. Plot 2D contour plots for POD modes

% Pre requisites 
clear; clc; close all;

% Ensure all files are added to the path.

% 1. Pre-Process Raw Data
% Simply load data - already processed RAW PIV
load('PIV_100RPM CT1_3 h20 no baffles');

% Delete unused variables
clearvars -except CellTableArray_100 meanTable_100

% 2. Create Snapshot Matrix
% Initialise X snapshot matrix
X = [];

% Extract x,y velocity from CellTableArray containing all our data 
for i = 1:height(CellTableArray_100)
    T = CellTableArray_100{i,1};
    
    % extract x velocity
    x_vel = T(:,{'inst vel x'});
    x_vel = table2array(x_vel);
  
    % extract y velocity
    y_vel = T(:,{'inst vel y'});
    y_vel = table2array(y_vel);
        
    % calculate overall velociy
    vel = (x_vel.^2 + y_vel.^2).^(1/2);
        
    % take the column and enter into matrix
    X = horzcat(X,vel);
     
end
% 3. Extract and Remove NaN rows
% Copy mean table, instead of overwrite
T = meanTable_100;

% Add index column
T.Index = (1:height(T)).';

% Re order columns
T = T(:, [end, 1:end-1]);

% Extract rows where CHC == -2 i.e. values are NaN
Delete_NaNs = T.CHC == -2; 

% Extract NaN rows
NaNs_rows =  T(Delete_NaNs,:);

% Removes columns where CHC = -2
X(:,Delete_NaNs) = [];

% Removes rows where CHC = -2
T(Delete_NaNs,:) = []; 

% 4. Subtract Temporal Mean
for i = 1:height(T)
    temp_mean_x = T(i,{'avg vel x'}); % Temproal Average x velocity for 
    temp_mean_x = table2array(temp_mean_x);
    temp_mean_y = T(i,{'avg vel y'});
    temp_mean_y = table2array(temp_mean_y);
    temp_mean = (temp_mean_x.^2 + temp_mean_y.^2).^(1/2);
    X(:,i) = X(:,i) - temp_mean;
end

% 5. Apply POD Algorithm 

% Create covariance matrix
% C = (X'*X)/(Nt-1);
[C]=nancov(X',X);

% Solve eigenvalue problem 
% PHI = eigenvectors, LAMBDA = eigenvalues
[PHI, LAMBDA] = eig(C,'vector');

% Sort eigenvalues and eigenvectors
[LAMBDA,ilam] = sort(LAMBDA,'descend');

% Spatial modes
PHI = PHI(:, ilam);

% Time coefficients
A = X*PHI; 

% The time coefficients describes 
% how much of a mode appears in each
% snapshot. For reasons unknown,
% A was a matrix full of NaN values.

% 6. Plot Sigma Values

% Compute the fraction of total energy, 
E_frac  = (LAMBDA/sum(LAMBDA))*100;

% Take first 10 modes
ilam = sort(ilam);

% Mode # on x
% Sigma value on Y1
x = ilam;
y = E_frac;
figure
plot(x(1:10),y(1:10));
xlabel('Mode #') 
ylabel('%TKE') 
title('150 RPM - CT3 - Mode # against %TKE')

% 7. Extract Significant Modes
% From previous figure
% Determine how many pertitent modes

POD_modes = PHI(1:3,:); % first 3 modes
POD_modes = POD_modes'; % transpose

i_x_y = T(:,1:3); % all index, x and y locations
i_x_y = table2array(i_x_y); % array

% join arrays
POD_modes = horzcat(i_x_y,POD_modes);
POD_modes = array2table(POD_modes,...
    'VariableNames',{'Index','x_loc','y_loc','Mode1','Mode2','Mode3'});

% 8. Insert NaN rows back into POD Modes 

NaNs_rows = table2array(NaNs_rows);
POD_modes = table2array(POD_modes);
POD_modes = vertcat(POD_modes,NaNs_rows);
POD_modes = array2table(POD_modes,...
    'VariableNames',{'Index','x_loc','y_loc','Mode1','Mode2','Mode3'});

% Sort based on index
POD_modes = sortrows(POD_modes,'Index','ascend');

% 9. Plot 2D contour plots for POD modes

x = table2array(POD_modes(:,2)); % x co-ordinates
y = table2array(POD_modes(:,3)); % y co-ordinates

n = 4; % corresponding to t =1. For mode 2 and mode 3, 
% use n = 5 and 6 respectively
z = table2array(POD_modes(:,n)); % Mode n

[xq,yq] = meshgrid(0:0.01:1,0:0.01:1);
vq = griddata(x,y,z,xq,yq,'cubic');
figure
contourf(xq,yq,vq,30,'edgecolor','none')
colormap(jet)
colorbar
xlabel('Normalised X') 
ylabel('Normalised Y') 
title('Mode n at t = 1, at 150 RPM - CT3 - With NaNs')

% The two figure windows will be overlapped

% Free up memory
clearvars -except CellTableArray_100 meanTable_100 A C PHI X POD_modes LAMBDA NaNs_rows E_frac
