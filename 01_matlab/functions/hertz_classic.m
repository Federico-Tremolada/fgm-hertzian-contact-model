function results = hertz_classic(P, R, E_s, nu_s, E_i, nu_i)
% -------------------------------------------------------------------------
% FUNCTION:
% hertz_classic
%
% PURPOSE:
% Computes the classical Hertzian contact solution for spherical
% indentation between a homogeneous elastic sample and a spherical
% elastic indenter.
%
% INPUTS:
% P     = applied load [N]
% R     = indenter radius [mm]
% E_s   = sample Young's modulus [GPa]
% nu_s  = sample Poisson ratio [-]
% E_i   = indenter Young's modulus [GPa]
% nu_i  = indenter Poisson ratio [-]
%
% OUTPUT:
% results structure containing:
%   E_star = reduced modulus [MPa]
%   a      = contact radius [mm]
%   h      = indentation depth [mm]
%   p0     = maximum pressure [MPa]
%   r      = radial coordinate [mm]
%   p_r    = pressure distribution [MPa]
%
% THEORY:
% Classical Hertz contact theory for isotropic linear elastic materials.
% -------------------------------------------------------------------------

    %% Input checks

    if P <= 0
        error('Applied load P must be positive.');
    end

    if R <= 0
        error('Indenter radius R must be positive.');
    end

    %% Convert moduli from GPa to MPa

    E_s = E_s * 1000;
    E_i = E_i * 1000;

    %% Reduced modulus

    E_star = 1 / ...
        ( ((1 - nu_s^2) / E_s) + ((1 - nu_i^2) / E_i) );

    %% Contact radius

    a = ((3 * P * R) / (4 * E_star))^(1/3);

    %% Indentation depth

    h = a^2 / R;

    %% Maximum contact pressure

    p0 = (3 * P) / (2 * pi * a^2);

    %% Radial coordinate

    r = linspace(0, a, 400);

    %% Hertz pressure distribution

    p_r = p0 .* sqrt(1 - (r ./ a).^2);

    %% Output structure

    results.E_star = E_star;
    results.a      = a;
    results.h      = h;
    results.p0     = p0;
    results.r      = r;
    results.p_r    = p_r;

end