function [ data ] = storeMagData(out, magnum, samples)
%Stores data from samples from live magnetometer data, .1 s between samples
%   Data array is size of magnum x 3 x samples

data = zeros(magnum, 3, samples);

for i = 1:samples
    % Read data from each mag
    [gx, gy, gz] = readMag(out, magnum);
    
    % Store that sample of data
    for j = 1:magnum
        data(j,1,i) = gx(1,j);
        data(j,2,i) = gy(1,j);
        data(j,3,i) = gz(1,j);
    end
    pause(.1);
end

disp('sampling ended')

end

