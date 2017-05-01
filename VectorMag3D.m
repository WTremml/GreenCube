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
    
    disp('waiting to start taking samples');
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
scale = 500;

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

axis([-5 15 -15 15 -10 10]);
title('Scaled Vectors');
% title('Raw Vectors');
xlabel('X-Axis magnitude');
ylabel('Y-Axis magnitude');
zlabel('Z-Axis magnitude');
grid on

while get(button, 'UserData')
    % raw mag data points
    [gx, gy, gz] = readMag(magnetometer, magnum);
    gx = gx.';
    gy = gy.';
    gz = gz.';
    
    % scaled mag data (all variables with S)
    [sx, sy, sz] = applyScale(gx, gy, gz, center, radii, scale);
    
    % 3D colored arrows
    mag = (((gx).^2 + (gy).^2 + (gz).^2).^(-.5));
    scmag = mag / max(mag);
    
    magS = (((sx).^2 + (sy).^2 + (sz).^2).^(-.5));
    scmagS = magS / max(magS);
    
    % creates RGB scale for quiver3D arrows
%     arrowcolors = [ones(magnum,1) - scmag, zeros(magnum,1), scmag];
%     arrowcolorsS = [ones(magnum,1) - scmagS, zeros(magnum,1), scmagS];

    % plot raw vectors
%     subplot(1,2,1)
%     qHandle = quiver3D([xBase.',yBase.',zBase.'], .01*[gx, gy, gz],arrowcolors);
%     cla;
    
    % 3D Quiver
%     quiver3(xBase,yBase,zBase,gx.',gy.',gz.')
%     drawnow;
    
    % plot scaled vectors
%     subplot(1,2,2)
%     qHandleS = quiver3D([xBase.',yBase.',zBase.'], .001*[sx, sy, sz],arrowcolorsS);
%     drawnow;
%     cla;

    % 3D Quiver
    quiver3(xBase,yBase,zBase,sx.',sy.',sz.')
    axis([-5 15 -15 15 -10 10]);
    drawnow;
    cla;
end
