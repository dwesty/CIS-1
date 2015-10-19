function qUnscaled = unscaleFromBox(qScaled, max, min)

qSize = length(qScaled);
qUnscaled = zeros(qSize,3);

for i = 1:3
    for j = 1:qSize  
        qUnscaled(j,i) =  qScaled(j,i)*(max(i)-min(i)) + min(i);
    end
end

end

