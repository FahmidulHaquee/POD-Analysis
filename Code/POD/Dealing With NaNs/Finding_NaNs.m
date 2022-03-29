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

% Removes rows where CHC = -2
T(Delete_NaNs,:) = []; 

% Return NaN rows back to Snapshot Matrix, X
X = 