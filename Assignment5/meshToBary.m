function q = meshToBary(currVerts, modes, adjs, triIndices, c)

% verts: 3 x numVerts 
% adjs:  3 x numTris

numK = size(c,2);
numModes = size(modes,3);

q = zeros(3,numK,numModes);
k = 1;
for i = triIndices
    currAdj = adjs(:,i);
        
    v1 = currVerts(:,currAdj(1));
    v2 = currVerts(:,currAdj(2));
    v3 = currVerts(:,currAdj(3));
    TR = triangulation([1,2,3],[v1,v2,v3]');
    
    mult = cartesianToBarycentric(TR,1,c(:,k)')';
    
    for m = 2:numModes
        v1 = modes(:,currAdj(1),m);
        v2 = modes(:,currAdj(2),m);
        v3 = modes(:,currAdj(3),m);
        
        q(1,k,m) = mult(1)*v1(1) + mult(2)*v2(1) + mult(3)*v3(1);
        q(2,k,m) = mult(1)*v1(2) + mult(2)*v2(2) + mult(3)*v3(2);
        q(3,k,m) = mult(1)*v1(3) + mult(2)*v2(3) + mult(3)*v3(3);
    end
    
    k = k + 1;
end




