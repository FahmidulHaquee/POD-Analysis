% Performing POD on x velocity
% X is 500 (rows) x 958 matrix (columns)
% For POD and DMD analysis

% Pre requisites 
clear; clc; close all;
% load data
load('PIV_100RPM_CT3_Tr');

% Initialise X snapshot matrix
X = [];

% Extract x velocity from CellTableArray containing all our data 
for i = 1:1058
    T = CellTableArray_100{i,1}; 
    T = T(:,{'inst vel x'});
    T = table2array(T);
    x = T(1);
    TF = isnan(x);
    if TF == 1
        continue 
    else 
        % take the column and enter into matrix
        X = horzcat(X,T);
    end 
end 
% Subtract temporal mean from each instantaneous velocity value
% meanTable_500 contains temporal means at each location 
% first remove NaNs from meanTable_500

T = meanTable_100;
Delete_NaNs = T.CHC == -2; 
T(Delete_NaNs,:) = []; % Removes rows where CHC = -2

for i = 1:958
    temp_mean = T(i,{'avg vel x'});
    temp_mean = table2array(temp_mean);
    X(:,i) = X(:,i) - temp_mean;
end
% Direct POD - Code taken from Weiss 2019
Nt = 500;

% Create covariance matrix
C = (X'*X)/(Nt-1);

% Solve eigenvalue problem, PHI is eigenvectors, LAMDA is eigenvalues
[PHI, LAMBDA] = eig(C,'vector');

% Sort eigenvalues and eigenvectors
[LAMBDA,ilam] = sort(LAMBDA,'descend');

% These are the spatial modes
PHI = PHI(:, ilam);

% Calculate time coefficients
A = X*PHI;

% % Reconstruction on mode k
% k = 1; % for example
% Utilde_k = A(:,k)*PHI(:,k)';

% % Compute the fraction of total energy, the cumulative energy, and the
% % cumulative fraction of total energy for all time instants.
E_frac  = LAMBDA/sum(LAMBDA);
E_csum  = cumsum(LAMBDA);
E_cfrac = E_csum/sum(LAMBDA);

% % Compute the entropy (a measure of energy spread) between the modes.
% H = abs(-sum(Efrac.*log(Efrac))/log(rk));

% Plot 2D contour plots for POD modes

POD_modes = X(1:3,:); % first 3 modes
POD_modes = POD_modes'; % transpose

x_and_y = T(:,1:2); % all x and y locations
x_and_y = table2array(x_and_y); % array

% join arrays
POD_modes = horzcat(x_and_y,POD_modes);
POD_modes = array2table(POD_modes,...
    'VariableNames',{'x_loc','y_loc','Mode1','Mode2','Mode3'});

% contour plot
x = table2array(POD_modes(:,1)); % x co-ordinates
y = table2array(POD_modes(:,2)); % y co-ordinates
z = table2array(POD_modes(:,3)); % Mode 1

[xq,yq] = meshgrid(0:0.01:1,0:0.01:1);
vq = griddata(x,y,z,xq,yq,'cubic');
contourf(xq,yq,vq,20,'edgecolor','none')
colormap(jet)
colorbar
