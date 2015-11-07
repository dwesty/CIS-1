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

% Note triangulation and cartesiantoBarycentric
% both input/output row vectors
T = [1,2,3];
TR = triangulation(T,tri');
baryProjPt = cartesianToBarycentric(TR,1,projection');

closestPt = baryProjPt';

% Use binary-ish encoding to determine region
% Note: boundaries will go to higher regions
% This is better for points on the triangle edge
region = 0;
if baryProjPt(3) >= 0 
    region = region + 1;
end
if baryProjPt(2) >= 0
    region = region + 2;
end
if baryProjPt(1) >= 0
    region = region + 4;
end

switch region
    case 1
        closestPt = barycentricToCartesian(TR,1,[0,0,1]);
    case 2
        closestPt = barycentricToCartesian(TR,1,[0,1,0]);
    case 3
    case 4
        closestPt = barycentricToCartesian(TR,1,[1,0,0]);
    case 5
    case 6
    case 7
        closestPt = barycentricToCartesian(TR,1,baryProjPt);
    otherwise
        display('Invalid Region!');
end



end

