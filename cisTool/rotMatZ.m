% Rotate around z axis
% a is angle of rotation in degrees
function rotMat = rotMatZ(a)

rotMat = [cosd(a) -sind(a) 0; sind(a) cosd(a) 0; 0 0 1]

end