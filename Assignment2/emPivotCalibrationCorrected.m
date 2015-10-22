%{
    CIS Programming Assignment 1
    Part 5: EM Pivot Calibration

    Kevin Yee and David West
%}

function [t_G p_dimple,g_j] = emPivotCalibrationCorrected(letter,bezierCoeff)
% Input parameter must be file name only (not including file path)


% Open file and parse first line of information
filename = ['pa2-debug-',letter,'-empivot.txt'];
emPivot = fopen(filename);
infoLine = fgetl(emPivot);
scanner = textscan(infoLine, '%f%f%s', 'delimiter', ',');
numEmMarkers = scanner{1,1};
numFrames = scanner{1,2};

% Get first frame data from file
G = parseFile(emPivot,numEmMarkers);

correctedG = correctDistortion(bezierCoeff,G);

% Calculate center of point set by averaging all points
sumG = [0,0,0];
for j=1:numEmMarkers
    sumG = sumG + correctedG(j,:);
end
centroidG = sumG/numEmMarkers;

% Center each point to the center of the set
g_j = 0*G;
for j=1:numEmMarkers
    g_j(j,:) = correctedG(j,:) - centroidG;
end

A = zeros(3*(numFrames-1),6);
b = zeros(3*(numFrames-1),1);
for i=1:(numFrames-1)
    
    % Get frame data from file
    G = parseFile(emPivot,numEmMarkers);
    correctedG = correctDistortion(bezierCoeff,G);
    
    % Calculate Fg with part 2
    %[Fg_R,Fg_p] = part2_function(g_j,correctedG);
    [regParams,Bfit,ErrorStats] = absor(g_j',correctedG');
    Fg_R = regParams.R;
    Fg_p = regParams.t;
    
    % Create data matrix for least squares
    index = 3*i-2;
    A(index  ,:) = [Fg_R(1,:),-1,0,0];
    A(index+1,:) = [Fg_R(2,:),0,-1,0];
    A(index+2,:) = [Fg_R(3,:),0,0,-1];
    
    % Create vector of translations for least squares
    b(index  ) = Fg_p(1);
    b(index+1) = Fg_p(2);
    b(index+2) = Fg_p(3);
   
end

% Solve Ax = b by least squares
x = A\(-b);

% Extract relative tip location and post location from x
t_G = [x(1);x(2);x(3)]
p_dimple = [x(4);x(5);x(6)]

fclose('all');


end



