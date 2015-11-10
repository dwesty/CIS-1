function closestMeshPt = findClosestPtOnMesh(point,vertices,adjacencies)
%   Find the closest point on a mesh by iterating over the 
%   adjacency array. This may be improved by implementing a
%   more efficient data structure

    centroids = zeros(3,length(adjacencies));
    for i = 1:length(adjacencies)
        sum = zeros(3,1);
        for j = 1:3
           sum = sum + vertices(:,adjacencies(j,i)+1);
        end
        centroids(:,i) = sum/3;
        
    end
    
    centroidTree = ones(3,2*length(centroids))*inf;
    centroidTree = makeKdTree(centroids,0,centroidTree,1);
    
    findNearestNeighbor(point,centroidTree)
    
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


