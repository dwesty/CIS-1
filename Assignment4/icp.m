function F_reg = icp(q,m,adjs,kdTree)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    numPoints = length(q);
    numTris = length(adjs);

    % Iteration Number
    n = 0;

    % Initially assume F_reg is Identity with zero translation
    F_reg = zeros(3,4);
    F_reg(1,1) = 1;
    F_reg(2,2) = 1;
    F_reg(3,3) = 1;
    
    % Current match distance threshold
    eta = 10;

    I = ones(1,numPoints);      % Indices of tris
    
    C = zeros(3,numPoints);     % Closest points
    D = zeros(1,numPoints);     % Distances
    
    for i = 1:numPoints
        C(:,i) = m(:,1);  
        D(i) = norm(C(:,i)-transform(F_reg,q(:,i)));
    end
    
    % Start by doing only 10 iterations
    for j = 1:100 % "not coverged"
        
        A = zeros(3,numPoints);
        B = A;
        for i = 1:numPoints
            
            [closestPt,~,minDist] = findClosestPtOnMesh(transform(F_reg,q(:,i)),m,adjs,kdTree);    

            A(:,i) = transform(F_reg,q(:,i));
            B(:,i) = closestPt;
            
        end
        n = n + 1;
        [R,p] = ptCloudPtCloud(A,B);
        F_reg = [R,p];
    end

end
