function [C]=nancov(A,B)

% Program to compute a covariance matrix ignoring NaNs
%
% C = nancov(A,B)
%
% Nancov determines A*B whilst ignoring NaNs 
% NaNs are replaced by 0
% Each element, C(i,j), normalized by the number of 
% non-NaN values in the vector product A(i,:)*B(:,j).
%
% A - LHS matrix 
% B - RHS matrix 
% C - Covariance matrix

N_matA=~isnan(A); % Counter matrix
N_matB=~isnan(B);

A(isnan(A))=0; % Replace NaNs in A,B, and counter matrices
B(isnan(B))=0; % with zeros

Npts=N_matA*N_matB;
C=(A*B)./Npts;

end 