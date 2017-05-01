function [ sx, sy, sz ] = applyScale(gx, gy, gz, center, radii, scale)
%Scales magnetometer data by using center, radii, and scale factor

sx = (gx - center(:,1))./radii(:,1) * scale;
sy = (gy - center(:,2))./radii(:,2) * scale;
sz = (gz - center(:,3))./radii(:,3) * scale;

end

