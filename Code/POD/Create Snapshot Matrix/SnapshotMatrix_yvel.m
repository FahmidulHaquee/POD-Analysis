% Constructing the snapshot matrix, X
% X is 500 (rows) x 958 matrix (columns)
% For POD and DMD analysis

% Pre requisites 
clear; clc; close all;
% load data
load('PIV_100RPM_CT3_Tr');

% Initialise X snapshot matrix
X = [];

% Extract y velocity from CellTableArray containing all our data 
for i = 1:1058
    T = CellTableArray_100{i,1}; 
    T = T(:,{'inst vel y'});
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

% Subtract temporal mean from each value
% meanTable_500 contains temporal means at each location 
% first remove NaNs from meanTable_500

T = meanTable_100;
Delete_NaNs = T.CHC == -2; 
T(Delete_NaNs,:) = []; % Removes rows where CHC = -2

for i = 1:958
    temp_mean = T(i,{'avg vel y'});
    temp_mean = table2array(temp_mean);
    X(:,i) = X(:,i) - temp_mean;
end