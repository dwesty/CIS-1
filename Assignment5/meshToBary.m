function q = meshToBary(currVerts, modes, adjs, triIndices, c)
% Calculate the mode values based on the barycentric coordinates
% of c on its respective triangle given by triIndices
% currVerts: the vertices of the mesh (size = 3 x numVerts)
% modes: all mode meshes (size = 3 x numVerts x numModes)
% adjs: matrix of vertex indices all triangle (size = 3 x numTris)
% triIndices: indices of the triangles that correspond to c (size = 3 x k)
% c: points on the mesh that will be used to calculate barycentric
%    coordinates (size = 3 x k)

% Initialize variables
numK = size(c,2);
numModes = size(modes,3);
q = zeros(3,numK,numModes);
k = 1;
for i = triIndices
    % Get vertex indices of current triangle
    currAdj = adjs(:,i);
        
    % Get vertices of current triangle
    v1 = currVerts(:,currAdj(1));
    v2 = currVerts(:,currAdj(2));
    v3 = currVerts(:,currAdj(3));
   
    % Form triangle with vertices and calculate barycentric coordinates
    TR = triangulation([1,2,3],[v1,v2,v3]');
    mult = cartesianToBarycentric(TR,1,c(:,k)')';
    
    % For each mode,calculate the mode values based on the barycentric
    % coordinates of c on its triangle
    for m = 1:numModes
        % Get vertices on current mode
        v1 = modes(:,currAdj(1),m);
        v2 = modes(:,currAdj(2),m);
        v3 = modes(:,currAdj(3),m);

        % Store mode value
        q(:,k,m) = mult(1)*v1 + mult(2)*v2 + mult(3)*v3;
    end
    
    k = k + 1;
end




