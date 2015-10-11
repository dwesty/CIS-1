%{
CIS Programming Assignment 1
Part 2

Kevin Yee and David West

10 October 2015
%}


clear

calBody = fopen('pa1-debug-a-calbody.txt');

infoLine = fgetl(calBody);
scanner = textscan(infoLine,'%f%f%f%s','delimiter',',');
numBaseOpMarkers = scanner{1,1};
numOpMarkers = scanner{1,2};
numEmMarkers = scanner{1,3};

A = parseFile(calBody,numBaseOpMarkers);

calReadings = fopen('pa1-debug-a-calreadings.txt');
infoLine = fgetl(calReadings);
scanner = textscan(infoLine,'%f%f%f%f%s','delimiter',',');
numFrames = scanner{1,4};

B = parseFile(calReadings,numBaseOpMarkers);

sumActual = [0;0;0];
sumSensed = [0;0;0];
for i=1:numBaseOpMarkers
    sumActual(1) = sumActual(1) + A(i,1);
    sumActual(2) = sumActual(2) + A(i,2);
    sumActual(3) = sumActual(3) + A(i,3);
    
    sumSensed(1) = sumSensed(1) + B(i,1);
    sumSensed(2) = sumSensed(2) + B(i,2);
    sumSensed(3) = sumSensed(3) + B(i,3);
    
end

aVector = sumActual/numBaseOpMarkers;
bVector = sumSensed/numBaseOpMarkers;

adjustedA = zeros(3,numBaseOpMarkers)
adjustedB = zeros(3,numBaseOpMarkers)

for i=1:numBaseOpMarkers
    adjustedA(1,i) = aVector(1,1) - A(i,1);
    adjustedA(2,i) = aVector(2,1) - A(i,2);
    adjustedA(3,i) = aVector(3,1) - A(i,3);

    adjustedB(1,i) = bVector(1,1) - B(i,1);
    adjustedB(2,i) = bVector(2,1) - B(i,2);
    adjustedB(3,i) = bVector(3,1) - B(i,3);    
    
end

estimateR = zeros(3);
display(adjustedA);
display(adjustedB);

estimateR(:,1) = lsqnonneg(adjustedA',adjustedB(1,:)');
estimateR(:,2) = lsqnonneg(adjustedA',adjustedB(2,:)');
estimateR(:,3) = lsqnonneg(adjustedA',adjustedB(3,:)');

display(estimateR);

[regParams,Bfit,ErrorStats]=absor(A',B');


display(regParams.R);
display(regParams.t);





