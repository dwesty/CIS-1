%{
    Programming Assignment 3
    Main Script

    Kevin Yee & David West
    11/06/2015
    Computer Integrated Surgery I
%}
clear;

% Input File Path
inputFilePath = '../PA-345 Student Data/';

% Mesh File
meshFilePath = [inputFilePath,'Problem3Mesh.sur'];
meshFile = fopen(meshFilePath);

% Get triangle vertices
meshScanner = textscan(fgetl(meshFile),'%f');
numVertices = meshScanner{1,1};
vertices = getCoordinates(meshFile,numVertices);

% Get triangle adjacency indices
meshScanner = textscan(fgetl(meshFile),'%f');
numTriangles = meshScanner{1,1};
adjacencies = getTriangles(meshFile,numTriangles);

% Rigid Body Design File A
problemFilePathA = [inputFilePath,'Problem3-BodyA.txt'];
problemFileA = fopen(problemFilePathA);
aScanner = textscan(fgetl(problemFileA),'%f%s','delimiter',',');
numMarkersA = aScanner{1,1};
markersA = getCoordinates(problemFileA,numMarkersA); %A
tipA = getCoordinates(problemFileA,1);

findClosestPtOnMesh([0;0;0],vertices,adjacencies)

% Rigid Body Design File B
problemFilePathB = [inputFilePath,'Problem3-BodyB.txt'];
problemFileB = fopen(problemFilePathB);
bScanner = textscan(fgetl(problemFileB),'%f%s','delimiter',',');
numMarkersB = bScanner{1,1};
markersB = getCoordinates(problemFileB,numMarkersB); %B
tipB = getCoordinates(problemFileB,1);

% Sample Readings File
run = 'A-Debug';
sampleFilePath = [inputFilePath,'PA3-',run,'-SampleReadingsTest.txt'];
sampleFile = fopen(sampleFilePath);
sampleScanner = textscan(fgetl(sampleFile),'%f%f%s','delimiter',',');
numTotalLeds = sampleScanner{1,1};
numSamples = sampleScanner{1,2};

% Dummy Markers are all remaining after A and B
numDummy = numTotalLeds - numMarkersA - numMarkersB;

% Initialize frame variables
% Some of these may not need to be saved
aMarkersTracker = zeros(3,numMarkersA,numSamples); %a_i,k
bMarkersTracker = zeros(3,numMarkersB,numSamples); %b_i,k
dummyMarkersTracker = zeros(3,numDummy,numSamples);
transformsA = zeros(3,4,numSamples);    % F_A,k
transformsB = transformsA;              % F_B,k
invTransformsB = transformsB;           % Inverse of B
bodyToTip = zeros(3,numSamples);        % d_k
tipInCt = bodyToTip;                    % c_k
for i = 1:numSamples
    
    % Get the marker coordinates relative to the tracker
    aMarkersTracker(:,:,i) = getCoordinates(sampleFile,numMarkersA);
    bMarkersTracker(:,:,i) = getCoordinates(sampleFile,numMarkersB);
    dummyMarkersTracker(:,:,i) = getCoordinates(sampleFile,numDummy);
    
    % Calculate transformation from markers in body 
    % coordinates to markers in tracker coordinates
    [currRotA,currTransA] = ptCloudPtCloud(markersA,aMarkersTracker(:,:,i));
    [currRotB,currTransB] = ptCloudPtCloud(markersB,bMarkersTracker(:,:,i));
    transformsA(:,:,i) = [currRotA,currTransA];
    transformsB(:,:,i) = [currRotB,currTransB];
    
    % Calculate inverse transformation of B
    [invRotB,invTransB] = invTransformation(currRotB,currTransB);
    invTransformsB(:,:,i) = [invRotB,invTransB];
    
    % Position of pointer tip relative to rigid body B
    % d_k = (F_B,k)^(-1) * F_A,k * A_tip
    bodyToTip(:,i) = transform(invTransformsB(:,:,i),transform(transformsA(:,:,i),tipA));

    % Assume F_reg is Identity with zero translation
    F_reg = zeros(3,4);
    F_reg(1,1) = 1;
    F_reg(2,2) = 1;
    F_reg(3,3) = 1;
    
    % Assignment #3: Ignore comparison with mesh
    tipInCt(:,i) = transform(F_reg,bodyToTip(:,i));
end

% Write output to file
fileName = ['PA3-',run,'-Output.txt'];
fullFileName = ['../PA-3 Output/',fileName];
outputFile = fopen(fullFileName,'wt');
fprintf(outputFile,['%d ',fileName,'\n'],numSamples);

formatD = '%8.2f %8.2f %8.2f     '; % Format for bodyToTip
formatC = '%8.2f %8.2f %8.2f ';     % Format for tipInCt
formatDiff = '%9.3f\n';             % Format for magnitude difference

for i = 1:numSamples
    % Print bodyToTip coordinates
    fprintf(outputFile,formatD,bodyToTip(1,i),bodyToTip(2,i),bodyToTip(3,i));
    
    % Print c_k coordinates
    fprintf(outputFile,formatC,tipInCt(1,i),tipInCt(2,i),tipInCt(3,i));
    
    % Print magnitude of the difference (zero for PA3)
    fprintf(outputFile,formatDiff,norm(bodyToTip(:,i)-tipInCt(:,i)));
end

fclose('all');
