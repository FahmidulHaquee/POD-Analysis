T = meanTable_300;
Delete_NaNs = T.CHC == -2; 
T(Delete_NaNs,:) = []; % Removes rows where CHC = -2

% contour plot of mean field with NaN
x = table2array(T(:,1)); % x co-ordinates
y = table2array(T(:,2)); % y co-ordinates
x_vel = table2array(T(:,3)); 
y_vel = table2array(T(:,4)); 
z = (x_vel.^2 + y_vel.^2).^(1/2);

[xq,yq] = meshgrid(0:0.01:1,0:0.01:1);
vq = griddata(x,y,z,xq,yq,'cubic');
contourf(xq,yq,vq,30,'edgecolor','none')
colormap(jet)
colorbar
xlabel('Normalised X') 
ylabel('Normalised Y') 
title('Mean Flow Field at 300 RPM with Interp')