%{
    CIS Programming Assignment 2
    Used for Part 2: Distortion Calibration

    Finds the distortion correction function that produces p from c
    Requires scaled parameter matrix

    Kevin Yee and David West
%}

function bezierCoeff = distortionFunction(c, q)

n = 5;

u = scaleToBox(q);
p = scaleToBox(c);

bezierCoeff = zeros(n+1,3);
for j = 1:3
    bezierCoeff(:,j) = bernsteinMatrix(n,u(:,j))\p(:,j);
end

end