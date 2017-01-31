mags = 8;

fileID = fopen('PracticeData/MagDat4.txt','r');
formatSpec = '%f';
sizeA = [3 Inf];

A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);

[other,num] = size(A);
num = num/mags;

B = reshape(A,3,mags,num);
B = permute(B,[2 1 3]);

% 5.6" x 4.8" board
Loc = [0,0;
    5.6, 0;
    2.8, 1.6;
    0, 2.4;
    5.6, 2.4
    2.8, 3.2;
    0, 4.8;
    5.6,4.8];

Xre = Loc(:,1);
Yre = Loc(:,2);

Zre = zeros(size(Xre));


V = zeros(mags,3,num);


sfactor = .005;


%% 


figure
q = quiver3(Xre,Yre,Zre,B(:,1,1)*sfactor,B(:,2,1)*sfactor,B(:,3,1)*sfactor,'AutoScale',...
    'off','LineWidth',2,'Clipping','off');
axis([-1 6.6 -1 5.8 -2 2])
view(-45,60)
colorbar



%%%%%%%%%%
ax = gca;
ax.NextPlot = 'replaceChildren';


%Coloring code from:
%http://stackoverflow.com/questions/29632430/quiver3-arrow-color-corresponding-to-magnitude

%// Compute the magnitude of the vectors
mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
            reshape(q.WData, numel(q.UData), [])).^2, 2));

%// Get the current colormap
currentColormap = colormap(gca);

%// Now determine the color to make each arrow using a colormap
[~, ~, ind] = histcounts(mags, size(currentColormap, 1));

%// Now map this to a colormap to get RGB
cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
cmap(:,:,4) = 255;
cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);

%// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
set(q.Head, ...
    'ColorBinding', 'interpolated', ...
    'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'

%// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
set(q.Tail, ...
    'ColorBinding', 'interpolated', ...
    'ColorData', reshape(cmap(1:2,:,:), [], 4).');

%% 
loops = num;

Mr(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops

q = quiver3(Xre,Yre,Zre,B(:,1,j)*sfactor,B(:,2,j)*sfactor,B(:,3,j)*sfactor,'AutoScale',...
    'off','LineWidth',2,'Clipping','off');
axis([-1 6.6 -1 5.8 -2 2])
view(-45,60)

%{
%Coloring code from:
%http://stackoverflow.com/questions/29632430/quiver3-arrow-color-corresponding-to-magnitude

%// Compute the magnitude of the vectors
mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
            reshape(q.WData, numel(q.UData), [])).^2, 2));

%// Get the current colormap
currentColormap = colormap(gca);

%// Now determine the color to make each arrow using a colormap
[~, ~, ind] = histcounts(mags, size(currentColormap, 1));

%// Now map this to a colormap to get RGB
cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
cmap(:,:,4) = 255;
cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);

%// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
set(q.Head, ...
    'ColorBinding', 'interpolated', ...
    'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'

%// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
set(q.Tail, ...
    'ColorBinding', 'interpolated', ...
    'ColorData', reshape(cmap(1:2,:,:), [], 4).');
    
    
    
    %}
    
    
    drawnow
    Mr(j) = getframe;
end

%{
myVideo = VideoWriter('reMag1.avi');
open(myVideo);
writeVideo(myVideo, Mr);
close(myVideo);
%}
