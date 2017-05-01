% PointCloudMag
% Creates and plots center and radii data from file of magnetometer data
% 4/26/2017

magnum = 24;

% read file
fileID = fopen('PracticeData/goodLongData.txt','r');
formatSpec = '%f';
sizeA = [3 Inf];

A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);

% format data from file
[xs,num] = size(A);
num = num/magnum;

B = reshape(A,3,magnum,num);
B = permute(B,[2 1 3]);

% process data
[center, radii] = pointCloudFunc(B, magnum);
