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

<<<<<<< HEAD
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

aVector = sumActual/numBaseOpMarkers
bVector = sumSensed/numBaseOpMarkers

adjustedA = zeros(3,numBaseOpMarkers);
adjustedB = zeros(3,numBaseOpMarkers);

for i=1:numBaseOpMarkers
    adjustedA(1,i) = aVector(1,1) - A(i,1);
    adjustedA(2,i) = aVector(2,1) - A(i,2);
    adjustedA(3,i) = aVector(3,1) - A(i,3);

    adjustedB(1,i) = bVector(1,1) - B(i,1);
    adjustedB(2,i) = bVector(2,1) - B(i,2);
    adjustedB(3,i) = bVector(3,1) - B(i,3);    
    
end

estimateR = zeros(3);
estimateR(:,1) = lsqnonneg(adjustedA',adjustedB(1,:)');
estimateR(:,2) = lsqnonneg(adjustedA',adjustedB(2,:)');
estimateR(:,3) = lsqnonneg(adjustedA',adjustedB(3,:)');

i = 0;
deltaR = zeros(3);

% Fixed number of iterations to test
% while i < 5
%     i = i + 1;
%     
%     %FIXME
%     newB = inv(estimateR)*adjustedB
%     x = lsqnonneg(adjustedA',newB(1,:)');
%     y = lsqnonneg(adjustedA',newB(2,:)');
%     z = lsqnonneg(adjustedA',newB(3,:)');
%     
%     
%     deltaR = [x,y,z]
%     
%     estimateR = estimateR*deltaR
%     det(estimateR)
% end


% Compare above with below
[regParams,Bfit,ErrorStats]=absor(A',B');

[R,p] = part2_function(A,B)



