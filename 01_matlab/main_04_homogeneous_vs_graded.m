%% main_04_homogeneous_vs_graded.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Direct comparison between classical Hertzian contact on homogeneous
% alumina and Gamma-model contact on the power-law graded material.
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

P = params.load.P;

R = params.indenter.R;
D = params.indenter.D;

E_i  = params.indenter.E;
nu_i = params.indenter.nu;

E_s  = params.homogeneous.E;
nu_s = params.homogeneous.nu;

E0 = params.graded.E0;
k  = params.graded.k;
nu = params.graded.nu;

%% 3. Homogeneous Hertzian solution

hom = hertz_classic(P, R, E_s, nu_s, E_i, nu_i);

a_hom  = hom.a;
h_hom  = hom.h;
p0_hom = hom.p0;

%% 4. Graded Gamma solution

a_fgm = graded_contact_radius_gamma(P, D, E0, k, nu);
fgm   = graded_contact_from_radius(P, D, k, a_fgm);

h_fgm  = fgm.h;
p0_fgm = fgm.p0;

%% 5. Severity index and relative variations

S = severity_index(p0_fgm, p0_hom);

delta_a_percent  = ((a_fgm  - a_hom)  / a_hom)  * 100;
delta_h_percent  = ((h_fgm  - h_hom)  / h_hom)  * 100;
delta_p0_percent = ((p0_fgm - p0_hom) / p0_hom) * 100;

%% 6. Display results

fprintf('\nHOMOGENEOUS VS GRADED CONTACT COMPARISON\n');
fprintf('--------------------------------------------------\n');
fprintf('Contact radius - homogeneous       = %.4f mm\n', a_hom);
fprintf('Contact radius - graded            = %.4f mm\n', a_fgm);
fprintf('Delta contact radius               = %.2f %%\n', delta_a_percent);
fprintf('\n');
fprintf('Indentation depth - homogeneous    = %.6f mm\n', h_hom);
fprintf('Indentation depth - graded         = %.6f mm\n', h_fgm);
fprintf('Delta indentation depth            = %.2f %%\n', delta_h_percent);
fprintf('\n');
fprintf('Maximum pressure - homogeneous     = %.2f MPa = %.2f GPa\n', p0_hom, p0_hom/1000);
fprintf('Maximum pressure - graded          = %.2f MPa = %.2f GPa\n', p0_fgm, p0_fgm/1000);
fprintf('Delta maximum pressure             = %.2f %%\n', delta_p0_percent);
fprintf('\n');
fprintf('Severity index S = p0_FGM / p0_HOM = %.3f\n', S);
fprintf('--------------------------------------------------\n\n');

%% 7. Save summary table

summary_table = table( ...
    a_hom, a_fgm, delta_a_percent, ...
    h_hom, h_fgm, delta_h_percent, ...
    p0_hom, p0_fgm, p0_hom/1000, p0_fgm/1000, ...
    delta_p0_percent, S, ...
    'VariableNames', {'a_hom_mm', 'a_fgm_mm', 'delta_a_percent', ...
                      'h_hom_mm', 'h_fgm_mm', 'delta_h_percent', ...
                      'p0_hom_MPa', 'p0_fgm_MPa', ...
                      'p0_hom_GPa', 'p0_fgm_GPa', ...
                      'delta_p0_percent', 'severity_index'});

writetable(summary_table, ...
    tables_folder + "table_04_homogeneous_vs_graded.csv");

%% 8. Save pressure distributions on normalized radial coordinate

rho = linspace(0, 1, 500);

p_hom_norm = p0_hom .* sqrt(1 - rho.^2);
p_fgm_norm = p0_fgm .* (1 - rho.^2).^((1 + k)/2);

pressure_table = table(rho', p_hom_norm', p_fgm_norm', ...
    p_hom_norm'/1000, p_fgm_norm'/1000, ...
    'VariableNames', {'rho_r_over_a', ...
                      'pressure_hom_MPa', 'pressure_fgm_MPa', ...
                      'pressure_hom_GPa', 'pressure_fgm_GPa'});

writetable(pressure_table, ...
    data_folder + "data_04_pressure_comparison_normalized.csv");

%% 9. Plot pressure comparison on normalized coordinate

fig = figure('Color', 'w');
set(fig, 'Position', [100 100 1000 620]);

plot(rho, p_hom_norm/1000, 'LineWidth', 3);
hold on;
plot(rho, p_fgm_norm/1000, 'LineWidth', 3);

xlabel('Normalized radial coordinate r/a [-]');
ylabel('Contact pressure p(r) [GPa]');
title('Pressure Distribution Comparison - Homogeneous vs Graded');

legend({'Homogeneous Hertz', 'Power-law graded Gamma model'}, ...
    'Location', 'southwest');

xlim([0 1]);
ylim([0 1.10*max(p_hom_norm/1000)]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig, ...
    figures_folder + "fig_04_pressure_comparison_normalized.png", ...
    'Resolution', 300);

%% 10. Bar plot of main quantities

fig2 = figure('Color', 'w');
set(fig2, 'Position', [150 150 1000 620]);

values = [a_hom, a_fgm; ...
          h_hom, h_fgm; ...
          p0_hom/1000, p0_fgm/1000];

bar(values);

xticklabels({'Contact radius a [mm]', ...
             'Indentation depth h [mm]', ...
             'Maximum pressure p_0 [GPa]'});

ylabel('Value');
title('Main Contact Quantities - Homogeneous vs Graded');

legend({'Homogeneous', 'Graded'}, 'Location', 'northwest');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig2, ...
    figures_folder + "fig_04_main_quantities_barplot.png", ...
    'Resolution', 300);

%% 11. Final message

fprintf('Saved:\n');
fprintf('- fig_04_pressure_comparison_normalized.png\n');
fprintf('- fig_04_main_quantities_barplot.png\n');
fprintf('- table_04_homogeneous_vs_graded.csv\n');
fprintf('- data_04_pressure_comparison_normalized.csv\n\n');