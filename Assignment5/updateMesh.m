function newMesh = updateMesh(modes, lambda)
% modes:  3 x numVerts x numModes matrix
% lambda: 1 x (numModes-1) vector
% output: 3 x numVerts matrix

numVerts = size(modes,2);
numModes = size(modes,3);

newMesh = zeros(3,numVerts);
for i = 1:numVerts
    
    sum = zeros(3,1);
    for j = 2:numModes
        sum = sum + modes(:,i,j)*lambda(j-1);
    end
    
     newMesh(:,i) = sum + modes(:,i,1);
%     newMesh(:,i) = sum;
end

end

