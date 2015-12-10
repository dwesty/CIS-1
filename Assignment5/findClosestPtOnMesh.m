function [closestMeshPts,minDists] = findClosestPtOnMesh(pts,vertices,adjacencies,tree)

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
    closestMeshPts = zeros(3,size(closestTris,1));
    triIndices = zeros(1,size(closestTris, 1));
    minDists = ones(size(triIndices))*9999;
    for i = 1:size(closestTris,1)
%         minDist = 9999;
        for j = 1:15
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


