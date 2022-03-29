% Constructing the snapshot matrix, X
% X is 500 (rows) x 958 matrix (columns)
% For POD and DMD analysis

% Pre requisites 
clear; clc; close all;

% load data
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