function [R,p] = part2_function(A,B)

% Calculates the transformation from 3D point set A to 3D point set B
% Both point sets must be inputted as n-by-3 matrices in the following 
% form: [ x1,y1,z1; x2,y2,z2; x3,y3,z3; ...]

    % Get number of points in the point set
    numVectors = length(A);
    if numVectors ~= length(B)
        display('Mismatched dimensions');
    end
        
    % Calculate the center of the point set
    sumA = [0,0,0];
    sumB = [0,0,0];
    for i=1:numVectors
        sumA(1) = sumA(1) + A(i,1);
        sumA(2) = sumA(2) + A(i,2);
        sumA(3) = sumA(3) + A(i,3);
    
        sumB(1) = sumB(1) + B(i,1);
        sumB(2) = sumB(2) + B(i,2);
        sumB(3) = sumB(3) + B(i,3);
    end
    aCentroid = sumA/length(A);
    bCentroid = sumB/length(B);

    % Translate both point sets about the center of each point set
    adjustedA = zeros(numVectors,3);
    adjustedB = zeros(numVectors,3);
    for i=1:numVectors
        adjustedA(i,1) = aCentroid(1) - A(i,1);
        adjustedA(i,2) = aCentroid(2) - A(i,2);
        adjustedA(i,3) = aCentroid(3) - A(i,3);

        adjustedB(i,1) = bCentroid(1) - B(i,1);
        adjustedB(i,2) = bCentroid(2) - B(i,2);
        adjustedB(i,3) = bCentroid(3) - B(i,3);
    end

    % Use a least squares algorithm to calculate the rotation matrix
    R = zeros(3);
    R(:,1) = lsqnonneg(adjustedA,adjustedB(:,1));
    R(:,2) = lsqnonneg(adjustedA,adjustedB(:,2));
    R(:,3) = lsqnonneg(adjustedA,adjustedB(:,3));
    
    % Calculate the translational component of the transformation
    p = (bCentroid' - R*aCentroid')';

end

