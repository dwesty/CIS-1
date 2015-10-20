% Assignment 2 - Part 4
% Find CT fiducials

% Take in EM Fiducial Data
filename = 'pa2-debug-a-em-fiducialss.txt';
emMarkers = fopen(filename);
infoLine = fgetl(emMarkers);
scanner = textscan(infoLine, '%f%f%s', 'delimiter', ',');
numEmMarkers= scanner{1,1};
numEmFrames = scanner{1,2};

% Read EM Fiducial Data into matrix
emFid = zeros(numEmMarkers,3,numEmFrames);
for frame = 1:numEmFrames
   emFid(:,:,frame) = parseFile(emMarkers,numEmMarkers);
end

% cMin = min(C);
% cMax = max(C);
% 
% % Correct C for distortion
% C_Corrected_scaled = correctDistortion(bezierCoeff, q);
% G_corrected = unscaleFromBox(G_corrected_scaled,gMax,gMin)
