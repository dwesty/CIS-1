function closestMeshPt = findClosestPtOnMesh(point,vertices,adjacencies)
%   Find the closest point on a mesh by iterating over the 
%   adjacency array. This may be improved by implementing a
%   more efficient data structure
    
    % Initialize comparison variable to large distance and invalid index
    minDist = 9999;
    closestMeshPt = point + [999;999;999];
    for i = 1:length(adjacencies)
        % Get current adjacencies
        % [1;1;1] must be added because adjacencies are zero indexed
        currAdjacencies = adjacencies(:,i) + [1;1;1];
        
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
            minDist = currDist;
        end
    end
   
end


