%% main_06_pressure_profiles_vs_k.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Compare the normalized pressure distributions for different values of the
% grading exponent k using the analytical Gamma model.
%
% This script shows how increasing k modifies the shape and intensity of
% the contact pressure distribution.
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
E0 = params.graded.E0;
nu = params.graded.nu;

k_ref = params.graded.k;

%% 3. k values for comparison

k_values = [0.1, 0.3, k_ref, 0.7, 0.9];

rho = linspace(0, 1, 500);

a_values  = zeros(size(k_values));
h_values  = zeros(size(k_values));
p0_values = zeros(size(k_values));

pressure_matrix_GPa = zeros(length(rho), length(k_values));

%% 4. Compute pressure profiles

for i = 1:length(k_values)

    k = k_values(i);

    a = graded_contact_radius_gamma(P, D, E0, k, nu);
    res = graded_contact_from_radius(P, D, k, a);

    a_values(i)  = res.a;
    h_values(i)  = res.h;
    p0_values(i) = res.p0;

    pressure_matrix_GPa(:, i) = ...
        (res.p0 .* (1 - rho.^2).^((1 + k)/2))' / 1000;

end

%% 5. Display results

fprintf('\nPRESSURE PROFILES FOR DIFFERENT k VALUES\n');
fprintf('--------------------------------------------------\n');

for i = 1:length(k_values)
    fprintf('k = %.3f | a = %.4f mm | h = %.5f mm | p0 = %.2f GPa\n', ...
        k_values(i), a_values(i), h_values(i), p0_values(i)/1000);
end

fprintf('--------------------------------------------------\n\n');

%% 6. Save summary table

summary_table = table(k_values', a_values', h_values', ...
    p0_values', p0_values'/1000, ...
    'VariableNames', {'k', 'a_mm', 'h_mm', 'p0_MPa', 'p0_GPa'});

writetable(summary_table, ...
    tables_folder + "table_06_pressure_profiles_vs_k.csv");

%% 7. Save pressure profiles data

pressure_table = array2table([rho', pressure_matrix_GPa], ...
    'VariableNames', [{'rho_r_over_a'}, ...
    strcat("pressure_GPa_k_", string(k_values))]);

writetable(pressure_table, ...
    data_folder + "data_06_pressure_profiles_vs_k.csv");

%% 8. Plot pressure profiles

fig = figure('Color', 'w');
set(fig, 'Position', [100 100 1050 650]);

hold on;

for i = 1:length(k_values)
    plot(rho, pressure_matrix_GPa(:, i), 'LineWidth', 3);
end

xlabel('Normalized radial coordinate r/a [-]');
ylabel('Contact pressure p(r) [GPa]');
title('Effect of Grading Exponent k on Pressure Distribution');

legend_labels = strings(size(k_values));
for i = 1:length(k_values)
    if abs(k_values(i) - k_ref) < 1e-6
        legend_labels(i) = sprintf('k = %.3f reference', k_values(i));
    else
        legend_labels(i) = sprintf('k = %.1f', k_values(i));
    end
end

legend(legend_labels, 'Location', 'southwest');

xlim([0 1]);

max_pressure = max(pressure_matrix_GPa, [], 'all');
ylim([0 1.10 * max_pressure]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig, ...
    figures_folder + "fig_06_pressure_profiles_vs_k.png", ...
    'Resolution', 300);

%% 9. Plot normalized pressure profiles

fig2 = figure('Color', 'w');
set(fig2, 'Position', [150 150 1050 650]);

hold on;

for i = 1:length(k_values)

    p_norm = pressure_matrix_GPa(:, i) ./ max(pressure_matrix_GPa(:, i));

    plot(rho, p_norm, 'LineWidth', 3);

end

xlabel('Normalized radial coordinate r/a [-]');
ylabel('Normalized pressure p(r)/p_0 [-]');
title('Normalized Pressure Shape for Different k Values');

legend(legend_labels, 'Location', 'southwest');

xlim([0 1]);
ylim([0 1.05]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig2, ...
    figures_folder + "fig_06_normalized_pressure_shape_vs_k.png", ...
    'Resolution', 300);

%% 10. Final message

fprintf('Saved:\n');
fprintf('- fig_06_pressure_profiles_vs_k.png\n');
fprintf('- fig_06_normalized_pressure_shape_vs_k.png\n');
fprintf('- table_06_pressure_profiles_vs_k.csv\n');
fprintf('- data_06_pressure_profiles_vs_k.csv\n\n');