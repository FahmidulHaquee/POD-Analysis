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
% H = abs(-sum(Efrac.*log(Efrac))/log(rk)); rk?