function [closestMeshPt,triIndex,minDist] = findClosestPtOnMesh(point,vertices,adjacencies,tree)
%   Find the closest point on a mesh by iterating over the 
%   adjacency array. This may be improved by implementing a
%   more efficient data structure

    closestCorner = knnsearch(tree,point');
    
    closestTris = [];
    for i = 1:length(adjacencies)
        for j = 1:3
            if closestCorner == adjacencies(j,i)
                closestTris = [closestTris,i];
            end
        end
    end
           
    % Initialize comparison variable to large distance and invalid index
    minDist = 9999;
    for i = 1:length(closestTris)
        % Get current adjacencies
        % [1;1;1] must be added because adjacencies are zero indexed
        currAdjacencies = adjacencies(:,closestTris(i));
        
        % Form the triangle vertices
        v1 = vertices(:,currAdjacencies(1));
        v2 = vertices(:,currAdjacencies(2));
        v3 = vertices(:,currAdjacencies(3));
        triangle = [v1,v2,v3];
        
        % Find closest point on current triangle
        closestTriPt = findClosestPtOnTri(point,triangle);
        
        % Find distance from point to closest point on triangle
        currDist = norm(closestTriPt-point);
        
        % If the distance is less than the min distance, update minimum
        if currDist < minDist
            closestMeshPt = closestTriPt;
            triIndex = closestTris(i);
            minDist = currDist;
        end
    end

end

