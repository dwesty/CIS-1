function closestPt = findClosestPtOnTri(pt,tri)
% point: the column vector to project onto the plane
% triangle: the three column vector points that makeup
%           the vertices of the triangle

twoMinusOne = tri(:,2) - tri(:,1);
threeMinusOne = tri(:,3) - tri(:,1);

% Calculate unit normal vector
normal = cross(twoMinusOne,threeMinusOne);
unitNormal = normal/norm(normal);
proj = pt - dot(pt - tri(:,1),unitNormal)*unitNormal;

% Note triangulation and cartesiantoBarycentric
% both use input/output row vectors
TR = triangulation([1,2,3],tri');
baryProjPt = cartesianToBarycentric(TR,1,proj');

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
        % Use closest corner (0,0,1)
        closestPt = TR.Points(3,:);
    case 2
        % Use closest corner (0,1,0)
        closestPt = TR.Points(2,:);
    case 3
        % 1) Orthogonal projection of cartesian point onto 
        % cartesian line comprised of TR.Points 2 and 3
        % 2) Convert the projection to barycentric coordinates
        % 3) Analyze based on sign: 
        % Neg y coordinate --> use TR.Points 3
        % Neg z coordinate --> use TR.Points 2
        % Else (x and z are non-neg) --> use the projection

        projection = projectOntoVector(TR.Points(2,:),TR.Points(3,:),pt);
        projBary = cartesianToBarycentric(TR,1,projection);
        
        if projBary(2) <= 0
            closestPt = TR.Points(3,:);
        elseif projBary(3) <= 0
            closestPt = TR.Points(2,:);
        else
            closestPt = projection;
        end
    case 4
        % Use closest corner (1,0,0)
        closestPt = TR.Points(1,:);
    case 5
        % 1) Orthogonal projection of cartesian point onto 
        % cartesian line comprised of TR.Points 1 and 3
        % 2) Convert the projection to barycentric coordinates
        % 3) Analyze based on sign: 
        % Neg z coordinate --> use TR.Points 1
        % Neg x coordinate --> use TR.Points 3
        % Else (x and z are non-neg) --> use the projection
        
        projection = projectOntoVector(TR.Points(1,:),TR.Points(3,:),pt);
        projBary = cartesianToBarycentric(TR,1,projection);
        
        if projBary(1) <= 0
            closestPt = TR.Points(3,:);
        elseif projBary(3) <= 0
            closestPt = TR.Points(1,:);
        else
            closestPt = projection;
        end
    case 6
        % 1) Orthogonal projection of cartesian point onto 
        % cartesian line comprised of TR.Points 1 and 2
        % 2) Convert the projection to barycentric coordinates
        % 3) Analyze based on sign: 
        % Neg y coordinate --> use TR.Points 1
        % Neg x coordinate --> use TR.Points 2
        % Else (x and z are non-neg) --> use the projection

        projection = projectOntoVector(TR.Points(1,:),TR.Points(2,:),pt);
        projBary = cartesianToBarycentric(TR,1,projection);
        
        if projBary(1) <= 0
            closestPt = TR.Points(2,:);
        elseif projBary(2) <= 0
            closestPt = TR.Points(1,:);
        else
            closestPt = projection;
        end
    case 7
        % Inside the triangle, use planar projection
        closestPt = proj';
    otherwise
        display('Invalid Region!');
end

% Convert to column vector
closestPt = closestPt';


end

