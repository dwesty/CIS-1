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
        sumA = sumA + A(i,:);   
        sumB = sumB + B(i,:);
    end
    
    aCentroid = sumA/numVectors;
    bCentroid = sumB/numVectors;

    % Translate both point sets about the center of each point set
    adjustedA = zeros(numVectors,3);
    adjustedB = zeros(numVectors,3);
    for i=1:numVectors
        adjustedA(i,:) = A(i,:) - aCentroid;

        adjustedB(i,:) = B(i,:) - bCentroid;
    end
    
    display(ad

    % Use a least squares algorithm to calculate the rotation matrix
    R = zeros(3);
    R(:,1) = lsqnonneg(adjustedA,adjustedB(:,1));
    R(:,2) = lsqnonneg(adjustedA,adjustedB(:,2));
    R(:,3) = lsqnonneg(adjustedA,adjustedB(:,3));
    
    % Calculate the translational component of the transformation
    p = (bCentroid' - R*aCentroid')';

end

