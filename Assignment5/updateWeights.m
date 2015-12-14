function lambda = updateWeights(q_m_k, s, numModes)
% Update the weights (lambda) of each mode based on the mode values 
% q_m_k: the mode values calculated in the previous function
%        (size = 3 x numVerts x numModes
% s: set of points close to the mesh returned by icp (size = 3 x k)
% numModes: number of modes


% Resize the mode values so that size = (3 * k) x numModes
% where the x, y and z values for each k alternate in each mode's column
% This is necessary to solve the least squares problem
newQ = zeros(3*size(q_m_k,2),numModes);
for i = 1:numModes
    count = 1;
    for j = 1:size(q_m_k,2)
        for k = 1:3
            newQ(count,i) = q_m_k(k,j,i);
            count = count + 1;
        end
    end
end

% Resize the difference matrix so that size = (3 * k) x 1
% where the x, y and z values alternate for each k
% This is necessary to solve the least squares problem
diff = s - q_m_k(:,:,1);
newDiff = zeros(3*size(q_m_k,2),1);
count = 1;
for i = 1:size(q_m_k,2)
    for j = 1:3
        newDiff(count) = diff(j,i);
        count = count + 1;
    end
end

% Solve the least squares problem
lambda = newDiff\newQ(:,2:numModes);
% lambda = newQ(:,2:numModes)\newDiff  % TO CHECK

end

