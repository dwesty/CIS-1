function transformed = transform(transformation,point)
%   Perform a transformation on a point
%   transformation: 3x4 matrix where first 3 columns are 
%   rotation and fourth column is translation
%   point must be a column vector

    rotation = [transformation(:,1),transformation(:,2),transformation(:,3)];
    translation = transformation(:,4);
    
    transformed = rotation*point+translation;

end

