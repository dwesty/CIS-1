% Number 4
% A - Computing frame
clear;

calBody = fopen('pa1-debug-a-calbody.txt');

infoLine = fgetl(calBody);
scanner = textscan(infoLine, '%f%f%f%s', 'delimiter', ',');
numBaseOpMarkers = scanner{1,1};
numOpMarkers = scanner{1,2};
numEmMarkers = scanner{1,3};

baseOpMarkers = parseFile(calBody, numBaseOpMarkers)
OpMarkers = parseFile(calBody, numOpMarkers)
EmMarkers = parseFile(calBody, numEmMarkers)

calReadings = fopen('pa1-debug-a-calreadings.txt');

infoLine2 = fgetl(calReadings);
scanner2 = textscan(infoLine2, '%f%f%f%s', 'delimiter', ',');
numBaseOpReadings = scanner2{1,1};
numOpReadings = scanner2{1,2};
numEmReadings = scanner2{1,3};

baseOpReadings = parseFile(calReadings, numBaseOpReadings)
OpReadings = parseFile(calReadings, numOpReadings)
EmReadings = parseFile(calReadings, numEmReadings)

%PART A

[R_d p_d] = part2_function(baseOpMarkers,baseOpReadings);

% FOR CHECKING
% [regParams,Bfit,ErrorStats] = absor(baseOpMarkers',baseOpReadings');
% R_d = regParams.R;
% t_d = regParams.t;
% F_d = [R_d, t_d];

%PART B
[R_a p_a] = part2_function(OpMarkers,OpReadings);

% FOR CHECKING
% [regParams,Bfit,ErrorStats] = absor(OpMarkers',OpReadings');
% R_a = regParams.R;
% t_a = regParams.t;
% F_a = [R_a, t_a]

fclose('all');

%PART D

C_est = zeros(numEmMarkers, 3);
for i = 1:numEmMarkers
    
    %Not sure this is right
    entry = R_a*EmReadings(i,:)'- inv(R_a)*p_a'
    C_est(i,:) = (inv(R_d) * entry - R_d*p_d')';
end
C_est

fclose('all');

