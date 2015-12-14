function displacements = getDisplacements(file,numCoords,numModes)
% Returns matrix with displacement coordinates in each mode of 
%       of size = 3 x numVerts x numModes
% file: file containing the coordinates
% numCoords: number of coordinate sets (x,y,z each)
% numModes: number of modes of displacement
displacements = zeros(3, numCoords, numModes);
for i = 1: numModes
    fgetl(file); %scan through comment line
    for j = 1:numCoords
        scanner = textscan(fgetl(file),'%f%f%f','delimiter',',');
        for k = 1:3
            displacements(k,j,i) = scanner{1,k};
        end
    end
end

end

