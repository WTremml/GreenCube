function [  ] = closeSerial(  )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


clc;
clear all;

if ~isempty(instrfind)
    
    delete(instrfind);
    clear instrfind;
end

close all;

clc
disp('Serial Port Closed')

end

