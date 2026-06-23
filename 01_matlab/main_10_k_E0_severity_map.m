%% main_10_k_E0_severity_map.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Build a design map of the contact severity index as a function of:
% - grading exponent k
% - grading coefficient E0
%
% The severity index is defined as:
%
% S = p0_FGM / p0_HOM
%
% where:
% S < 1 indicates reduced contact severity compared with homogeneous
% alumina.
%
% This map is intended as a design-oriented analytical extension of the
% reference paper.
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

E0_ref = params.graded.E0;
k_ref  = params.graded.k;
nu     = params.graded.nu;

validity_limit = 0.2;

%% 3. Homogeneous reference solution

hom = hertz_classic(P, R, E_s, nu_s, E_i, nu_i);

p0_hom = hom.p0;

%% 4. Parameter grid

k_values  = linspace(0.05, 0.95, 160);
E0_values = linspace(0.5*E0_ref, 1.5*E0_ref, 160);

[K_grid, E0_grid] = meshgrid(k_values, E0_values);

S_map          = zeros(size(K_grid));
p0_map_GPa     = zeros(size(K_grid));
a_map          = zeros(size(K_grid));
a_over_D_map   = zeros(size(K_grid));
validity_map   = false(size(K_grid));

%% 5. Compute severity map

for i = 1:size(K_grid, 1)
    for j = 1:size(K_grid, 2)

        k  = K_grid(i, j);
        E0 = E0_grid(i, j);

        a = graded_contact_radius_gamma(P, D, E0, k, nu);
        res = graded_contact_from_radius(P, D, k, a);

        S_map(i, j)        = severity_index(res.p0, p0_hom);
        p0_map_GPa(i, j)   = res.p0 / 1000;
        a_map(i, j)        = res.a;
        a_over_D_map(i, j) = res.a / D;

        validity_map(i, j) = a_over_D_map(i, j) < validity_limit;

    end
end

%% 6. Reference point

a_ref = graded_contact_radius_gamma(P, D, E0_ref, k_ref, nu);
res_ref = graded_contact_from_radius(P, D, k_ref, a_ref);

S_ref        = severity_index(res_ref.p0, p0_hom);
p0_ref_GPa   = res_ref.p0 / 1000;
a_over_D_ref = a_ref / D;

%% 7. Display results

fprintf('\nDESIGN MAP - k-E0 CONTACT SEVERITY\n');
fprintf('--------------------------------------------------\n');
fprintf('Reference k                     = %.3f\n', k_ref);
fprintf('Reference E0                    = %.3f GPa mm^(-k)\n', E0_ref);
fprintf('Reference severity index S      = %.3f\n', S_ref);
fprintf('Reference p0                    = %.2f GPa\n', p0_ref_GPa);
fprintf('Reference a/D                   = %.4f\n', a_over_D_ref);
fprintf('Minimum S in map                = %.3f\n', min(S_map, [], 'all'));
fprintf('Maximum S in map                = %.3f\n', max(S_map, [], 'all'));
fprintf('--------------------------------------------------\n\n');

%% 8. Save map data as long table

map_table = table(K_grid(:), E0_grid(:), S_map(:), ...
    p0_map_GPa(:), a_map(:), a_over_D_map(:), validity_map(:), ...
    'VariableNames', {'k', ...
                      'E0_GPa_mm_minus_k', ...
                      'severity_index', ...
                      'p0_GPa', ...
                      'a_mm', ...
                      'a_over_D', ...
                      'is_valid'});

writetable(map_table, ...
    data_folder + "data_10_k_E0_severity_map.csv");

%% 9. Save summary table

summary_table = table(k_ref, E0_ref, S_ref, p0_ref_GPa, ...
    a_ref, a_over_D_ref, validity_limit, ...
    'VariableNames', {'k_reference', ...
                      'E0_reference_GPa_mm_minus_k', ...
                      'severity_index_reference', ...
                      'p0_reference_GPa', ...
                      'a_reference_mm', ...
                      'a_over_D_reference', ...
                      'validity_limit_a_over_D'});

writetable(summary_table, ...
    tables_folder + "table_10_k_E0_severity_map_reference.csv");

%% 10. Severity heatmap

fig1 = figure('Color', 'w');
set(fig1, 'Position', [100 100 1050 720]);

contourf(K_grid, E0_grid, S_map, 30, 'LineColor', 'none');
hold on;

colorbar;
cb = colorbar;
ylabel(cb, 'Severity index S = p_{0,FGM}/p_{0,HOM} [-]');

contour(K_grid, E0_grid, S_map, [1 1], ...
    'LineColor', 'k', ...
    'LineWidth', 2.2, ...
    'LineStyle', '--');

scatter(k_ref, E0_ref, 120, 'filled', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1.2);

text(k_ref + 0.02, E0_ref, 'Reference paper point', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

xlabel('Grading exponent k [-]');
ylabel('Grading coefficient E_0 [GPa mm^{-k}]');
title('Design Map of Contact Severity');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig1, ...
    figures_folder + "fig_10a_k_E0_severity_map.png", ...
    'Resolution', 300);

%% 11. Pressure reduction heatmap

pressure_reduction_map = (1 - S_map) * 100;

fig2 = figure('Color', 'w');
set(fig2, 'Position', [150 150 1050 720]);

contourf(K_grid, E0_grid, pressure_reduction_map, 30, 'LineColor', 'none');
hold on;

colorbar;
cb = colorbar;
ylabel(cb, 'Pressure reduction [%]');

contour(K_grid, E0_grid, S_map, [1 1], ...
    'LineColor', 'k', ...
    'LineWidth', 2.2, ...
    'LineStyle', '--');

scatter(k_ref, E0_ref, 120, 'filled', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1.2);

text(k_ref + 0.02, E0_ref, 'Reference paper point', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

xlabel('Grading exponent k [-]');
ylabel('Grading coefficient E_0 [GPa mm^{-k}]');
title('Design Map of Pressure Reduction');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig2, ...
    figures_folder + "fig_10b_k_E0_pressure_reduction_map.png", ...
    'Resolution', 300);

%% 12. Validity ratio heatmap

fig3 = figure('Color', 'w');
set(fig3, 'Position', [200 200 1050 720]);

contourf(K_grid, E0_grid, a_over_D_map, 30, 'LineColor', 'none');
hold on;

colorbar;
cb = colorbar;
ylabel(cb, 'Geometrical validity ratio a/D [-]');

contour(K_grid, E0_grid, a_over_D_map, [validity_limit validity_limit], ...
    'LineColor', 'k', ...
    'LineWidth', 2.2, ...
    'LineStyle', '--');

scatter(k_ref, E0_ref, 120, 'filled', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1.2);

text(k_ref + 0.02, E0_ref, 'Reference paper point', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

xlabel('Grading exponent k [-]');
ylabel('Grading coefficient E_0 [GPa mm^{-k}]');
title('Design Map of Geometrical Validity Ratio');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig3, ...
    figures_folder + "fig_10c_k_E0_validity_ratio_map.png", ...
    'Resolution', 300);

%% 13. Final message

fprintf('Saved:\n');
fprintf('- fig_10a_k_E0_severity_map.png\n');
fprintf('- fig_10b_k_E0_pressure_reduction_map.png\n');
fprintf('- fig_10c_k_E0_validity_ratio_map.png\n');
fprintf('- data_10_k_E0_severity_map.csv\n');
fprintf('- table_10_k_E0_severity_map_reference.csv\n\n');