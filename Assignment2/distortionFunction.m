%{
    CIS Programming Assignment 2
    Used for Part 2: Distortion Calibration

    Finds the distortion correction function that produces p from c
    Requires scaled parameter matrix

    Kevin Yee and David West
%}

function bezierCoeff = distortionFunction(c, q)

u = scaleToBox(q);
p = scaleToBox(c);

bernsteinMatrix(5,u)
bezierCoeff = bernsteinMatrix(5,u)\p

end