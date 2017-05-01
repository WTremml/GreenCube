function [ center, radii ] = defaultPC( )
% Loads center and radii data for 24 mag setup, returns two 24x3 matrices
%   4/26/2017

sizeA = [3 Inf];

% read default radii file
fileIDR = fopen('PracticeData/default_radii.txt','r');
formatSpec = '%f';
radii = fscanf(fileIDR,formatSpec,sizeA).';
fclose(fileIDR);

% read default centers file
fileIDC = fopen('PracticeData/default_center.txt','r');
formatSpec = '%f';
center = fscanf(fileIDC,formatSpec,sizeA).';
fclose(fileIDC);

end

