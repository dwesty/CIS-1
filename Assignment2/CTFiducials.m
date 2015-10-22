% Assignment 2 - Part 4
% Find CT fiducials

% Define dataset used
letter = 'a';

% Calculate Bezier Coefficient for this dataset
bezierCoeff = calculateBezierCoeff(letter);

% Open pivot file and parse first line of information
filename = ['pa2-debug-', letter, '-empivot.txt'];
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

% Take in EM Fiducial Data
filename = ['pa2-debug-', letter, '-em-fiducialss.txt'];
emMarkers = fopen(filename);
infoLine = fgetl(emMarkers);
scanner = textscan(infoLine, '%f%f%s', 'delimiter', ',');
numEmMarkers= scanner{1,1};
numEmFrames = scanner{1,2};

% initialize matrices
emFid = zeros(numEmMarkers,3,numEmFrames);
correctedEmFid = zeros(numEmMarkers,3,numEmFrames);
emFidLocations = zeros(numEmFrames,3);

for frame = 1:numEmFrames
    
    % Read EM fiducial frame into matrix
    emFid(:,:,frame) = parseFile(emMarkers,numEmMarkers);
    
    % Correct this frame for distortion
    correctedEmFid(:,:,frame) = correctDistortion(bezierCoeff, emFid(:,:,frame));
    
    %[Fg_R, Fg_p] = part2_function(g_j,correctedEmFid(:,:,frame))
    [regParams,Bfit,ErrorStats] = absor(correctedEmFid(:,:,frame)',g_j');
    Fg_R = regParams.R;
    Fg_p = regParams.t;
    
    emFidLocations(frame,:) = (Fg_R*t_G + Fg_p)'; % Capital B's
    
end

% Take in CT Fiducial Data
filename = ['pa2-debug-', letter, '-ct-fiducials.txt'];
ctMarkers = fopen(filename);
infoLine = fgetl(ctMarkers);
scanner = textscan(infoLine, '%f%f%s', 'delimiter', ',');
numCtMarkers= scanner{1,1};

ctFidLocation = parseFile(ctMarkers,numCtMarkers); % Lower case b's


%[F_reg_R,F_reg_p] = part2_function(emFidLocations,ctFidLocation);
[regParams,Bfit,ErrorStats] = absor(ctFidLocation',emFidLocations');
F_reg_R = regParams.R
F_reg_p = regParams.t

% Take in Nav Data
filename = ['pa2-debug-', letter, '-EM-nav.txt'];
emNav = fopen(filename);
infoLine = fgetl(emNav);
scanner = textscan(infoLine, '%f%f%s', 'delimiter', ',');
numEmNavMarkers= scanner{1,1};
numEmNavFrames = scanner{1,2};

% Assignment 2 Part 6
emNavPositions = zeros(numEmNavMarkers,3,numEmNavFrames);
correctedEmNavPositions = zeros(numEmNavMarkers,3,numEmNavFrames);
ctNavPositions = zeros(numEmNavFrames,3);
for frame = 1:numEmNavFrames
    
    % Read EM nav values into matrix
    emNavPositions(:,:,frame) = parseFile(emNav,numEmNavMarkers);
    
    correctedEmNavPositions(:,:,frame) = correctDistortion(bezierCoeff,emNavPositions(:,:,frame));
    
    [regParams,Bfit,ErrorStats] = absor(correctedEmNavPositions(:,:,frame)',g_j');
    Fg_R = regParams.R
    Fg_p = regParams.t
    
    ctNavPositions(frame,:) = (Fg_R*t_G + Fg_p)';
    
end

ctNavPositions




