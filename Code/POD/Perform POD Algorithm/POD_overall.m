% Performing POD on overall velocity
% X is 500 (rows) x 958 matrix (columns)
% For POD and DMD analysis

% Pre requisites 
clear; clc; close all;
% load data
load('PIV_100RPM CT1_3 h20 no baffles');

% Initialise X snapshot matrix
X = [];

% Extract x,y velocity from CellTableArray containing all our data 
for i = 1:1058
    T = CellTableArray_100{i,1};
    x_vel = T(:,{'inst vel x'});
    x_vel = table2array(x_vel);
    x = x_vel(1);
    TF = isnan(x);
    if TF == 1
        continue 
    else
        % extract y velocity
        y_vel = T(:,{'inst vel y'});
        y_vel = table2array(y_vel);
        % calculate overall velociy
        vel = (x_vel.^2 + y_vel.^2).^(1/2);
        % take the column and enter into matrix
        X = horzcat(X,vel);
    end 
end

% Subtract temporal mean from each value
% meanTable_500 contains temporal means at each location 
% first remove NaNs from meanTable_500

T = meanTable_100;
Delete_NaNs = T.CHC == -2; 
T(Delete_NaNs,:) = []; % Removes rows where CHC = -2

for i = 1:958
    temp_mean_x = T(i,{'avg vel x'});
    temp_mean_x = table2array(temp_mean_x);
    temp_mean_y = T(i,{'avg vel y'});
    temp_mean_y = table2array(temp_mean_y);
    temp_mean = (temp_mean_x.^2 + temp_mean_y.^2).^(1/2);
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