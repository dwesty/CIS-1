%{
    CIS Programming Assignment 2
    Used for Part 2: Distortion Calibration

    Applies the distortion correction function to any set

    Kevin Yee and David West
%}

function p = correctDistortion(bezierCoeff, q)

u = scaleToBox(q);
maxQ = max(q);
minQ = min(q);

n = 5;
uSize = size(u);

p = zeros(uSize(1),3);

for j = 1:3
    for k=0:n
        toAdd = bezierCoeff(k+1,j) * nchoosek(n,k).*u(:,j).^k.*(1-u(:,j)).^(n-k);
        p(:,j) = p(:,j) + toAdd;
    end
end

p = unscaleFromBox(p, maxQ, minQ);

end