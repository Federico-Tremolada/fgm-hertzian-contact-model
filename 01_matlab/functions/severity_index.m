function S = severity_index(p0_fgm, p0_hom)
% -------------------------------------------------------------------------
% FUNCTION:
% severity_index
%
% PURPOSE:
% Computes the contact severity index between graded and homogeneous cases.
%
% INPUTS:
% p0_fgm = maximum contact pressure in graded material [MPa]
% p0_hom = maximum contact pressure in homogeneous material [MPa]
%
% OUTPUT:
% S = p0_fgm / p0_hom [-]
% -------------------------------------------------------------------------

    if p0_hom <= 0
        error('Reference homogeneous pressure must be positive.');
    end

    S = p0_fgm / p0_hom;

end