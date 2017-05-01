function [ gx, gy, gz ] = readMag(out, magnum)
%readMag Stores magnetometer data into three arrays
%   Each array is length magnum

fprintf(out.s,'R');

for c =1:magnum
    gx(1,c)=fscanf(out.s,'%f');
    gy(1,c)=fscanf(out.s,'%f');
    gz(1,c)=fscanf(out.s,'%f');
end


end

