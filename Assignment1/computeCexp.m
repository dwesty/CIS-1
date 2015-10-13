%{
    CIS Programming Assignment 1
    Part 4

    Kevin Yee and David West
    10/13/2015
%}

function [C_exp] = computeCexp(bodyFile,readingsFile)
% Input parameters must be file name not including path

fullBodyFile = ['..\Input Data\',bodyFile];

% Get d,a and c from calbody
calBody = fopen(fullBodyFile);
infoLine = fgetl(calBody);
scanner = textscan(infoLine, '%f%f%f%s', 'delimiter', ',');
numBaseOpMarkers = scanner{1,1};
numOpMarkers = scanner{1,2};
numEmMarkers = scanner{1,3};
baseOpMarkers = parseFile(calBody, numBaseOpMarkers);
OpMarkers = parseFile(calBody, numOpMarkers);
emMarkers = parseFile(calBody, numEmMarkers);

% Get D, A and C from calreadings
fullReadingsFile = ['..\Input Data\',readingsFile];
calReadings = fopen(fullReadingsFile);
infoLine2 = fgetl(calReadings);
scanner2 = textscan(infoLine2, '%f%f%f%f%s', 'delimiter', ',');
numBaseOpReadings = scanner2{1,1};
numOpReadings = scanner2{1,2};
numEmReadings = scanner2{1,3};
numFrames = scanner2{1,4};

entireD = [];
entireA = [];
entireC = [];
for i=1:numFrames
    entireD = [entireD;parseFile(calReadings,numBaseOpReadings)];
    entireA = [entireA;parseFile(calReadings,numOpReadings)];
    entireC = [entireC;parseFile(calReadings,numEmReadings)];
end

fclose('all');

aTrans = zeros(numEmMarkers,3);
C_exp = zeros(numEmMarkers*numFrames,3);
for i=1:numFrames
    
    % Get the current D frame from entireD
    currFrameD = zeros(numBaseOpMarkers,3);
    for j=1:numBaseOpMarkers
        currFrameD(j,:) = entireD((i-1)*numBaseOpMarkers+j,:);
    end
    
    % Get the current A frame from entireA
    currFrameA = zeros(numOpMarkers,3);
    for j=1:numOpMarkers
        currFrameA(j,:) = entireA((i-1)*numBaseOpMarkers+j,:);
    end

    % Calculate F_d using part 2
    [R_d,p_d] = part2_function(baseOpMarkers,currFrameD);

    % Calculate the inverse of F_d
    [invFd_R,invFd_p] = invTransformation(R_d,p_d);

    % Calculate F_a using part 2
    [R_a,p_a] = part2_function(OpMarkers,currFrameA);
    
    % Calculate next available spot in C_est
    index = (i-1)*numEmMarkers;
        
    % Perform transformations to find C_est
    for j=1:numEmMarkers
        aTrans(j,:) = R_a*emMarkers(j,:)' + p_a;
        C_exp(index+j,:) = invFd_R*aTrans(j,:)' + invFd_p;
    end
    
end
 
C_exp
end

