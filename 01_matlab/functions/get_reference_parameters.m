function params = get_reference_parameters()
% -------------------------------------------------------------------------
% FUNCTION:
% get_reference_parameters
%
% PURPOSE:
% Returns all reference parameters used in the Hertzian contact project
% for functionally graded ceramics based on:
%
% Jitcharoen et al.
% "Hertzian-Crack Suppression in Ceramics with
% Elastic-Modulus-Graded Surfaces"
% J. Am. Ceram. Soc. (1998)
%
% OUTPUT:
% params = structure containing:
%   - indenter properties
%   - homogeneous material properties
%   - graded material properties
%   - experimental reference values
%
% UNITS:
% Length  -> mm
% Force   -> N
% Stress  -> GPa
% -------------------------------------------------------------------------

    %% --------------------------------------------------------------------
    % INDENTER PROPERTIES (WC)
    % ---------------------------------------------------------------------

    params.indenter.material = 'WC';

    params.indenter.E  = 614;     % [GPa]
    params.indenter.nu = 0.22;    % [-]

    params.indenter.R = 4.76;     % [mm]
    params.indenter.D = 2 * params.indenter.R;

    %% --------------------------------------------------------------------
    % APPLIED LOAD
    % ---------------------------------------------------------------------

    params.load.P = 3000;         % [N]

    %% --------------------------------------------------------------------
    % HOMOGENEOUS ALUMINA
    % ---------------------------------------------------------------------

    params.homogeneous.material = 'Alumina';

    params.homogeneous.E  = 386;  % [GPa]
    params.homogeneous.nu = 0.22; % [-]

    %% --------------------------------------------------------------------
    % FUNCTIONALLY GRADED MATERIAL (S-FGM)
    % ---------------------------------------------------------------------

    % Real elastic profile:
    %
    % E(z) = Esurface + E0*z^k
    %
    % Used for physical interpretation and visualization.

    params.graded.E_surface = 254;       % [GPa]
    params.graded.E0        = 85.325;    % [GPa mm^(-k)]
    params.graded.k         = 0.497;     % [-]
    params.graded.nu        = 0.22;      % [-]

    %% --------------------------------------------------------------------
    % EXPERIMENTAL REFERENCE VALUES
    % ---------------------------------------------------------------------

    % Measured contact radius (paper)
    params.experimental.a_hom_exp = 0.3597;   % [mm]
    params.experimental.a_fgm_exp = 0.3895;   % [mm]

    %% --------------------------------------------------------------------
    % THEORETICAL REFERENCE VALUE
    % ---------------------------------------------------------------------

    % Analytical prediction reported in the paper
    % using the ideal power-law model:
    %
    % E(z) = E0*z^k

    params.theory.a_fgm_theory = 0.507;  % [mm]

end