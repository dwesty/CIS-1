function closestPt = findNearestNeighbor(pt,tree,index)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
distances = zeros(1,3);

distances(1) = norm(tree(:,index)-pt);

leftChildIndex = 2*index;
if tree(1,leftChildIndex) < inf
    distances(2) = norm(tree(:,leftChildIndex)-pt);
end

rightChildIndex = 2*index + 1;
if tree(1,rightChildIndex) < inf
    distances(3) = norm(tree(:,rightChildIndex)-pt);
end
distances
[~,minIndex] = min(distances)

switch minIndex
    case 1
        closestPt = tree(:,index);
    case 2
        closestPt = findNearestNeighbor(pt,tree,leftChildIndex);
    case 3
        closestPt = findNearestNeighbor(pt,tree,rightChildIndex);
end

end

