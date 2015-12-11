function [R_reg, t_reg, closestPts, transPts, triIndices] = icp(vertices,pts,adjacencies)

Np = size(pts,2);
iter = 40;

% Transformed data point cloud
transPts = pts;
% oldTransPts = transPts;

% Allocate vector for RMS of errors in every iteration.
ER = zeros(iter,1); 

% Initialize total transform vector(s) and rotation matric(es).
t_reg = zeros(3,1);
R_reg = eye(3,3);

% Variable to hold previous transformation in the case that 
% we find a minimum in the error
% oldTrans = [R_reg,t_reg];

% Build KD Tree
kdTree = KDTreeSearcher(vertices');

k = 0;
notDone = true;
while notDone
    k = k + 1;
    
    % Match to any point on triangle mesh
    [closestPts,~,triIndices] = findClosestPtOnMesh(transPts,vertices,adjacencies,kdTree);
    
    if k==1
        ER(k) = error(closestPts, transPts);
    end
    
    % Calculate current transformation
    [R,t] = ptCloudPtCloud(transPts,closestPts);

    % Add to the total transformation
    % Formula [R,t][R_reg,t_reg] = [R*R_reg, R*t_reg+t]
    R_reg = R*R_reg;
    t_reg = R*t_reg+t;

    % Apply total transformation on original points
    transPts = R_reg * pts + repmat(t_reg, 1, Np);
    
    % Calculate error
    ER(k+1) = error(closestPts, transPts);
    
    % Stop after 'iter' many loops (convergence)
    notDone = (k < iter);
end

plot(ER)



% Determine the error between two point clouds 
% ER = rms_error(p1,p2) where p1 and p2 are 3xn matrices.

function ER = error(p1,p2)
error = zeros(1,length(p1));
for i = 1:length(p1)
    error(i) = norm(p1(:,i)-p2(:,i));
end
ER = mean(error);

