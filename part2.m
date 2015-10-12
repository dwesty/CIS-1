%{
CIS Programming Assignment 1
Part 2

Kevin Yee and David West

10 October 2015
%}


clear

calBody = fopen('pa1-unknown-h-calbody.txt');

infoLine = fgetl(calBody);
scanner = textscan(infoLine,'%f%f%f%s','delimiter',',');
numBaseOpMarkers = scanner{1,1};
A = parseFile(calBody,numBaseOpMarkers);

calReadings = fopen('pa1-unknown-h-calreadings.txt');
infoLine = fgetl(calReadings);
scanner = textscan(infoLine,'%f%f%f%f%s','delimiter',',');
B = parseFile(calReadings,numBaseOpMarkers);

[R,p] = part2_function(A,B)






