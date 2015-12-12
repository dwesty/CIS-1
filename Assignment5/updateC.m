function c = updateC(verts, adjs, triIndices, q_k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


c = zeros(size(q_k));
k = 1;
for i = triIndices
   currAdj = adjs(:,i);
        
   v1 = verts(:,currAdj(1));
   v2 = verts(:,currAdj(2));
   v3 = verts(:,currAdj(3));
        
   TR = triangulation([1,2,3],[v1,v2,v3]');
   c(:,k) = barycentricToCartesian(TR,1,q_k(:,k)')';
   k = k + 1;
end

end

