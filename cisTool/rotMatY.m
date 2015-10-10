% Rotate around y axis
% a is angle of rotation in degrees
function rotMat = rotMatY(a)

rotMat = [cosd(a) 0 sind(a); 0 1 0; -sind(a) 0 cosd(a)]

end