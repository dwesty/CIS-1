function [R_reg, t_reg, closestPts] = icp(vertices,pts,adjacencies)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Np = size(pts,2);

% Transformed data point cloud
transPts = pts;

% Allocate vector for RMS of errors in every iteration.
ER = zeros(11,1); 

% Initialize total transform vector(s) and rotation matric(es).
t_reg = zeros(3,1);
R_reg = eye(3,3);

kdTree = KDTreeSearcher(vertices');

k = 0;
notDone = true;
while notDone
    k = k + 1;
    
    % Match to vertices
    [match,mindist] = knnsearch(kdTree,transPts');
    closestPts = vertices(:,match');
    
    % Match to any point on triangle mesh
    % Should use this instead of above, but error increases after a few
    % iterations
    %[closestPts,~,mindist] = findClosestPtOnMesh(transPts,vertices,adjacencies,kdTree);

    if k == 1
        ER(k) = sqrt(sum(mindist.^2)/length(mindist));
    end
    
    [R,t] = ptCloudPtCloud(transPts,closestPts);

    % Add to the total transformation
    R_reg = R*R_reg;
    t_reg = R*t_reg+t;

    % Apply last transformation
    transPts = R_reg * pts + repmat(t_reg, 1, Np);
    
    % Root mean of objective function 
    ER(k+1) = rms_error(closestPts, transPts);
    
    % Need better termination condition
    notDone = (k < 10);
end
ER

% Determine the RMS error between two point equally sized point clouds with
% point correspondance.
% ER = rms_error(p1,p2) where p1 and p2 are 3xn matrices.

function ER = rms_error(p1,p2)
dsq = sum(power(p1 - p2, 2),1);
ER = sqrt(mean(dsq));

