% Returns 3 dimensional matrix with displacement coordinates in each mode
% file: file containing the coordinates
% numCoords: number of coordinate sets (x,y,z each)
% numModes: number of modes of displacement

function displacements = getDisplacements(file,numCoords,numModes)
    displacements = zeros(3, numCoords, numModes);
    for i = 1: numModes
        textscan(fgetl(file), '%s'); %scan through comment line
        for j = 1:numCoords
            scanner = textscan(fgetl(file),'%f%f%f','delimiter',',');
            for k = 1:3
                displacements(k,j,i) = scanner{1,k};
            end
        end
    end
end

