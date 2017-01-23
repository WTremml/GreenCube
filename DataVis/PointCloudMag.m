%PointCloudMag

mags = 8;

fileID = fopen('MagDat3.txt','r');
formatSpec = '%f';
sizeA = [3 Inf];

A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);

[xs,num] = size(A);
num = num/mags;

B = reshape(A,3,mags,num);
B = permute(B,[2 1 3]);

arr = ['r','g','b','k','y','m','c','w'];

% 3 has broken z
% 4 has huge Z offset

for c=1:mags
    
x1=B(c,1,:);
y1=B(c,2,:);
z1=B(c,3,:);


scatter3(x1,y1,z1,'MarkerFaceColor',arr(c))
hold on


end

axis equal
axis([-1000 1000 -1000 1000 -1000 1000])
hold off
