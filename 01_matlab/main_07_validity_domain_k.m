%% main_07_validity_domain_k.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Check the validity domain of the analytical spherical indentation model
% as a function of the grading exponent k.
%
% In the reference paper, the spherical indenter is approximated locally as
% a paraboloid, which is considered valid for:
%
% a/D < 0.2
%
% where:
% a = contact radius
% D = indenter diameter
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

validity_limit = 0.2;

%% 3. k range

k_values = linspace(0.01, 0.99, 300);

a_values = zeros(size(k_values));
a_over_D = zeros(size(k_values));
is_valid = false(size(k_values));

%% 4. Compute validity parameter a/D

for i = 1:length(k_values)

    k = k_values(i);

    a = graded_contact_radius_gamma(P, D, E0, k, nu);

    a_values(i) = a;
    a_over_D(i) = a / D;

    is_valid(i) = a_over_D(i) < validity_limit;

end

%% 5. Reference point

a_ref = graded_contact_radius_gamma(P, D, E0, k_ref, nu);
a_over_D_ref = a_ref / D;
is_ref_valid = a_over_D_ref < validity_limit;

%% 6. Find maximum valid k

valid_indices = find(is_valid);

if isempty(valid_indices)
    k_max_valid = NaN;
else
    k_max_valid = max(k_values(valid_indices));
end

%% 7. Display results

fprintf('\nVALIDITY DOMAIN CHECK - a/D < 0.2\n');
fprintf('--------------------------------------------------\n');
fprintf('Validity criterion              = a/D < %.2f\n', validity_limit);
fprintf('Reference k                     = %.3f\n', k_ref);
fprintf('Reference a                     = %.4f mm\n', a_ref);
fprintf('Reference a/D                   = %.4f\n', a_over_D_ref);

if is_ref_valid
    fprintf('Reference case validity         = VALID\n');
else
    fprintf('Reference case validity         = OUTSIDE VALIDITY DOMAIN\n');
end

fprintf('Maximum valid k in range        = %.3f\n', k_max_valid);
fprintf('--------------------------------------------------\n\n');

%% 8. Save full data table

validity_table = table(k_values', a_values', a_over_D', is_valid', ...
    'VariableNames', {'k', 'a_mm', 'a_over_D', 'is_valid'});

writetable(validity_table, ...
    data_folder + "data_07_validity_domain_k.csv");

%% 9. Save summary table

summary_table = table(validity_limit, k_ref, a_ref, a_over_D_ref, ...
    is_ref_valid, k_max_valid, ...
    'VariableNames', {'validity_limit_a_over_D', ...
                      'k_reference', ...
                      'a_reference_mm', ...
                      'a_over_D_reference', ...
                      'is_reference_valid', ...
                      'k_max_valid'});

writetable(summary_table, ...
    tables_folder + "table_07_validity_domain_k_summary.csv");

%% 10. Plot a/D vs k

fig1 = figure('Color', 'w');
set(fig1, 'Position', [100 100 1000 620]);

plot(k_values, a_over_D, 'LineWidth', 3);
hold on;

yline(validity_limit, '--', ...
    'a/D = 0.2 validity limit', ...
    'LineWidth', 1.8, ...
    'LabelHorizontalAlignment', 'left', ...
    'LabelVerticalAlignment', 'bottom');

xline(k_ref, '--', ...
    sprintf('k_{ref} = %.3f', k_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

scatter(k_ref, a_over_D_ref, 90, 'filled');

xlabel('Grading exponent k [-]');
ylabel('Geometrical validity ratio a/D [-]');
title('Validity Domain of the Gamma Contact Model');

ylim([0, 0.25]);
xlim([min(k_values), max(k_values)]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig1, ...
    figures_folder + "fig_07_validity_domain_a_over_D_vs_k.png", ...
    'Resolution', 300);

%% 11. Improved validity-region plot

fig2 = figure('Color', 'w');
set(fig2, 'Position', [150 150 1000 620]);

hold on;

x_min = min(k_values);
x_max = max(k_values);
y_max = 0.25;

% Valid region: below a/D = 0.2
patch([x_min x_max x_max x_min], ...
      [0 0 validity_limit validity_limit], ...
      [0.75 0.90 0.75], ...
      'FaceAlpha', 0.35, ...
      'EdgeColor', 'none');

% Invalid region: above a/D = 0.2
patch([x_min x_max x_max x_min], ...
      [validity_limit validity_limit y_max y_max], ...
      [0.95 0.75 0.75], ...
      'FaceAlpha', 0.35, ...
      'EdgeColor', 'none');

plot(k_values, a_over_D, 'LineWidth', 3);

yline(validity_limit, '--', ...
    'a/D = 0.2 limit', ...
    'LineWidth', 1.8, ...
    'LabelHorizontalAlignment', 'left', ...
    'LabelVerticalAlignment', 'bottom');

xline(k_ref, '--', ...
    sprintf('k_{ref} = %.3f', k_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

scatter(k_ref, a_over_D_ref, 90, 'filled');

text(0.04, 0.05, 'Valid domain', ...
    'FontSize', 13, ...
    'FontWeight', 'bold');

text(0.04, 0.225, 'Outside validity domain', ...
    'FontSize', 13, ...
    'FontWeight', 'bold');

xlabel('Grading exponent k [-]');
ylabel('Geometrical validity ratio a/D [-]');
title('Validity and Extrapolation Regions of the Analytical Model');

xlim([x_min x_max]);
ylim([0 y_max]);

legend({'Valid domain', ...
        'Outside validity domain', ...
        'a/D curve', ...
        'Validity limit', ...
        'Reference k'}, ...
        'Location', 'northwest');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig2, ...
    figures_folder + "fig_07_validity_and_extrapolation_regions_k.png", ...
    'Resolution', 300);

%% 12. Final message

fprintf('Saved:\n');
fprintf('- fig_07_validity_domain_a_over_D_vs_k.png\n');
fprintf('- fig_07_validity_and_extrapolation_regions_k.png\n');
fprintf('- data_07_validity_domain_k.csv\n');
fprintf('- table_07_validity_domain_k_summary.csv\n\n');