%{
    Programming Assignment 4
    Main Script

    Kevin Yee & David West
    11/27/2015
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
run = 'B-Debug';
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

[R_reg,p_reg, c, s, triIndices] = icp(vertices,bodyToTip,adjacencies);
F_reg = [R_reg,p_reg];

%% Calculate m coordinates
lambda = ones(1,1,numModes-1)/(numModes-1);

% m_s will be mPoints(:,:,1)
% m_t will be mPoints(:,:,2)
% m_u will be mPoints(:,:,3)
mPoints = zeros(3,length(c),3);
count = 1;
for i = triIndices
    currAdj = adjacencies(:,i);
    
    sSum = zeros(3,1);
    tSum = sSum;
    uSum = sSum;
    for j = 1:(numModes-1)
        sSum = sSum + (mode0Vertices(:,currAdj(1))+displacements(:,currAdj(1),j))*lambda(j);
        tSum = tSum + (mode0Vertices(:,currAdj(2))+displacements(:,currAdj(2),j))*lambda(j);
        uSum = uSum + (mode0Vertices(:,currAdj(3))+displacements(:,currAdj(3),j))*lambda(j);
    end
    m_s = sSum+mode0Vertices(:,currAdj(1));
    m_t = tSum+mode0Vertices(:,currAdj(2));
    m_u = uSum+mode0Vertices(:,currAdj(3));
    mPoints(:,count,:) = [m_s,m_t,m_u];
    count = count + 1;
end



%% Convert to Barycentric coordinates

% Note triangulation and cartesiantoBarycentric
% both use input/output row vectors
% TR = triangulation([1,2,3],tri');
% baryProjPt = cartesianToBarycentric(TR,1,proj');


m_mesh = repmat(mode0Vertices,1,1,numModes)+cat(3, zeros(3,numVerticesModes,1), displacements);
q_m_k = zeros(3,length(c),numModes);
for m = 1:numModes
    k = 1;
    for i = triIndices
        currAdj = adjacencies(:,i);
        
        v1 = m_mesh(:,currAdj(1),m);
        v2 = m_mesh(:,currAdj(2),m);
        v3 = m_mesh(:,currAdj(3),m);
        
        TR = triangulation([1,2,3],[v1,v2,v3]');
        q_m_k(:,k,m) = cartesianToBarycentric(TR,1,c(:,k)')';
        k = k + 1;
    end
end


% compute weighted sum
%{
c_k = zeros(3,size(q_m_k,2));
for k = 1:size(q_m_k,2)
    c_k(:,k) = q_m_k(:,k,1) + sum(q_m_k(:,k,2:numModes).*repmat(lambda,3,1), 3);
end
c_k;
%}
%% Update weights
diff = s - q_m_k(:,:,1);

newQ = zeros(3*size(q_m_k,2),numModes-1);
for i = 1:numModes-1
    count = 1;
    for j = 1:size(q_m_k,2)
        for k = 1:3
            newQ(count,i) = q_m_k(k,j,i);
            count = count + 1;
        end
    end
end

newDiff = zeros(3*size(q_m_k,2),1);
count = 1;
for i = 1:size(q_m_k,2)
    for j = 1:3
        newDiff(count) = diff(j,i);
        count = count + 1;
    end
end

lambda = newDiff\newQ;

iter = 10;
diff = zeros(iter,1);
for i = 1:iter
    % Update Mesh
    m_mesh = updateMesh(m_mesh,lambda);
    
    % New S
    [R_reg,p_reg, c, s, triIndices] = icp(m_mesh,s,adjacencies);

    % Calculate new Q values
    m_mesh = repmat(m_mesh(:,:,1),1,1,numModes)+cat(3, zeros(3,numVerticesModes,1), displacements);
    
    q_m_k = meshToBary(m_mesh, adjacencies, triIndices, c);
    
    lambda = updateWeights(q_m_k, s, numModes);
    
    diff(i) = norm(c-s)
end

%% Write output to file
fileName = ['PA5-',run,'-Output.txt'];
fullFileName = ['../PA-5 Output/',fileName];
outputFile = fopen(fullFileName,'wt');
fprintf(outputFile,['%d ',fileName,'\n'],numSamples);

formatS = '%8.2f %8.2f %8.2f     '; % Format for bodyToTip
formatC = '%8.2f %8.2f %8.2f ';     % Format for tipInCt
formatDiff = '%9.3f\n';             % Format for magnitude difference

for i = 1:numSamples    
    % Print s_k coordinates
    fprintf(outputFile,formatS,s(1,i),s(2,i),s(3,i));
    
    % Print c_k coordinates
    fprintf(outputFile,formatC,c(1,i),c(2,i),c(3,i));
        
    % Print difference
    fprintf(outputFile,formatDiff,norm(s(:,i)-c(:,i)));
end

fclose('all');
