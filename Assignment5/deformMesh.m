function [deformedMesh, c] = deformMesh(vertices, adjacencies, triIndices, modeMeshes, c_init, s)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

currMesh = vertices;
c = c_init;
iter = 10;
diff = zeros(iter,1);
kdTree = KDTreeSearcher(vertices');
numModes = size(modeMeshes, 3);
for i = 1:iter
    diff(i) = norm(c-s)
    % Calculate Q values
    q_m_k = meshToBary(currMesh, modeMeshes, adjacencies, triIndices, c);
    
    % Update Lambda
    lambda = updateWeights(q_m_k, s, numModes);
    
    % Update Mesh
    currMesh = updateMesh(modeMeshes,lambda);
    
    % Update C
    c = findClosestPtOnMesh(s, currMesh, adjacencies, kdTree);
    
   % c = updateC(currMesh,adjacencies,triIndices,q_m_k(:,:,1));
end

deformedMesh = currMesh;

end

