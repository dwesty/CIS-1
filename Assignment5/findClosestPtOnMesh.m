function [closestMeshPts,minDists,triIndices] = findClosestPtOnMesh(pts,vertices,adjacencies,tree)
% Function to find the closest points on a mesh to a point set
% pts: the points to match to the mesh (size = 3 x k)
% vertices: the vertices of the mesh (size = 3 x numVerts)
% adjacencies: the vertex indices of each triangle (size = 3 x numTris)
% tree: kd tree composed of the vertices; used for searching
% closhestMeshPts: points on the mesh closest to pts
% minDists: the distances from closestMeshPts to pts
% triIndices: the indices of adjacencies that closestMeshPts are on

% Find the closest vertex to each point in pts
closestCorners = knnsearch(tree,pts');

closestTris = zeros(length(closestCorners),15);
for i = 1:size(closestCorners, 1)
    counter = 1;
    for j = 1:size(adjacencies, 2)
        for k = 1:3
            if closestCorners(i) == adjacencies(k,j)
                closestTris(i,counter) = j;
                counter = counter + 1;
            end    
        end
    end
end
    
    
% Initialize comparison variable to large distance and invalid index
minDists = ones(1,size(closestTris,1))*9999;
closestMeshPts = zeros(3,size(closestTris,1));
triIndices = zeros(1,size(closestTris, 1));
for i = 1:size(closestTris,1)
    for j = 1:15
        % If there are no more closest triangles, exit the loop
        if closestTris(i,j) == 0
            break;
        end
            
        % Get current adjacencies
        currAdjacencies = adjacencies(:,closestTris(i,j));
        
        % Form the triangle vertices
        v1 = vertices(:,currAdjacencies(1));
        v2 = vertices(:,currAdjacencies(2));
        v3 = vertices(:,currAdjacencies(3));
        triangle = [v1,v2,v3];
        
        % Find closest point on current triangle
        closestTriPt = findClosestPtOnTri(pts(:,i),triangle);
        
        % Find distance from point to closest point on triangle
        currDist = norm(closestTriPt-pts(:,i));
        
        % If the distance is less than the min distance, update minimum
        if currDist < minDists(i)
            closestMeshPts(:,i) = closestTriPt;
            triIndices(i) = closestTris(i,j);
            minDists(i) = currDist;
        end
    end
end

end


