function qScaled = scaleToBox(q)

qSize = size(q);
qMin = min(q);
qMax = max(q);

qScaled = zeros(qSize);

for i = 1:qSize(1)
   qScaled(i,:) = (q(i,:)-qMin)./(qMax-qMin);
end

end