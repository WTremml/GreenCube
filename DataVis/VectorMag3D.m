%==========================================================================
%================ Magnetometer Vector Visualization Code ==================
%==========================================================================
% Outline
% 1. Chooses Arduino port
% 2. Initializes port
% 3. Opens new figure and customizes it with start/stop buttons
% 4. Runs a loop that continually reads Magnetometer values
% 5. Displays vectors using line() command

%% Chooses Arduino port

%clear all %comment out if using calibration

% find the correct port by using 'instrfindall'
% comPort = input('Input correct port by using ''instrfindall'' ')
comPort = '/dev/tty.usbmodem1411';
magnum = 8;

%% Initializes port

if(~exist('serialFlag','var'))
    [magnetometer.s,serialFlag] = setSerial(comPort);
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

%Initialize location variables
a=0;
b=0;
d=0;

%arbitrary scale
scale=1000;

%debugging line
%disp('Still Good')

[Center, Radii] = magCal();

while get(button, 'UserData')
[gx, gy, gz] = readMag(magnetometer, magnum);

for z =1:magnum
    gx(z) = gx(z)-Center(1);
    gy(z) = gy(z)-Center(2);
    gz(z) = gz(z)-Center(3);
    
    gx(z) = gx(z)/RadiiAll(3)*400;
    gy(z) = gy(z)/Radii(2)*400;
    gz(z) = gz(z)/RadiiAll(1)*400;
end 

cla;


for c =1:magnum
    
    %Mag placement loop
    a=mod(c,3);
    
    if (a==0)
        a=3;
        Z=[a,b,d];  % Z is the location vector
        b=b+1;      % Once 3 mags have been placed in X, move up one Y row
        if (b==3)   
            d=d-1;  % Once 4 mags have been placed in Y, move down one Z row
            b=0;
        end
    else Z=[a,b,d];
    end
    
    %X,Y,Z origin coordinates
    X1= scale*Z(1)-1;
    Y1= scale*Z(2)-1;
    Z1= scale*Z(3)-1;
    
    line([X1, X1+gx(1,c)], [Y1, Y1+gy(1,c)], [Z1, Z1+gz(1,c)], 'Color', 'b', 'LineWidth', 2, 'Marker', 'o');
    %% Don't forget to add '+gz(1,c)' back
end
    
    limits = 2500;
    axis([0 5000 -1000 4000 -limits limits]);
    axis square;
    grid on;
    xlabel('X-Axis magnitude');

    drawnow;



b=0;
d=0;


end



