%% main_01_hertz_classic.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Compute the classical Hertzian contact response for homogeneous alumina
% indented by a spherical WC indenter.
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

P    = params.load.P;
R    = params.indenter.R;
E_i  = params.indenter.E;
nu_i = params.indenter.nu;
E_s  = params.homogeneous.E;
nu_s = params.homogeneous.nu;

a_exp = params.experimental.a_hom_exp;

%% 3. Classical Hertzian contact

results = hertz_classic(P, R, E_s, nu_s, E_i, nu_i);

E_star = results.E_star;
a      = results.a;
h      = results.h;
p0     = results.p0;
r      = results.r;
p_r    = results.p_r;

error_a = percent_error(a, a_exp);

%% 4. Display results

fprintf('\nCLASSICAL HERTZIAN CONTACT - HOMOGENEOUS ALUMINA\n');
fprintf('--------------------------------------------------\n');
fprintf('Applied load P              = %.0f N\n', P);
fprintf('Indenter radius R           = %.3f mm\n', R);
fprintf('Reduced modulus E*          = %.2f MPa\n', E_star);
fprintf('Contact radius a model      = %.4f mm\n', a);
fprintf('Contact radius a exp        = %.4f mm\n', a_exp);
fprintf('Error on a                  = %.2f %%\n', error_a);
fprintf('Indentation depth h         = %.6f mm\n', h);
fprintf('Maximum pressure p0         = %.2f MPa = %.2f GPa\n', p0, p0/1000);
fprintf('--------------------------------------------------\n\n');

%% 5. Save summary table

results_table = table(P, R, E_s, nu_s, E_i, nu_i, E_star, ...
    a, a_exp, error_a, h, p0, p0/1000, ...
    'VariableNames', {'P_N', 'R_mm', ...
    'E_sample_GPa', 'nu_sample', ...
    'E_indenter_GPa', 'nu_indenter', ...
    'E_star_MPa', 'a_model_mm', 'a_exp_mm', ...
    'error_a_percent', 'h_mm', 'p0_MPa', 'p0_GPa'});

writetable(results_table, tables_folder + "table_01_hertz_classic_results.csv");

%% 6. Save pressure distribution

pressure_table = table(r', p_r', p_r'/1000, ...
    'VariableNames', {'r_mm', 'pressure_MPa', 'pressure_GPa'});

writetable(pressure_table, data_folder + "data_01_hertz_pressure_distribution.csv");

%% 7. Plot pressure distribution

fig = figure('Color', 'w');
set(fig, 'Position', [100 100 950 600]);

plot(r, p_r/1000, 'LineWidth', 2.8);
hold on;

yline(p0/1000, '--', sprintf('p_0 = %.2f GPa', p0/1000), ...
    'LineWidth', 1.5, ...
    'LabelHorizontalAlignment', 'left', ...
    'LabelVerticalAlignment', 'bottom');

xline(a, '--', sprintf('a = %.4f mm', a), ...
    'LineWidth', 1.5, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

xlabel('Radial coordinate r [mm]');
ylabel('Contact pressure p(r) [GPa]');
title('Classical Hertzian Pressure Distribution - Homogeneous Alumina');

xlim([0, 1.05*a]);
ylim([0, 1.10*(p0/1000)]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

%% 8. Save figure

exportgraphics(fig, figures_folder + "fig_01_hertz_pressure.png", ...
    'Resolution', 300);

fprintf('Saved:\n');
fprintf('- fig_01_hertz_pressure.png\n');
fprintf('- table_01_hertz_classic_results.csv\n');
fprintf('- data_01_hertz_pressure_distribution.csv\n\n');