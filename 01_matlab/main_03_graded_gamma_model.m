%% main_03_graded_gamma_model.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Compute the contact response of the power-law graded material using the
% analytical Gamma-function formulation.
%
% Analytical material law:
% E(z) = E0*z^k
%
% This is the ideal model used to obtain the closed-form contact solution.
% -------------------------------------------------------------------------

clear; clc; close all;

addpath("functions");

%% 1. Output folders

figures_folder = "../02_results/figures/";
tables_folder  = "../02_results/tables/";
data_folder    = "../02_results/data/";

if ~exist(figures_folder, 'dir'); mkdir(figures_folder); end
if ~exist(tables_folder,  'dir'); mkdir(tables_folder);  end
if ~exist(data_folder,    'dir'); mkdir(data_folder);    end

%% 2. Reference parameters

params = get_reference_parameters();

P  = params.load.P;
D  = params.indenter.D;
R  = params.indenter.R;

E0 = params.graded.E0;
k  = params.graded.k;
nu = params.graded.nu;

a_exp    = params.experimental.a_fgm_exp;
a_theory = params.theory.a_fgm_theory;

%% 3. Gamma model contact radius

a_fgm = graded_contact_radius_gamma(P, D, E0, k, nu);

%% 4. Contact quantities from radius

fgm_results = graded_contact_from_radius(P, D, k, a_fgm);

h_fgm   = fgm_results.h;
p0_fgm  = fgm_results.p0;
r_fgm   = fgm_results.r;
p_r_fgm = fgm_results.p_r;

%% 5. Error evaluation

error_vs_exp    = percent_error(a_fgm, a_exp);
error_vs_theory = percent_error(a_fgm, a_theory);

%% 6. Display results

fprintf('\nGRADED CONTACT MODEL - GAMMA FORMULATION\n');
fprintf('--------------------------------------------------\n');
fprintf('Applied load P                  = %.0f N\n', P);
fprintf('Indenter diameter D             = %.3f mm\n', D);
fprintf('Grading coefficient E0          = %.3f GPa mm^(-k)\n', E0);
fprintf('Gradient exponent k             = %.3f\n', k);
fprintf('Poisson ratio nu                = %.3f\n', nu);
fprintf('Contact radius a model          = %.4f mm\n', a_fgm);
fprintf('Contact radius a exp            = %.4f mm\n', a_exp);
fprintf('Contact radius a theory paper   = %.4f mm\n', a_theory);
fprintf('Error vs exp                    = %.2f %%\n', error_vs_exp);
fprintf('Error vs theory paper           = %.2f %%\n', error_vs_theory);
fprintf('Indentation depth h             = %.6f mm\n', h_fgm);
fprintf('Maximum pressure p0             = %.2f MPa = %.2f GPa\n', ...
    p0_fgm, p0_fgm/1000);
fprintf('--------------------------------------------------\n\n');

%% 7. Save summary table

summary_table = table(P, D, R, E0, k, nu, ...
    a_fgm, a_exp, a_theory, error_vs_exp, error_vs_theory, ...
    h_fgm, p0_fgm, p0_fgm/1000, ...
    'VariableNames', {'P_N', 'D_mm', 'R_mm', ...
    'E0_GPa_mm_minus_k', 'k', 'nu', ...
    'a_model_mm', 'a_exp_mm', 'a_theory_paper_mm', ...
    'error_vs_exp_percent', 'error_vs_theory_percent', ...
    'h_mm', 'p0_MPa', 'p0_GPa'});

writetable(summary_table, ...
    tables_folder + "table_03_graded_gamma_model_results.csv");

%% 8. Save pressure distribution

pressure_table = table(r_fgm', p_r_fgm', p_r_fgm'/1000, ...
    'VariableNames', {'r_mm', 'pressure_MPa', 'pressure_GPa'});

writetable(pressure_table, ...
    data_folder + "data_03_graded_gamma_pressure_distribution.csv");

%% 9. Plot pressure distribution

fig = figure('Color', 'w');
set(fig, 'Position', [100 100 950 600]);

plot(r_fgm, p_r_fgm/1000, 'LineWidth', 3);
hold on;

yline(p0_fgm/1000, '--', ...
    sprintf('p_0 = %.2f GPa', p0_fgm/1000), ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left', ...
    'LabelVerticalAlignment', 'bottom');

xline(a_fgm, '--', ...
    sprintf('a = %.4f mm', a_fgm), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

xlabel('Radial coordinate r [mm]');
ylabel('Contact pressure p(r) [GPa]');
title('Pressure Distribution - Power-Law Graded Gamma Model');

xlim([0, 1.05*a_fgm]);
ylim([0, 1.10*(p0_fgm/1000)]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig, ...
    figures_folder + "fig_03_graded_gamma_pressure.png", ...
    'Resolution', 300);

%% 10. Final message

fprintf('Saved:\n');
fprintf('- fig_03_graded_gamma_pressure.png\n');
fprintf('- table_03_graded_gamma_model_results.csv\n');
fprintf('- data_03_graded_gamma_pressure_distribution.csv\n\n');