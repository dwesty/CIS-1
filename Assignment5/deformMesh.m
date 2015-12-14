function [deformedMesh, c, lambda] = deformMesh(vertices, adjacencies, triIndices, modeMeshes, c_init, s)
% Function to handle the mesh deformation 
% vertices: vertices of the mesh to deform (size = 3 x numVerts)
% adjacencies: matrix of vertex indices all triangle (size = 3 x numTris)
% triIndices: the indices of the triangles that c_init are on
% modeMeshes: all mode meshes (size = 3 x numVerts x numModes) 
% c_init: set of points on the mesh corresponding to measurements
% s: set of points close to the mesh returned by icp

% Initialize variables for deform mesh loop
currMesh = vertices;
c = c_init;
iter = 20;
diff = zeros(iter,1);
kdTree = KDTreeSearcher(vertices');
numModes = size(modeMeshes, 3);
for i = 1:iter
    % Calculate difference between c and s. Minimize this difference
    diff(i) = norm(c-s)
    
    % Calculate mode values based on barycentric coordinates of c
    q_m_k = meshToBary(currMesh, modeMeshes, adjacencies, triIndices, c);
    
    % Update weights of each mode based on mode values
    lambda = updateWeights(q_m_k, s, numModes);
    
    % Update mesh based on the new weights
    currMesh = updateMesh(modeMeshes,lambda);
    
    % Find the points closest to the new mesh
    c = findClosestPtOnMesh(s, currMesh, adjacencies, kdTree);
    
end

% The deformed mesh is the result of the loop
deformedMesh = currMesh;

end

