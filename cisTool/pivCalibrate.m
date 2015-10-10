% Pivot calibration
% Assume some know vector F from tracker to marker
% R_i is rotational component of F (vector entry for each i)
% p_i is translational component of F (vector entry for each i)
% Solving for p_t, p_pivot, the vector from marker to tip
% Pivot calibration assumes this is fixed
function p_t = pivCalibrate(R_i, p_i)

% in progress... DW[
[p_t p_pivot] = pinv(R_i)*(p_i-t)

end