function closestPt = findClosestPtOnTri(pt,tri)
% point: the column vector to project onto the plane
% triangle: the three column vector points that makeup
%           the vertices of the triangle

twoMinusOne = tri(:,2) - tri(:,1);
threeMinusOne = tri(:,3) - tri(:,1);

% Calculate unit normal vector
normal = cross(twoMinusOne,threeMinusOne);
unitNormal = normal/norm(normal);
projection = pt - dot(pt - tri(:,1),unitNormal)*unitNormal;

T = [1,2,3];
TR = triangulation(T,tri');

B = cartesianToBarycentric(TR,1,projection')

end

