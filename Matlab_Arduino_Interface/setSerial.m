function [ s, flag ] = setSerial( comPort )
%Initializes serial port comunication between MATLAB and ARDUINO
%   a predefined 'acknowledgment routine' in the arduino code ensures that
%   MATLAB can correctly communicate with the serial. If setup woks
%   correctly s = 1 else 0
flag = 1;

delete(instrfindall)

s = serial(comPort);
set(s,'Databits',8);
set(s,'Stopbits',1);
set(s,'BaudRate',115200);
set(s,'Parity','none');
set(s, 'terminator', 'LF'); 

%opens and reads from s, "Serial"
fopen(s);
pause(1);

a='b';

while(a~='a')
   a=fread(s,1,'uchar');
end

if (a=='a')
    disp('serial read');
end

%prints 'char a' to serial and confirms with UI message box
fprintf(s,'%c\n', 'a');
mbox=msgbox('Serial Communication Setup.'); uiwait(mbox);

fscanf(s,'%u');
end

