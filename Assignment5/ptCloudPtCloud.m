function [R,p] = ptCloudPtCloud(A,B)

% Calculates the transformation from 3D point set A to 3D point set B
% Both point sets must be inputted as 3-by-n matrices in the following 
% form: [ x1;y1;z1, x2;y2;z2, x3;y3;z3, ...]
% Resulting transformation follows pattern B = F*A

    % Get number of points in the point set
    numVectors = length(A);
    if numVectors ~= length(B)
        display('Mismatched dimensions');
    end
        
    % Calculate the center of the point set
    sumA = [0;0;0];
    sumB = [0;0;0];
    for i=1:numVectors
        sumA = sumA + A(:,i);   
        sumB = sumB + B(:,i);
    end
    
    aCentroid = sumA/numVectors;
    bCentroid = sumB/numVectors;

    % Translate both point sets about the center of each point set
    adjustedA = zeros(3,numVectors);
    adjustedB = zeros(3,numVectors);
    for i=1:numVectors
        adjustedA(:,i) = A(:,i) - aCentroid;
        adjustedB(:,i) = B(:,i) - bCentroid;
    end
    
    H = zeros(3);
    for i=1:numVectors        
        H = H + adjustedA(:,i)*adjustedB(:,i)';
    end
    
    [U,~,V] = svd(H);
    R = V*U';

    % Calculate the translational component of the transformation
    p = bCentroid - R*aCentroid;
    
end

