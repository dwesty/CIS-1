%{
    CIS Programming Assignment 1
    Part 5: Optical Pivot Calibration

    Kevin Yee and David West
%}

clear

% Open file and parse first line of information
fileName = 'pa1-debug-b-optpivot.txt';
optPivot = fopen(fileName);
infoLine = fgetl(optPivot);
scanner = textscan(infoLine, '%f%f%f%s', 'delimiter', ',');
numBaseOpMarkers = scanner{1,1};
numProbeOpMarkers = scanner{1,2};
numFrames = scanner{1,3};

% Get all frame data from file 
entireD = [];
entireH = [];
for i=1:numFrames
    entireD = [entireD;parseFile(optPivot,numBaseOpMarkers)];
    entireH = [entireH;parseFile(optPivot,numProbeOpMarkers)];
end

% Find first D frame to calculate Fd
firstDframe = zeros(numBaseOpMarkers,3);
for i=1:numBaseOpMarkers
    firstDframe(i,:) = entireD(i,:);
end

% Get d vectors from other file
fileName = 'pa1-debug-b-calbody.txt';
calBody = fopen(fileName);
infoLine = fgetl(calBody);
% Nothing needs to be used from this information line
dCoordinates = parseFile(calBody,numBaseOpMarkers);

% FIXME: Should use part 2 instead of absor
% Calculate Fd using first D frame and d vectors using part 2
[regParams,Bfit,ErrorStats]=absor(dCoordinates',firstDframe');
Fd_R = regParams.R;
Fd_p = regParams.t;

% Confirm Fd transformation is correct
%theoreticalD = regParams.R*dCoordinates(numBaseOpMarkers,:)' + regParams.t
%actualD = firstDframe(numBaseOpMarkers,:)'

% Calculate inverse Fd and apply to all H's
[invFd_R,invFd_p] = invTransformation(Fd_R,Fd_p);
transH = 0*entireH;
for i=1:numProbeOpMarkers*numFrames
    transH(i,:) = invFd_R*entireH(i,:)' + invFd_p;
end

% Find first transformed H frame 
firstHframe = zeros(numProbeOpMarkers,3);
for i=1:numProbeOpMarkers
    firstHframe(i,:) = transH(i,:);
end

% Calculate center of point set by averaging all points
sumHframe1 = [0,0,0];
for j=1:numProbeOpMarkers
    sumHframe1 = sumHframe1 + firstHframe(j,:);
end
centroidH = sumHframe1/numProbeOpMarkers;

% Center each point to the center of the set
h_j = 0*firstHframe;
for j=1:numProbeOpMarkers
    h_j(j,:) = firstHframe(j,:) - centroidH;
end


A = zeros(3*(numFrames-1),6);
b = zeros(3*(numFrames-1),1);
for i=1:(numFrames-1)
    
    % Get the current frame transformed H values from entireH
    currentH = zeros(numProbeOpMarkers,3);
    for j=1:numProbeOpMarkers
        currentH(j,:) = transH(i*numProbeOpMarkers+j,:);
    end
    
    % FIXME: Should use part 2 instead of absor
    %[Fg_R,Fg_p] = part2_function(g_j1,g_j2)
    [regParams,Bfit,ErrorStats]=absor(h_j',currentH');
    
    Fh_R = regParams.R;
    Fh_p = regParams.t;

    % Confirm that tranformation is correct
    %theoretical = regParams.R*h_j(1,:)' + regParams.t
    %actual = currentH(1,:)'
        
    % Create data matrix for least squares
    index = 3*i-2;
    A(index  ,:) = [Fh_R(1,:),-1,0,0];
    A(index+1,:) = [Fh_R(2,:),0,-1,0];
    A(index+2,:) = [Fh_R(3,:),0,0,-1];
    
    % Create vector of translations for least squares
    b(index  ) = Fh_p(1);
    b(index+1) = Fh_p(2);
    b(index+2) = Fh_p(3);
   
end

% Solve Ax = b by least squares
x = A\(-b);

% Extract relative tip location and post location from x
t_G = [x(1);x(2);x(3)]
p_dimple = [x(4);x(5);x(6)]

fclose('all');



