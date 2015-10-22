%{
    CIS Programming Assignment 2
    Used for Part 2: Distortion Calibration

    Applies the distortion correction function to any set

    Kevin Yee and David West
%}

function corrected = correctDistortion(bezierCoeff, q)

u = scaleToBox(q);
maxQ = max(q);
minQ = min(q);

n = 5;
uSize = size(u);

p = zeros(uSize(1),3);
coeff = zeros(length(u),n+1,3);
for j = 1:3
    coeff(:,:,j) = bernsteinMatrix(n,u(:,j));
end

z=1;
F_p = zeros(length(u),(n+1)^3);
for i = 1:n+1
   for j = 1:n+1
      for k = 1:n+1
          F_p(:,z) = coeff(:,i,1).*coeff(:,j,2).*coeff(:,k,3);
          z=z+1;
      end
   end
end

corrected = F_p*bezierCoeff;

corrected = unscaleFromBox(corrected, maxQ, minQ);

end