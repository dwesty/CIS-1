function [R_reg, t_reg, closestPts] = icp(vertices,pts,adjacencies)

Np = size(pts,2);

% Transformed data point cloud
transPts = pts;
oldPts = transPts;

% Allocate vector for RMS of errors in every iteration.
ER = zeros(26,1); 

% Initialize total transform vector(s) and rotation matric(es).
t_reg = zeros(3,1);
R_reg = eye(3,3);

oldTrans = [R_reg,t_reg];

kdTree = KDTreeSearcher(vertices');

k = 0;
notDone = true;
while notDone
    k = k + 1;
    
    % Match to vertices
    %[match,mindist] = knnsearch(kdTree,transPts');
    %closestPts = vertices(:,match');
    
    % Match to any point on triangle mesh
    % Should use this instead of above, but error increases after a few
    % iterations
    [closestPts,~,mindist] = findClosestPtOnMesh(transPts,vertices,adjacencies,kdTree);

    if k == 1
        ER(k) = error(closestPts, transPts);    
    end
    
    [R,t] = ptCloudPtCloud(transPts,closestPts);

    % Add to the total transformation
    % Formula [R,t][R_reg,t_reg] = [R1*R2, R1*t2+t1]
    R_reg = R*R_reg;
    t_reg = R*t_reg+t;

    % Apply last transformation on original points
    transPts = R_reg * pts + repmat(t_reg, 1, Np);
    
    % Root mean of objective function
    ER(k+1) = error(closestPts, transPts);
    
    if ER(k+1) > ER(k)
        R_reg = oldTrans(:,1:3);
        t_reg = oldTrans(:,4);
        closestPts = oldPoints;
        notDone = false;
    else
        oldTrans = [R_reg,t_reg];
        oldPoints = closestPts;
        notDone = (k < 25);
    end
    
    % Need better termination condition
    
end
ER
plot(ER)



% Determine the RMS error between two point equally sized point clouds with
% point correspondance.
% ER = rms_error(p1,p2) where p1 and p2 are 3xn matrices.

function ER = error(p1,p2)
error = zeros(1,length(p1));
for i = 1:length(p1)
    error(i) = norm(p1(:,i)-p2(:,i));
end
ER = mean(error);

