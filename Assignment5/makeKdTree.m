function tree = makeKdTree(pts, level, tree, index)
% pts: set of triangle cetroids within the reduced space
% level: level of the tree used to determine dimension to sort by
% tree: have to pass through sorted array. This is what gets updated.
% index: tracks index to place center point

% Cycle through sorting dimension. Level 0 --> sort by x first
sortDim = mod(level,3)+1;
sortedPts = (sortrows(pts', sortDim))';
listSize = size(sortedPts);
len = listSize(2);

% Put center point in appropriate array index
centerIndex = ceil(len/2);
centerPoint = sortedPts(:,centerIndex);
tree(:,index) = centerPoint;

% Call function recursively on left subtree if necessary
lastLeftIndex = centerIndex - 1;
if lastLeftIndex >= 1
    leftPoints = sortedPts(:, 1:lastLeftIndex);
    tree = makeKdTree(leftPoints, level+1, tree, 2*index);
end

% Call function recursively on right subtree if necessary
firstRightIndex = centerIndex + 1;
if firstRightIndex <= len
    rightPoints = sortedPts(:, firstRightIndex:len);
    tree = makeKdTree(rightPoints, level+1, tree, 2*index+1);
end

end