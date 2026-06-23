function err = percent_error(value, reference)
% -------------------------------------------------------------------------
% FUNCTION:
% percent_error
%
% PURPOSE:
% Computes percentage error between a computed value and a reference value.
%
% INPUTS:
% value      = computed value
% reference  = reference/experimental value
%
% OUTPUT:
% err = percentage error [%]
% -------------------------------------------------------------------------

    err = abs((value - reference) / reference) * 100;

end