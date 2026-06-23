%% main_05_parametric_k.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Parametric study of the grading exponent k in the analytical Gamma model.
%
% The study evaluates how k affects:
% - contact radius a
% - indentation depth h
% - maximum contact pressure p0
% - contact severity index S = p0_FGM / p0_HOM
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
nu = params.graded.nu;

k_ref = params.graded.k;

%% 3. Homogeneous reference solution

hom = hertz_classic(P, R, E_s, nu_s, E_i, nu_i);

a_hom  = hom.a;
h_hom  = hom.h;
p0_hom = hom.p0;

%% 4. k range

% Avoid k = 1 because the analytical formulation requires k < 1
k_values = linspace(0.01, 0.99, 200);

a_values  = zeros(size(k_values));
h_values  = zeros(size(k_values));
p0_values = zeros(size(k_values));
S_values  = zeros(size(k_values));

%% 5. Parametric loop

for i = 1:length(k_values)

    k = k_values(i);

    a = graded_contact_radius_gamma(P, D, E0, k, nu);
    res = graded_contact_from_radius(P, D, k, a);

    a_values(i)  = res.a;
    h_values(i)  = res.h;
    p0_values(i) = res.p0;
    S_values(i)  = severity_index(res.p0, p0_hom);

end

%% 6. Reference graded case

a_ref = graded_contact_radius_gamma(P, D, E0, k_ref, nu);
res_ref = graded_contact_from_radius(P, D, k_ref, a_ref);

h_ref  = res_ref.h;
p0_ref = res_ref.p0;
S_ref  = severity_index(p0_ref, p0_hom);

%% 7. Display results

fprintf('\nPARAMETRIC STUDY - GRADING EXPONENT k\n');
fprintf('--------------------------------------------------\n');
fprintf('k range                        = %.2f to %.2f\n', min(k_values), max(k_values));
fprintf('Reference k                    = %.3f\n', k_ref);
fprintf('Reference contact radius a     = %.4f mm\n', a_ref);
fprintf('Reference indentation depth h  = %.6f mm\n', h_ref);
fprintf('Reference maximum pressure p0  = %.2f MPa = %.2f GPa\n', p0_ref, p0_ref/1000);
fprintf('Reference severity index S     = %.3f\n', S_ref);
fprintf('--------------------------------------------------\n\n');

%% 8. Save data table

parametric_table = table(k_values', ...
    a_values', h_values', p0_values', p0_values'/1000, S_values', ...
    'VariableNames', {'k', ...
                      'a_mm', ...
                      'h_mm', ...
                      'p0_MPa', ...
                      'p0_GPa', ...
                      'severity_index'});

writetable(parametric_table, ...
    data_folder + "data_05_parametric_k.csv");

%% 9. Save summary table

summary_table = table(k_ref, a_ref, h_ref, p0_ref, p0_ref/1000, S_ref, ...
    'VariableNames', {'k_reference', ...
                      'a_reference_mm', ...
                      'h_reference_mm', ...
                      'p0_reference_MPa', ...
                      'p0_reference_GPa', ...
                      'severity_index_reference'});

writetable(summary_table, ...
    tables_folder + "table_05_parametric_k_reference.csv");

%% 10. Plot contact radius vs k

fig1 = figure('Color', 'w');
set(fig1, 'Position', [100 100 950 600]);

plot(k_values, a_values, 'LineWidth', 3);
hold on;

xline(k_ref, '--', sprintf('k_{ref} = %.3f', k_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(a_hom, '--', sprintf('a_{HOM} = %.3f mm', a_hom), ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

scatter(k_ref, a_ref, 80, 'filled');

xlabel('Grading exponent k [-]');
ylabel('Contact radius a [mm]');
title('Effect of Grading Exponent k on Contact Radius');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig1, ...
    figures_folder + "fig_05a_contact_radius_vs_k.png", ...
    'Resolution', 300);

%% 11. Plot indentation depth vs k

fig2 = figure('Color', 'w');
set(fig2, 'Position', [100 100 950 600]);

plot(k_values, h_values, 'LineWidth', 3);
hold on;

xline(k_ref, '--', sprintf('k_{ref} = %.3f', k_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(h_hom, '--', sprintf('h_{HOM} = %.4f mm', h_hom), ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

scatter(k_ref, h_ref, 80, 'filled');

xlabel('Grading exponent k [-]');
ylabel('Indentation depth h [mm]');
title('Effect of Grading Exponent k on Indentation Depth');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig2, ...
    figures_folder + "fig_05b_indentation_depth_vs_k.png", ...
    'Resolution', 300);

%% 12. Plot maximum pressure vs k

fig3 = figure('Color', 'w');
set(fig3, 'Position', [100 100 950 600]);

plot(k_values, p0_values/1000, 'LineWidth', 3);
hold on;

xline(k_ref, '--', sprintf('k_{ref} = %.3f', k_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(p0_hom/1000, '--', sprintf('p_{0,HOM} = %.2f GPa', p0_hom/1000), ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

scatter(k_ref, p0_ref/1000, 80, 'filled');

xlabel('Grading exponent k [-]');
ylabel('Maximum contact pressure p_0 [GPa]');
title('Effect of Grading Exponent k on Maximum Contact Pressure');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig3, ...
    figures_folder + "fig_05c_max_pressure_vs_k.png", ...
    'Resolution', 300);

%% 13. Plot severity index vs k

fig4 = figure('Color', 'w');
set(fig4, 'Position', [100 100 950 600]);

plot(k_values, S_values, 'LineWidth', 3);
hold on;

xline(k_ref, '--', sprintf('k_{ref} = %.3f', k_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(1, '--', 'S = 1 homogeneous reference', ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

scatter(k_ref, S_ref, 80, 'filled');

xlabel('Grading exponent k [-]');
ylabel('Severity index S = p_{0,FGM}/p_{0,HOM} [-]');
title('Effect of Grading Exponent k on Contact Severity');

ylim([0, max(1.05, 1.1*max(S_values))]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig4, ...
    figures_folder + "fig_05d_severity_index_vs_k.png", ...
    'Resolution', 300);

%% 14. Final message

fprintf('Saved:\n');
fprintf('- fig_05a_contact_radius_vs_k.png\n');
fprintf('- fig_05b_indentation_depth_vs_k.png\n');
fprintf('- fig_05c_max_pressure_vs_k.png\n');
fprintf('- fig_05d_severity_index_vs_k.png\n');
fprintf('- data_05_parametric_k.csv\n');
fprintf('- table_05_parametric_k_reference.csv\n\n');