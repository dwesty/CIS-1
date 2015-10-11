% Number 4
% A - Computing frame
clear

calBody = fopen('pa1-debug-a-calbody.txt')

infoLine = fgetl(calBody);
scanner = textscan(infoLine, '%f%f%f%s', 'delimiter', ',');
numBaseOpMarkers = scanner{1,1}
numOpMarkers = scanner{1,2}
numEmMarkers = scanner{1,3}

baseOpMarkers = parseFile(calBody, numBaseOpMarkers)

calReadings = fopen('pa1-debug-a-calreadings.txt')

infoLine2 = fgetl(calReadings);
scanner2 = textscan(infoLine2, '%f%f%f%s', 'delimiter', ',');
numBaseOpReadings = scanner2{1,1}
numOpReadings = scanner2{1,2}
numEmReadings = scanner2{1,3}

baseOpReadings = parseFile(calReadings, numBaseOpReadings)

%Should not be getting 0
% F_d = [ones(8,1),baseOpMarkers]\baseOpReadings;

[regParams,Bfit,ErrorStats] = absor(baseOpMarkers',baseOpReadings') 

fclose('all')
