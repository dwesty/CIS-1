function [R_reg, t_reg, closestPts, transPts, triIndices] = icp(vertices,pts,adjacencies)
% Function to iteratively match a set of points to a mesh
% As it is written, it requires a defined number of iterations, but it
% would be improved by adding a stop condition based on the match quality
% vertices: vertices of the mesh (3 x numVerts)
% pts: the points to match to the mesh (3 x numPoints)
% adjacencies: the vertex indices of each triangle (size = 3 x numTris)

% Number of points
numPts = size(pts,2);

% Number of iterations
iter = 50;

% Transformed points 
transPts = pts;

% Array to hold the error between the mesh and the points
error = zeros(iter+1,1); 

% Initialize total transform vector and rotation matrix
t_reg = zeros(3,1);
R_reg = eye(3,3);

% Build KD Tree to search through the vertices
kdTree = KDTreeSearcher(vertices');

k = 0;
notDone = true;
while notDone
    k = k + 1;
    
    % Match to any point on triangle mesh
    [closestPts,~,triIndices] = findClosestPtOnMesh(transPts,vertices,adjacencies,kdTree);
    
    % Calculate first error
    if k==1
        error(k) = findError(closestPts, transPts);
    end
    
    % Calculate current transformation
    [R,t] = ptCloudPtCloud(transPts,closestPts);

    % Add to the total transformation
    % Formula [R,t][R_reg,t_reg] = [R*R_reg, R*t_reg+t]
    R_reg = R*R_reg;
    t_reg = R*t_reg+t;

    % Apply total transformation on original points
    transPts = R_reg * pts + repmat(t_reg, 1, numPts);
    
    % Calculate error
    error(k+1) = findError(closestPts, transPts);
    
    % Stop after 'iter' many loops 
    notDone = (k < iter);
end



% Determine the error between two point clouds 
function error = findError(p1,p2)
err = zeros(1,length(p1));
for i = 1:length(p1)
    err(i) = norm(p1(:,i)-p2(:,i));
end
error = mean(err);

