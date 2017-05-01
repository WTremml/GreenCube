function [center, radii] = pointCloudFunc(B, magnum)
%Function version of PointCloudMag to be used with VectorMag3D
%   Handles magnetometer data and computes output statistics, plots them
%   4/28/2017

% B is a 3D array of magnetic field magnitudes
% the columns are x, y, and z
% the rows are each mag (1 through magnum)
% each level of the array is a data set (1 sample)

% Array of colors
arr = ['r','g','b','k','y','m','c','w'];

samples = size(B,3);

center = zeros(magnum,3);
radii = zeros(magnum,3);

figure(1)

% plot raw data
subplot(1,2,1)

for c=1:magnum
    
    x1=B(c,1,:);
    y1=B(c,2,:);
    z1=B(c,3,:);

    % use ellipsoid fit on data from all samples
    Ell = [x1; y1; z1];
    Ell = permute(Ell,[1,3,2]);
    Ell = Ell';

    [ centertemp, radiitemp, evecstemp, vtemp, chi2temp ] = ellipsoid_fit(Ell,'0');

    center(c,:) = centertemp;
    radii(c,:) = radiitemp;
    
    scatter3(x1,y1,z1,'MarkerFaceColor',arr(mod(c, 8) + 1))
    hold on;

end

title('Raw Mag Data');
axis equal
hold off


% plot corrected data
subplot(1,2,2)

for i=1:samples
    
    [xCorr, yCorr, zCorr] = applyScale(B(:,1,i), B(:,2,i), B(:,3,i), center, radii, 400);

    scatter3(xCorr,yCorr,zCorr,'MarkerFaceColor',arr(mod(i, 8) + 1))
    hold on;
end

title('Mag Data with Gains and Offsets')
axis equal
hold off

end
