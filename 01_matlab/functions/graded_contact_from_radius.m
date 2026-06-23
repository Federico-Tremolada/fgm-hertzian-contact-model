function results = graded_contact_from_radius(P, D, k, a)
% -------------------------------------------------------------------------
% FUNCTION:
% graded_contact_from_radius
%
% PURPOSE:
% Computes indentation depth, maximum contact pressure and pressure
% distribution for spherical indentation on a power-law graded material,
% once the contact radius is known.
%
% Analytical model:
% E(z) = E0 * z^k
%
% INPUTS:
% P = applied load [N]
% D = indenter diameter [mm]
% k = grading exponent [-]
% a = contact radius [mm]
%
% OUTPUT:
% results.a    = contact radius [mm]
% results.h    = indentation depth [mm]
% results.p0   = maximum contact pressure [MPa]
% results.r    = radial coordinate [mm]
% results.p_r  = pressure distribution [MPa]
%
% NOTES:
% The pressure distribution follows the analytical expression used for
% power-law graded elastic materials.
% -------------------------------------------------------------------------

    % Input checks
    if P <= 0
        error('Applied load P must be positive.');
    end

    if D <= 0
        error('Indenter diameter D must be positive.');
    end

    if k < 0 || k >= 1
        error('Gradient exponent k must satisfy 0 <= k < 1.');
    end

    if a <= 0
        error('Contact radius a must be positive.');
    end

    % Indentation depth
    h = (2 * a^2) / (D * (k + 1));

    % Maximum contact pressure at r = 0
    % Units: N/mm^2 = MPa
    p0 = ((3 + k) * P) / (2 * pi * a^2);

    % Radial coordinate
    r = linspace(0, a, 400);

    % Pressure distribution
    p_r = p0 .* (1 - (r ./ a).^2).^((1 + k)/2);

    % Output structure
    results.a = a;
    results.h = h;
    results.p0 = p0;
    results.r = r;
    results.p_r = p_r;

end