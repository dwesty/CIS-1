function q = meshToBary(curVerts, modes, adjs, triIndices, c)
% verts: 3 x numVerts 
% adjs:  3 x numTris

numK = size(c,2);
numModes = size(modes,3);

q = zeros(3,numK,numModes);

for i = triIndices
    currAdj = adjs(:,i);

    v1 = curVerts(:,currAdj(1),m);
    v2 = curVerts(:,currAdj(2),m);
    v3 = curVerts(:,currAdj(3),m);

    TR = triangulation([1,2,3],[v1,v2,v3]');
    q(:,k,m) = cartesianToBarycentric(TR,1,c(:,k)')';
    k = k + 1;
end



end

