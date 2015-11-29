function [invR,invP] = invTransformation(R,p)
%Calculate the inverse of a transformation
%based on the algorithm described in the slides
    invR = inv(R);
    invP = -invR*p;
end

