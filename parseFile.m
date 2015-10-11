function matrix = parseFile(file,lines)
%{ Function to parse the data coordinates from an input file. 
matrix = zeros(lines,3);
for i = 1:lines
    scanner = textscan(fgetl(file),'%f%f%f','delimiter',',');
    x = scanner{1,1};
    y = scanner{1,2};
    z = scanner{1,3};
    matrix(i,1) = x;
    matrix(i,2) = y;
    matrix(i,3) = z;
end

end

