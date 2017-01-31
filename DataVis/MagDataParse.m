clear all

mags = 8;
pause on;

fileID = fopen('PracticeData/MagDat6.txt','r');
formatSpec = '%f';
sizeA = [3 Inf];

A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);

[xs,num] = size(A);
num = num/mags;

B = reshape(A,3,mags,num);
B = permute(B,[2 1 3]);
C=B;


[Center, Radii] = magCal();

for e=1:8
    
    B(e,1,:)=B(e,1,:)-Center(1);
    B(e,2,:)=B(e,2,:)-Center(2);
    B(e,3,:)=B(e,3,:)-Center(3);
    
    
    B(e,1,:)=B(e,1,:)/Radii(3)*400;
    B(e,2,:)=B(e,2,:)/Radii(2)*400;
    B(e,3,:)=B(e,3,:)/Radii(1)*400;
    
    
end



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

%V = zeros(mags,3,num);

qpoints = 5;
qp = qpoints*qpoints;

Xq = linspace(0, 6.6, qpoints);
Yq = linspace(0, 5.8, qpoints);
Zq = zeros(size(Yq));

[Xq2, Yq2] = meshgrid(linspace(-1, 6.6, qpoints),linspace(-1, 5.8, qpoints));
Zq2 = zeros(size(Xq2));

Vx = zeros(qpoints,qpoints,num);
Vy = Vx;
Vz = Vx;

for c= 1:num

 Vx(:,:,c)= gridfit(Xre, Yre, B(:,1,c), Xq, Yq);
 Vy(:,:,c)= gridfit(Xre, Yre, B(:,2,c), Xq, Yq);
 Vz(:,:,c)= gridfit(Xre, Yre, B(:,3,c), Xq, Yq);
    
end

sfactor = .005;


%% 

figure

subplot(2,2,1)
qi = quiver3(Xq2,Yq2,Zq2,Vx(:,:,1)*sfactor,Vy(:,:,1)*sfactor,Vz(:,:,1)*sfactor,'AutoScale',...
    'off','LineWidth',2,'Clipping','off');
axis([-1 6.6 -1 5.8 -2 2])
view(-45,45)
%colorbar


subplot(2,2,2)
qe = quiver3(Xre,Yre,Zre,B(:,1,1)*sfactor,B(:,2,1)*sfactor,B(:,3,1)*sfactor,'AutoScale',...
    'off','LineWidth',2,'Clipping','off','color',[1 0 0]);
axis([-1 6.6 -1 5.8 -2 2])
view(-45,45)
%colorbar

subplot(2,2,3)
qe = quiver3(Xre,Yre,Zre,C(:,1,1)*sfactor,C(:,2,1)*sfactor,C(:,3,1)*sfactor,'AutoScale',...
    'off','LineWidth',2,'Clipping','off','color',[0 1 0]);
axis([-1 6.6 -1 5.8 -2 2])
view(-45,45)



%%%%%%%%%%
ax = gca;
ax.NextPlot = 'replaceChildren';

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

%% 
loops = num;


M(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops

    
    subplot(2,2,1)
    qi = quiver3(Xq2,Yq2,Zq2,Vx(:,:,j)*sfactor,Vy(:,:,j)*sfactor,Vz(:,:,j)*sfactor,'AutoScale',...
        'off','LineWidth',2,'Clipping','off');
    axis([-1 6.6 -1 5.8 -2 2])
    view(-45,45)
    %colorbar

    
   
    subplot(2,2,2)
    qe = quiver3(Xre,Yre,Zre,B(:,1,j)*sfactor,B(:,2,j)*sfactor,B(:,3,j)*sfactor,'AutoScale',...
        'off','LineWidth',2,'Clipping','off','color',[1 0 0]);
    axis([-1 6.6 -1 5.8 -2 2])
    view(-45,45)
    %colorbar
    
    
    
    
    subplot(2,2,3)
    qe = quiver3(Xre,Yre,Zre,C(:,1,j)*sfactor,C(:,2,j)*sfactor,C(:,3,j)*sfactor,'AutoScale',...
    'off','LineWidth',2,'Clipping','off','color',[0 1 0]);
    axis([-1 6.6 -1 5.8 -2 2])
    view(-45,45)


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
    
    pause(.05);
    
    drawnow
    M(j) = getframe;
end

%{
myVideo = VideoWriter('IntMag1.avi');
open(myVideo);
writeVideo(myVideo, M);
close(myVideo);
%}

