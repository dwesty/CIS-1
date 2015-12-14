function newMesh = updateMesh(modes, lambda)
% Update the mesh based on the weight of each mode previously calculated
% modes:  3 x numVerts x numModes matrix
% lambda: 1 x (numModes-1) vector

numVerts = size(modes,2);
numModes = size(modes,3);
newMesh = zeros(3,numVerts);
for i = 1:numVerts
    
    % Sum the principal components multiplied by the weights
    sum = zeros(3,1);
    for j = 2:numModes
        sum = sum + (modes(:,i,j) - modes(:,i,1))*lambda(j-1);
%         sum = sum + modes(:,i,j)*lambda(j-1);
    end
    
    % Add the sum to the average mesh
    newMesh(:,i) = sum + modes(:,i,1);
%     newMesh(:,i) = sum;
end

end

