function projection = projectOntoVector(origin,corner,point)
%   Project point onto the line defined by corner and origin
        
    % Center corner and point about origin
    line = corner - origin;
    magLine = norm(line);
    pt = point' - origin;
    magPt = norm(pt);
        
    % Find cos(angle between vectors)
    cosAngle = dot(line,pt)/magLine/magPt;
        
    % Find the projection about the origin and add back origin
    projection = magPt*cosAngle*line/magLine + origin;

end

