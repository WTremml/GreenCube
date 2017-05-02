%==========================================================================
%================ Magnetometer Vector Visualization Code ==================
%==========================================================================
% Outline
% 1. Chooses Arduino port
% 2. Initializes port
% 3. Samples magnetometer data to creat point cloud
% 4. Opens new figure and customizes it with start/stop buttons
% 5. Runs a loop that continually reads Magnetometer values
% 6. Displays vectors using line() command

% edited 4/26/2017

%% Chooses Arduino port

clear all

% find the correct port by using 'instrfindall'
% comPort = input('Input correct port by using ''instrfindall'' ')
comPort = '/dev/tty.usbmodem1411';
magnum = 24;

%% Initializes port

if(~exist('serialFlag','var'))
    [magnetometer.s,serialFlag] = setSerial(comPort);
end

%% Samples magnetometers to make point cloud

cal = input('Do you want to run calibration samples? [Y / N] ', 's');

if (cal == 'Y')
    while (cal == 'Y')
    
    samples = input('Enter an integer number of samples to take ');
    
    disp('waiting to start taking samples, press space bar once you are ready');
    pause;

    B = storeMagData(magnetometer, magnum, samples);
    [center, radii] = pointCloudFunc(B, magnum);
    pause;
    
    cal = input('Do you want to run calibration again? [Y/N] ', 's');
    
    end 
else
    disp('Using preset center and radii data for gains and offsets ');
    [center, radii] = defaultPC();
    
end


%% Opens new figure with start/stop buttons

if(~exist('h','var') || ~ishandle(h)) 
    h = figure(1);
    ax = axes('box','on');
end

if(~exist('button','var'))
    button = uicontrol('Style','pushbutton','String','Stop','pos',...
    [0 0 50 25], 'parent', h, 'Callback','stopF','UserData',1);
end

if(~exist('button2','var'))
    button = uicontrol('Style','pushbutton','String',...
    'Close Serial Port','pos',[250 0 150 25], 'parent', h, 'Callback',...
    'closeSerial','UserData',1);
end

%% Continuously reads magnetometer data

%arbitrary scale
scale = 2;

%debugging line
%disp('Still Good')

%define the x,y,z base coordinates for each mag
xBase = zeros(1,magnum);
yBase = zeros(1,magnum);
zBase = zeros(1,magnum);

%set Z coordinates
for i = 1:8
    zBase(i) = 0;
end
for i = 9:16
    zBase(i) = 4.4;
end
for i = 17:24
    zBase(i) = 8.6;
end

% set X coordinates
[xBase(1), xBase(9),xBase(17)] = deal(0);
[xBase(2),xBase(10),xBase(18)] = deal(11.6);
[xBase(3),xBase(11),xBase(19)] = deal(5.8);
[xBase(4),xBase(12),xBase(20)] = deal(0);
[xBase(5),xBase(13),xBase(21)] = deal(11.6);
[xBase(6),xBase(14),xBase(22)] = deal(5.8);
[xBase(7),xBase(15),xBase(23)] = deal(0);
[xBase(8),xBase(16),xBase(24)] = deal(11.6);

% set Y coordinates
[yBase(1), yBase(9),yBase(17)] = deal(0);
[yBase(2),yBase(10),yBase(18)] = deal(0);
[yBase(3),yBase(11),yBase(19)] = deal(2.8);
[yBase(4),yBase(12),yBase(20)] = deal(4.8);
[yBase(5),yBase(13),yBase(21)] = deal(4.8);
[yBase(6),yBase(14),yBase(22)] = deal(7.2);
[yBase(7),yBase(15),yBase(23)] = deal(9.6);
[yBase(8),yBase(16),yBase(24)] = deal(9.6);


x=-4:4:16;
y=-4:3.6:14;
z=-4:3.6:14;
[x,y,z]=meshgrid(x,y,z);

subplot(2,1,1)
axis([-4 16 -4 14 -4 14]);
title('Scaled Vectors');
% title('Raw Vectors');
xlabel('X-Axis magnitude');
ylabel('Y-Axis magnitude');
zlabel('Z-Axis magnitude');
grid on
colorbar

subplot(2,1,2)
title('Divergence');
xlabel('X-Axis');
ylabel('Y-Axis');
zlabel('Z-Axis');
grid on
colorbar


while get(button, 'UserData')
    % raw mag data points
    [gx, gy, gz] = readMag(magnetometer, magnum);
    gx = gx.';
    gy = gy.';
    gz = gz.';
    
    % scaled mag data (all variables with S)
    [sx, sy, sz] = applyScale(gx, gy, gz, center, radii, scale);
    

    %interpolated
    % Using function to interpolate.

    
    Fu=scatteredInterpolant(xBase',yBase',zBase',sx,'natural','linear');
    Fv=scatteredInterpolant(xBase',yBase',zBase',sy,'natural','linear');
    Fw=scatteredInterpolant(xBase',yBase',zBase',sz,'natural','linear');

    
    uu=Fu(x,y,z);
    vv=Fv(x,y,z);
    ww=Fw(x,y,z);
    
    %Interpolated Quiver
    
    
    subplot(1,2,1)
    q =quiver3(x,y,z,uu,vv,ww,'Autoscale','off');
    
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
    colorbar
    
    
    axis([-4 16 -4 14 -4 14]);
    hold on
    
    % 3D Quiver
    quiver3(xBase,yBase,zBase,sx.',sy.',sz.','Autoscale','off')
    hold off
    
    
    
    div=divergence(x,y,z,uu,vv,ww);
    
    subplot(1,2,2)
    xslice = [16,6]; 
    yslice = 14; 
    zslice = [-4,6];
    slice(x,y,z,div,xslice,yslice,zslice)
    colorbar
    
    
    
    drawnow;
    cla;
end
