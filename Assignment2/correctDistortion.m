%{
    CIS Programming Assignment 2
    Used for Part 2: Distortion Calibration

    Applies the distortion correction function to any set

    Kevin Yee and David West
%}

function p = correctDistortion(c, q)

bezierCoeff = distortionFunction(c, q);

n = 5;
uSize = size(u);

F_u = zeros(uSize(1),1);

for k=0:n
    toAdd = bezierCoeff(k+1) * nchoosek(n,k).*u.^k.*(1-u).^(n-k)
    F_u = F_u + toAdd;
end

end