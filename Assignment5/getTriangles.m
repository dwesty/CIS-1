function coordinates = getTriangles(file,numCoords)
    coordinates = zeros(3,numCoords);
    for i = 1:numCoords
        scanner = textscan(fgetl(file),'%f%f%f%f%f%f','delimiter',',');
        for j = 1:3
            coordinates(j,i) = scanner{1,j};
        end
    end
end

