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

clear all

% find the correct port by using 'instrfindall'
% comPort = input('Input correct port by using ''instrfindall'' ')
comPort = '/dev/tty.usbmodemFA141';
magnum = 18;

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

a=0;
b=0;
d=0;
scale=1000;

%disp('Still Good')

while get(button, 'UserData')
[gx, gy, gz] = readMag(magnetometer, magnum);

cla;

%{
line([0 gx(10)], [0 0], [0 0], 'Color', 'r', 'LineWidth', 2, 'Marker', 'o');
line([0 0], [0 gy(10)], [0 0], 'Color', 'b', 'LineWidth', 2, 'Marker', 'o');
line([0 0], [0 0], [0 gz(10)], 'Color', 'g', 'LineWidth', 2, 'Marker', 'o');

line([scale gx(11)+scale],   [0 0],      [0 0], 'Color', 'r', 'LineWidth', 2, 'Marker', 'o');
line([scale 0+scale],       [0 gy(11)],  [0 0], 'Color', 'b', 'LineWidth', 2, 'Marker', 'o');
line([scale 0+scale],       [0 0],      [0 gz(11)], 'Color', 'g', 'LineWidth', 2, 'Marker', 'o');

line([-scale gx(12)-scale],   [0 0],      [0 0], 'Color', 'r', 'LineWidth', 2, 'Marker', 'o');
line([-scale 0-scale],       [0 gy(12)],  [0 0], 'Color', 'b', 'LineWidth', 2, 'Marker', 'o');
line([-scale 0-scale],       [0 0],      [0 gz(12)], 'Color', 'g', 'LineWidth', 2, 'Marker', 'o');

limits = 800;
    axis([(-limits-scale) (scale+limits) -limits limits -limits limits]);
    axis square;
    grid on;
    xlabel('X-Axis magnitude');

    drawnow;
%}


for c =1:magnum
    
    a=mod(c,3);
    if (a==0)
        a=3;
        Z=[a,b,d];
        b=b+1;
        if (b==3) 
            d=d+1;
            b=0;
        end
    else Z=[a,b,d];
    end
    
    %X,Y,Z origin coordinates
    X1= scale*Z(1)-1;
    Y1= scale*Z(2)-1;
    Z1= scale*Z(3)-1;
    
    line([X1, X1+gx(1,c)], [Y1, Y1+gy(1,c)], [Z1, Z1], 'Color', 'b', 'LineWidth', 2, 'Marker', 'o');
    %% Don't forget to add '+gz(1,c)' back
end
    
    limits = 2500;
    axis([0 4000 -1000 4000 -limits limits]);
    axis square;
    grid on;
    xlabel('X-Axis magnitude');

    drawnow;



b=0;
d=0;


end



