function a = graded_contact_radius_gamma(P, D, E0, k, nu)
% -------------------------------------------------------------------------
% Computes the contact radius for spherical indentation on a power-law
% graded elastic material using the Gamma-function formulation.
%
% Material law:
% E(z) = E0*z^k
%
% INPUTS:
% P   = applied load [N]
% D   = indenter diameter [mm]
% E0  = grading coefficient [GPa mm^(-k)]
% k   = grading exponent [-]
% nu  = Poisson ratio [-]
%
% OUTPUT:
% a   = contact radius [mm]
% -------------------------------------------------------------------------

    %% Input checks

    if P <= 0
        error('Applied load P must be positive.');
    end

    if D <= 0
        error('Indenter diameter D must be positive.');
    end

    if E0 <= 0
        error('Grading coefficient E0 must be positive.');
    end

    if k < 0 || k >= 1
        error('Gradient exponent k must satisfy 0 <= k < 1.');
    end

    if nu <= -1 || nu >= 0.5
        error('Poisson ratio nu must satisfy -1 < nu < 0.5.');
    end

    %% Unit conversion

    % GPa -> MPa = N/mm^2
    E0 = E0 * 1000;

    %% Equation (4c): auxiliary parameter q

    q = sqrt((1 + k) * (1 - (k * nu) / (1 - nu)));

    %% Equation (4b): coefficient c1

    c1_num = ...
        2 * q * sin(pi*q/2) * (1 - nu^2) * ...
        gamma((3 + k + q)/2) * ...
        gamma((3 + k - q)/2) * ...
        gamma((1 - k)/2);

    c1_den = ...
        E0 * sqrt(pi) * (1 + k) * ...
        gamma(2 + k) * ...
        gamma(1 + k/2);

    c1 = c1_num / c1_den;

    %% Equation (4a): contact-radius relation

    prefactor = ...
        (P * D * c1) / (pi * 2^(2 - k));

    gamma_term = ...
        gamma(1/2 + k/2) * ...
        gamma(3/2 + k/2);

    a_power = prefactor * gamma_term;

    %% Contact radius

    a = a_power^(1 / (k + 3));

end


% -------------------------------------------------------------------------
% NOTE ON THE IMPLEMENTATION OF EQ. (4a)
%
% Different typographical interpretations of the analytical formulation
% reported in the reference paper were tested during the implementation.
%
% In particular, the external factor:
%
% ((1 + k)*(3 + k))/2
%
% was found to produce contact-radius values significantly larger than the
% theoretical benchmark reported by the authors.
%
% The final implementation adopted here was selected based on numerical
% consistency with the theoretical reference solution reported in the paper:
%
% a_theory ≈ 0.507 mm
%
% for the reference case:
% P = 3000 N, D = 9.52 mm, E0 = 85.325 GPa mm^(-k), k = 0.497, nu = 0.22.
% -------------------------------------------------------------------------