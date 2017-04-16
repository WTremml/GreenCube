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
comPort = '/dev/tty.usbmodemFD131';

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

while get(button, 'UserData')
[gx, gy, gz] = readMag(magnetometer);

cla;

line([0 gx], [0 0], 'Color', 'r', 'LineWidth', 2, 'Marker', 'o');

limits = 600;
axis([-limits limits -limits limits]);
axis square;
grid on;
xlabel('X-Axis magnitude');

%theta = atand(
%phi = 
%title(['Vector Angle: 'num2str(theta, %

drawnow;

end



%Github Test
