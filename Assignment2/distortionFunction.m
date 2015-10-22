%{
    CIS Programming Assignment 2
    Used for Part 2: Distortion Calibration

    Finds the distortion correction function that produces p from c
    Requires scaled parameter matrix

    Kevin Yee and David West
%}

function bern = distortionFunction(c, q)

n = 5;

u = scaleToBox(q);
p = scaleToBox(c);

coeff = zeros(length(u),n+1,3);
for j = 1:3
    coeff(:,:,j) = bernsteinMatrix(n,u(:,j));
end

z=1;
F = zeros(length(u),(n+1)^3);
for i = 1:n+1
   for j = 1:n+1
      for k = 1:n+1
          F(:,z) = coeff(:,i,1).*coeff(:,j,2).*coeff(:,k,3);
          z=z+1;
      end
   end
end


bern = F\p;
size(bern)


end