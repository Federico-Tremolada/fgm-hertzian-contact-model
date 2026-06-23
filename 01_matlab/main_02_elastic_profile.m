%% main_02_elastic_profile.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Visualize the real elastic modulus profile of the functionally graded
% material reported in the reference paper.
%
% Real material law:
% E(z) = E_surface + E0*z^k
%
% This profile represents the experimental S-FGM material.
% It is not the simplified analytical profile used in the Gamma model.
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

E_surface = params.graded.E_surface;
E0        = params.graded.E0;
k         = params.graded.k;
E_bulk    = params.homogeneous.E;

%% 3. Depth vector

z_max = 2.2;                 % [mm]
z = linspace(0, z_max, 500); % [mm]

%% 4. Real elastic profile

E_z = E_surface + E0 .* z.^k;

%% 5. Display parameters

fprintf('\nREAL ELASTIC PROFILE - FUNCTIONALLY GRADED MATERIAL\n');
fprintf('----------------------------------------------------\n');
fprintf('E_surface = %.3f GPa\n', E_surface);
fprintf('E0        = %.3f GPa mm^(-k)\n', E0);
fprintf('k         = %.3f\n', k);
fprintf('E_bulk    = %.3f GPa\n', E_bulk);
fprintf('----------------------------------------------------\n\n');

%% 6. Save profile data

profile_table = table(z', E_z', ...
    'VariableNames', {'depth_mm', 'elastic_modulus_GPa'});

writetable(profile_table, ...
    data_folder + "data_02_real_elastic_profile.csv");

%% 7. Save summary table

summary_table = table(E_surface, E0, k, E_bulk, z_max, ...
    'VariableNames', {'E_surface_GPa', ...
                      'E0_GPa_mm_minus_k', ...
                      'k', ...
                      'E_bulk_GPa', ...
                      'z_max_mm'});

writetable(summary_table, ...
    tables_folder + "table_02_elastic_profile_parameters.csv");

%% 8. Plot elastic profile

fig = figure('Color', 'w');
set(fig, 'Position', [100 100 950 600]);

plot(z, E_z, 'LineWidth', 3);
hold on;

scatter(0, E_surface, 80, 'filled');

text(0.04, E_surface + 5, ...
    sprintf('E_{surface} = %.0f GPa', E_surface), ...
    'FontSize', 12);

yline(E_bulk, '--', ...
    sprintf('Bulk alumina = %.0f GPa', E_bulk), ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left', ...
    'LabelVerticalAlignment', 'bottom');

xline(2.0, '--', ...
    'Gradient depth \approx 2 mm', ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

xlabel('Depth z [mm]');
ylabel('Elastic modulus E(z) [GPa]');
title('Real Elastic Modulus Profile - Functionally Graded Material');

xlim([0 z_max]);
ylim([0.95*min(E_z) 1.07*max(E_z)]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

%% 9. Save figure

exportgraphics(fig, ...
    figures_folder + "fig_02_real_elastic_profile.png", ...
    'Resolution', 300);

%% 10. Final message

fprintf('Saved:\n');
fprintf('- fig_02_real_elastic_profile.png\n');
fprintf('- data_02_real_elastic_profile.csv\n');
fprintf('- table_02_elastic_profile_parameters.csv\n\n');