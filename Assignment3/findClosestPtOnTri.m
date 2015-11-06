function closestPt = findClosestPtOnTri(pt,tri)
% point: the column vector to project onto the plane
% triangle: the three column vector points that makeup
%           the vertices of the triangle

twoMinusOne = tri(:,2) - tri(:,1)
threeMinusOne = tri(:,3) - tri(:,1)

% Calculate unit normal vector
normal = cross(twoMinusOne,threeMinusOne);
unitNormal = normal/norm(normal);
projection = pt - dot(pt - tri(:,1),unitNormal)*unitNormal;


% Make plane into two dimensions (z = 0)
% Pt 1: Origin, Pt 2: [norm(twoMinusOne);0;0], Pt 3: corresponding point
angle = subspace(threeMinusOne,twoMinusOne);
pt1 = [0;0;0]
pt2 = [norm(twoMinusOne);0;0]
pt3 = [cos(angle)*norm(threeMinusOne);sin(angle)*norm(threeMinusOne);0]



closestPt = projection;

end

