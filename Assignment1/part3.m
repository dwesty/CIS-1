%{
    CIS Programming Assignment 1
    Part 3

    Kevin Yee and David West
%}

clear

emPivot = fopen('pa1-debug-a-empivot.txt');

infoLine = fgetl(emPivot);
scanner = textscan(infoLine, '%f%f%s', 'delimiter', ',');
numEmMarkers = scanner{1,1};
numFrames = scanner{1,2};

G = parseFile(emPivot,numEmMarkers)