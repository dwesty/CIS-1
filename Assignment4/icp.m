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

% Go into main iteration loop
for k=1:10

    [match,mindist] = match_kDtree(vertices,transPts,kdTree);
    
    % Should use this instead of above
    %[meshPts,triIndices,mindist2] = findClosestPtOnMesh(transPts,vertices,adjacencies,kdTree);

    p_idx = true(1, Np);
    q_idx = match;

    if k == 1
        ER(k) = sqrt(sum(mindist.^2)/length(mindist));
    end
    
    closestPts = vertices(:,q_idx);

    [R,t] = ptCloudPtCloud(transPts,closestPts);

    % Add to the total transformation
    R_reg = R*R_reg;
    t_reg = R*t_reg+t;

    % Apply last transformation
    transPts = R_reg * pts + repmat(t_reg, 1, Np);
    
    % Root mean of objective function 
    ER(k+1) = rms_error(closestPts, transPts(:,p_idx));
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [match mindist] = match_kDtree(~, p, kdOBJ)
	[match mindist] = knnsearch(kdOBJ,transpose(p));
    match = transpose(match);

% Determine the RMS error between two point equally sized point clouds with
% point correspondance.
% ER = rms_error(p1,p2) where p1 and p2 are 3xn matrices.

function ER = rms_error(p1,p2)
dsq = sum(power(p1 - p2, 2),1);
ER = sqrt(mean(dsq));

