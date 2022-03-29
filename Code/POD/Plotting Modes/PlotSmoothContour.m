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

xg = linspace(min(x), max(x), 958);
yg = linspace(min(y), max(y), 958);

[X,Y]=meshgrid(xg,yg);

Z = griddata(x, y, z, X, Y);
contourf(X,Y,Z)
colormap(jet)
colorbar

% Z = interp2(x,y,z,xg,yg,'cubic'); % number of input coordinate arrays must match the dimensions of the sample values
% 
% [c,h]=contourf(xg,yg,Z);
% f = figure;
% ax = axes('Parent',f);
% h = surf(xg,yg,Z,'Parent',ax);
% set(h, 'edgecolor','none');
% view(ax,[0,90]);
% colormap(Jet);
% colorbar;