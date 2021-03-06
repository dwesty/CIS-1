%{
    Programming Assignment 5
    Main Script

    Kevin Yee & David West
    12/13/2015
    Computer Integrated Surgery I
%}
clear;

%% Input Data

% Input File Path
inputFilePath = '../PA-345 Student Data/';

% Modes File
modesFilePath = [inputFilePath,'Problem5Modes.txt'];
modesFile = fopen(modesFilePath);

% Get the number of modes and vertices from modes file
modesFileLine1 = textscan(fgetl(modesFile), '%s %f %s %f', 'delimiter', '=');
numVerticesModes= modesFileLine1{2}; % the number of vertices by the modes file
numModes = modesFileLine1{4};
textscan(fgetl(modesFile), '%s'); %scan through comment line
mode0Vertices = getCoordinates(modesFile, numVerticesModes);
displacements = getDisplacements(modesFile, numVerticesModes, numModes-1);
modes = cat(3, mode0Vertices, displacements);

% Mesh File
meshFilePath = [inputFilePath,'Problem5MeshFile.sur'];
meshFile = fopen(meshFilePath);

% Get triangle vertices
meshScanner = textscan(fgetl(meshFile),'%f');
numVertices = meshScanner{1,1};
vertices = getCoordinates(meshFile,numVertices);

% Check for consistency - should be close to 0
mode0Vertices-vertices;

% Get triangle adjacency indices
meshScanner = textscan(fgetl(meshFile),'%f');
numTriangles = meshScanner{1,1};
adjacencies = getTriangles(meshFile,numTriangles);

% "Un-zero" index everything
adjacencies = adjacencies + ones(size(adjacencies));

% Rigid Body Design File A
problemFilePathA = [inputFilePath,'Problem5-BodyA.txt'];
problemFileA = fopen(problemFilePathA);
aScanner = textscan(fgetl(problemFileA),'%f%s','delimiter',',');
numMarkersA = aScanner{1,1};
markersA = getCoordinates(problemFileA,numMarkersA); %A
tipA = getCoordinates(problemFileA,1);

% Rigid Body Design File B
problemFilePathB = [inputFilePath,'Problem5-BodyB.txt'];
problemFileB = fopen(problemFilePathB);
bScanner = textscan(fgetl(problemFileB),'%f%s','delimiter',',');
numMarkersB = bScanner{1,1};
markersB = getCoordinates(problemFileB,numMarkersB); %B
tipB = getCoordinates(problemFileB,1);

% Sample Readings File
run = 'K-Unknown';
sampleFilePath = [inputFilePath,'PA5-',run,'-SampleReadingsTest.txt'];
sampleFile = fopen(sampleFilePath);
sampleScanner = textscan(fgetl(sampleFile),'%f%f%s','delimiter',',');
numTotalLeds = sampleScanner{1,1};
numSamples = sampleScanner{1,2};

% Dummy Markers are all remaining after A and B
numDummy = numTotalLeds - numMarkersA - numMarkersB;

%% Initialize Frame Variables
% Some of these may not need to be saved

aMarkersTracker = zeros(3,numMarkersA,numSamples); %a_i,k
bMarkersTracker = zeros(3,numMarkersB,numSamples); %b_i,k
dummyMarkersTracker = zeros(3,numDummy,numSamples);
transformsA = zeros(3,4,numSamples);    % F_A,k
transformsB = transformsA;              % F_B,k
invTransformsB = transformsB;           % Inverse of B
bodyToTip = zeros(3,numSamples);        % d_k
tipInCt = bodyToTip;                    % c_k

%% Loop Through Frames to calculate F_reg
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
end


%% Main Loop

s = bodyToTip;          % d_k
currVerts = vertices;
% modeMeshes = repmat(mode0Vertices,1,1,numModes)+cat(3, zeros(3,numVerticesModes,1), displacements);
% modeMeshes = cat(3, mode0Vertices, displacements);
for i = 1:5
    % ICP
    [R_reg,p_reg, c, s, triIndices] = icp(currVerts,bodyToTip,adjacencies);
    
    % Deform Mesh
    [currVerts, c, lambda] = deformMesh(currVerts, adjacencies, triIndices, modes, c, s);
end

F_reg = [R_reg,p_reg];

%% Write output to file
fileName = ['PA5-',run,'-Output.txt'];
fullFileName = ['../PA-5 Output/',fileName];
outputFile = fopen(fullFileName,'wt');
fprintf(outputFile,['%d ',fileName,' %d\n'],numSamples, numModes);

formatLambda = '%10.4f';% Format for lambda
formatS = '%8.2f %8.2f %8.2f     ';     % Format for s
formatC = '%8.2f %8.2f %8.2f ';         % Format for c
formatDiff = '%9.3f\n';                 % Format for magnitude difference

for i = 1:(numModes-1)
    fprintf(outputFile,formatLambda,lambda(i));
end

fprintf(outputFile,'\n');

for i = 1:numSamples    
    % Print s_k coordinates
    fprintf(outputFile,formatS,s(1,i),s(2,i),s(3,i));
    
    % Print c_k coordinates
    fprintf(outputFile,formatC,c(1,i),c(2,i),c(3,i));
        
    % Print difference
    fprintf(outputFile,formatDiff,norm(s(:,i)-c(:,i)));
end

fclose('all');
