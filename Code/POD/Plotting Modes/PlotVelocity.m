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
contourf(POD_modes.x_loc,POD_modes.y_loc,POD_modes.Mode1)
colormap(jet) 
colorbar

