function lambda = updateWeights(q_m_k, s, numModes)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

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


diff = s - q_m_k(:,:,1);
newDiff = zeros(3*size(q_m_k,2),1);
count = 1;
for i = 1:size(q_m_k,2)
    for j = 1:3
        newDiff(count) = diff(j,i);
        count = count + 1;
    end
end

lambda = newDiff\newQ(:,2:numModes);
end

