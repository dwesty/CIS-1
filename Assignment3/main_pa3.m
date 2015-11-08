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

% Rigid Body Design File A
problemFilePathA = [inputFilePath,'Problem3-BodyA.txt'];
problemFileA = fopen(problemFilePathA);
aScanner = textscan(fgetl(problemFileA),'%f%s','delimiter',',');
numMarkersA = aScanner{1,1};
markersA = getCoordinates(problemFileA,numMarkersA);
tipA = getCoordinates(problemFileA,1);

% Rigid Body Design File B
problemFilePathB = [inputFilePath,'Problem3-BodyB.txt'];
problemFileB = fopen(problemFilePathB);
bScanner = textscan(fgetl(problemFileB),'%f%s','delimiter',',');
numMarkersB = bScanner{1,1};
markersB = getCoordinates(problemFileB,numMarkersB);
tipB = getCoordinates(problemFileB,1);

% Mesh File
% FIXME: Read in .sur file
meshFilePath = 'Problem3Mesh.txt';
%meshFilePath = [inputFilePath,'Problem3Mesh.sur'];
meshFile = fopen(meshFilePath);

meshScanner = textscan(fgetl(meshFile),'%f');
numVertices = meshScanner{1,1};
vertices = getCoordinates(meshFile,numVertices);

% Get triangle adjacency indices
meshScanner = textscan(fgetl(meshFile),'%f');
numTriangles = meshScanner{1,1};
adjacencies = getTriangles(meshFile,numTriangles);

% Sample Readings File
run = 'A-Debug';
sampleFilePath = [inputFilePath,'PA3-',run,'-SampleReadingsTest.txt'];
sampleFile = fopen(sampleFilePath);
sampleScanner = textscan(fgetl(sampleFile),'%f%f%s','delimiter',',');
numTotalLeds = sampleScanner{1,1};
numSamples = sampleScanner{1,2};

% Dummy Markers are all remaining after A and B
numDummy = numTotalLeds - numMarkersA - numMarkersB;

aMarkersTracker = zeros(3,numMarkersA,numSamples);
bMarkersTracker = zeros(3,numMarkersB,numSamples);
dummyMarkersTracker = zeros(3,numDummy,numSamples);
for i = 1:numSamples
    aMarkersTracker(:,:,i) = getCoordinates(sampleFile,numMarkersA);
    bMarkersTracker(:,:,i) = getCoordinates(sampleFile,numMarkersB);
    dummyMarkersTracker(:,:,i) = getCoordinates(sampleFile,numDummy);
end

fclose('all');
