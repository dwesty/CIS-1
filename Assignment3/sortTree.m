function sortedTree = sortTree(pts, level, sortedTree, n)
% pts: set of triangle cetroids within the reduced space
% level: level of the tree, since we need to do this recursively
% sortedArray: have to pass through sorted array. This is what gets updated.
% n: tracks index for next child nodes

pts
A = sortrows(pts', mod(level,3)+1);
A = A'
listSize = size(A)
len = listSize(2)

centerIndex = ceil(len/2)
centerPoint = A(:, centerIndex);

sortedTree(:,n) = centerPoint

if ((centerIndex - 1) > 0)
    leftPoints = A(:, 1:centerIndex)
    n
    sortedTree(:,2*n) = sortTree(leftPoints, level+1, sortedTree, 2*n) 
end

if ((centerIndex + 1) < len)
    rightPoints = A(:, (centerIndex+1):listSize);
    sortedTree(:,2*n+1) = sortTree(rightPoints, level+1, sortedTree, 2*n+1)
end


end