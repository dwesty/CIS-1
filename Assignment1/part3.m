%{
    CIS Programming Assignment 1
    Part 3

    Kevin Yee and David West
%}

clear

path = 'C:\Users\Kevin\Desktop\CIS-1\Assignment1\PA-12 Student Data\';
fileName = 'pa1-unknown-h-empivot.txt';

emPivot = fopen(fullfile(path,fileName));

infoLine = fgetl(emPivot);
scanner = textscan(infoLine, '%f%f%s', 'delimiter', ',');
numEmMarkers = scanner{1,1};
numFrames = scanner{1,2};


for i=1:numFrames
    
    G = parseFile(emPivot,numEmMarkers);
    
    sumG = [0,0,0];
    for j=1:numEmMarkers
        sumG = sumG + G(j,:);
    end

    centroidG = sumG/numEmMarkers;

    g_j = 0*G;
    for j=1:numEmMarkers
        g_j(j,:) = G(j,:) - centroidG;
    end

    %FIXME: Currently returns R=I and p=centroidG.
    %I don't think that is correct
    [Fg_R,Fg_p] = part2_function(g_j,G)
end

fclose('all');



