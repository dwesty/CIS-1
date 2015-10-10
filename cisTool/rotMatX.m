% Rotate around x axis
% a is angle of rotation in degrees
function rotMat = rotMatX(a)

rotMat = [1 0 0; 0 cosd(a) -sind(a); 0 sind(a) cosd(a)]

end