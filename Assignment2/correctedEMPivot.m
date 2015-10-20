%assignment1Part3

filename = 'pa2-debug-a-empivot.txt';

emPivot = fopen(filename);
infoLine = fgetl(emPivot);
scanner = textscan(infoLine, '%f%f%s', 'delimiter', ',');
numEmMarkers = scanner{1,1};
numFrames = scanner{1,2};

% Get first frame data from file
G = parseFile(emPivot,numEmMarkers);


gMin = min(G);
gMax = max(G);

% Correct for distortion
G_corrected_scaled = correctDistortion(bezierCoeff, G);
G_corrected = unscaleFromBox(G_corrected_scaled,gMax,gMin)

% Calculate center of point set by averaging all points
sumG = [0,0,0];
for j=1:numEmMarkers
    sumG = sumG + G_corrected(j,:);
end
centroidG = sumG/numEmMarkers;

% Center each point to the center of the set
g_j = 0*G_corrected;
for j=1:numEmMarkers
    g_j(j,:) = G_corrected(j,:) - centroidG;
end

A = zeros(3*(numFrames-1),6);
b = zeros(3*(numFrames-1),1);
for i=1:(numFrames-1)
    
    % Get frame data from file
    G_corrected = parseFile(emPivot,numEmMarkers);
    
    % Calculate Fg with part 2
    [Fg_R,Fg_p] = part2_function(g_j,G_corrected);
        
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
