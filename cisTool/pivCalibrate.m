% Pivot calibration
% Assume some know vector F from tracker to marker
% R is rotational component of F
% p is translational component of F
% Solving for p_tip, the vector from marker to tip
% Pivot calibration assumes this is fixed
function p_tip = pivCalibrate(R, p)

% in progress... DW
p_tip = inv(R)*(p-t)

end