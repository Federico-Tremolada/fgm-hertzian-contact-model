%% main_09_parametric_load.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Parametric study of the applied load P in both:
% - homogeneous Hertzian model;
% - graded Gamma model.
%
% The study evaluates how P affects:
% - contact radius a
% - indentation depth h
% - maximum contact pressure p0
% - severity index S = p0_FGM / p0_HOM
% - geometrical validity ratio a/D
%
% Physical meaning:
% The reference paper uses P = 3000 N to ensure that the indentation
% samples the elastic gradient over a sufficiently large depth.
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

P_ref = params.load.P;

R = params.indenter.R;
D = params.indenter.D;

E_i  = params.indenter.E;
nu_i = params.indenter.nu;

E_s  = params.homogeneous.E;
nu_s = params.homogeneous.nu;

E0 = params.graded.E0;
k  = params.graded.k;
nu = params.graded.nu;

%% 3. Load range

P_values = linspace(500, P_ref, 200);

a_hom_values  = zeros(size(P_values));
h_hom_values  = zeros(size(P_values));
p0_hom_values = zeros(size(P_values));

a_fgm_values  = zeros(size(P_values));
h_fgm_values  = zeros(size(P_values));
p0_fgm_values = zeros(size(P_values));

S_values          = zeros(size(P_values));
a_over_D_hom      = zeros(size(P_values));
a_over_D_fgm      = zeros(size(P_values));
pressure_reduction = zeros(size(P_values));

%% 4. Parametric loop

for i = 1:length(P_values)

    P = P_values(i);

    % Homogeneous Hertz solution
    hom = hertz_classic(P, R, E_s, nu_s, E_i, nu_i);

    a_hom_values(i)  = hom.a;
    h_hom_values(i)  = hom.h;
    p0_hom_values(i) = hom.p0;

    % Graded Gamma solution
    a_fgm = graded_contact_radius_gamma(P, D, E0, k, nu);
    fgm   = graded_contact_from_radius(P, D, k, a_fgm);

    a_fgm_values(i)  = fgm.a;
    h_fgm_values(i)  = fgm.h;
    p0_fgm_values(i) = fgm.p0;

    % Ratios and severity
    S_values(i) = severity_index(fgm.p0, hom.p0);

    a_over_D_hom(i) = hom.a / D;
    a_over_D_fgm(i) = fgm.a / D;

    pressure_reduction(i) = (1 - S_values(i)) * 100;

end

%% 5. Reference case

hom_ref = hertz_classic(P_ref, R, E_s, nu_s, E_i, nu_i);

a_ref_fgm = graded_contact_radius_gamma(P_ref, D, E0, k, nu);
fgm_ref   = graded_contact_from_radius(P_ref, D, k, a_ref_fgm);

S_ref = severity_index(fgm_ref.p0, hom_ref.p0);
pressure_reduction_ref = (1 - S_ref) * 100;

%% 6. Display results

fprintf('\nPARAMETRIC STUDY - APPLIED LOAD P\n');
fprintf('--------------------------------------------------\n');
fprintf('Load range                         = %.0f to %.0f N\n', ...
    min(P_values), max(P_values));
fprintf('Reference load P_ref               = %.0f N\n', P_ref);
fprintf('\n');
fprintf('Reference homogeneous a            = %.4f mm\n', hom_ref.a);
fprintf('Reference graded a                 = %.4f mm\n', fgm_ref.a);
fprintf('Reference homogeneous h            = %.6f mm\n', hom_ref.h);
fprintf('Reference graded h                 = %.6f mm\n', fgm_ref.h);
fprintf('Reference homogeneous p0           = %.2f GPa\n', hom_ref.p0/1000);
fprintf('Reference graded p0                = %.2f GPa\n', fgm_ref.p0/1000);
fprintf('Reference severity index S         = %.3f\n', S_ref);
fprintf('Reference pressure reduction       = %.2f %%\n', pressure_reduction_ref);
fprintf('Reference a/D homogeneous          = %.4f\n', hom_ref.a/D);
fprintf('Reference a/D graded               = %.4f\n', fgm_ref.a/D);
fprintf('--------------------------------------------------\n\n');

%% 7. Save data table

parametric_table = table(P_values', ...
    a_hom_values', a_fgm_values', ...
    h_hom_values', h_fgm_values', ...
    p0_hom_values', p0_fgm_values', ...
    p0_hom_values'/1000, p0_fgm_values'/1000, ...
    S_values', pressure_reduction', ...
    a_over_D_hom', a_over_D_fgm', ...
    'VariableNames', {'P_N', ...
                      'a_hom_mm', 'a_fgm_mm', ...
                      'h_hom_mm', 'h_fgm_mm', ...
                      'p0_hom_MPa', 'p0_fgm_MPa', ...
                      'p0_hom_GPa', 'p0_fgm_GPa', ...
                      'severity_index', ...
                      'pressure_reduction_percent', ...
                      'a_over_D_hom', ...
                      'a_over_D_fgm'});

writetable(parametric_table, ...
    data_folder + "data_09_parametric_load.csv");

%% 8. Save summary table

summary_table = table(P_ref, ...
    hom_ref.a, fgm_ref.a, ...
    hom_ref.h, fgm_ref.h, ...
    hom_ref.p0, fgm_ref.p0, ...
    hom_ref.p0/1000, fgm_ref.p0/1000, ...
    S_ref, pressure_reduction_ref, ...
    hom_ref.a/D, fgm_ref.a/D, ...
    'VariableNames', {'P_reference_N', ...
                      'a_hom_reference_mm', 'a_fgm_reference_mm', ...
                      'h_hom_reference_mm', 'h_fgm_reference_mm', ...
                      'p0_hom_reference_MPa', 'p0_fgm_reference_MPa', ...
                      'p0_hom_reference_GPa', 'p0_fgm_reference_GPa', ...
                      'severity_index_reference', ...
                      'pressure_reduction_reference_percent', ...
                      'a_over_D_hom_reference', ...
                      'a_over_D_fgm_reference'});

writetable(summary_table, ...
    tables_folder + "table_09_parametric_load_reference.csv");

%% 9. Plot contact radius vs load

fig1 = figure('Color', 'w');
set(fig1, 'Position', [100 100 1000 620]);

plot(P_values, a_hom_values, 'LineWidth', 3);
hold on;
plot(P_values, a_fgm_values, 'LineWidth', 3);

xline(P_ref, '--', sprintf('P_{ref} = %.0f N', P_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

xlabel('Applied load P [N]');
ylabel('Contact radius a [mm]');
title('Effect of Applied Load on Contact Radius');

legend({'Homogeneous Hertz', 'Graded Gamma model'}, ...
    'Location', 'northwest');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig1, ...
    figures_folder + "fig_09a_contact_radius_vs_load.png", ...
    'Resolution', 300);

%% 10. Plot indentation depth vs load

fig2 = figure('Color', 'w');
set(fig2, 'Position', [100 100 1000 620]);

plot(P_values, h_hom_values, 'LineWidth', 3);
hold on;
plot(P_values, h_fgm_values, 'LineWidth', 3);

xline(P_ref, '--', sprintf('P_{ref} = %.0f N', P_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

xlabel('Applied load P [N]');
ylabel('Indentation depth h [mm]');
title('Effect of Applied Load on Indentation Depth');

legend({'Homogeneous Hertz', 'Graded Gamma model'}, ...
    'Location', 'northwest');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig2, ...
    figures_folder + "fig_09b_indentation_depth_vs_load.png", ...
    'Resolution', 300);

%% 11. Plot maximum pressure vs load

fig3 = figure('Color', 'w');
set(fig3, 'Position', [100 100 1000 620]);

plot(P_values, p0_hom_values/1000, 'LineWidth', 3);
hold on;
plot(P_values, p0_fgm_values/1000, 'LineWidth', 3);

xline(P_ref, '--', sprintf('P_{ref} = %.0f N', P_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

xlabel('Applied load P [N]');
ylabel('Maximum contact pressure p_0 [GPa]');
title('Effect of Applied Load on Maximum Contact Pressure');

legend({'Homogeneous Hertz', 'Graded Gamma model'}, ...
    'Location', 'northwest');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig3, ...
    figures_folder + "fig_09c_max_pressure_vs_load.png", ...
    'Resolution', 300);

%% 12. Plot severity index vs load

fig4 = figure('Color', 'w');
set(fig4, 'Position', [100 100 1000 620]);

plot(P_values, S_values, 'LineWidth', 3);
hold on;

xline(P_ref, '--', sprintf('P_{ref} = %.0f N', P_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(1, '--', 'S = 1 homogeneous reference', ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

xlabel('Applied load P [N]');
ylabel('Severity index S = p_{0,FGM}/p_{0,HOM} [-]');
title('Effect of Applied Load on Contact Severity');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig4, ...
    figures_folder + "fig_09d_severity_index_vs_load.png", ...
    'Resolution', 300);

%% 13. Plot pressure reduction vs load

fig5 = figure('Color', 'w');
set(fig5, 'Position', [100 100 1000 620]);

plot(P_values, pressure_reduction, 'LineWidth', 3);
hold on;

xline(P_ref, '--', sprintf('P_{ref} = %.0f N', P_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

xlabel('Applied load P [N]');
ylabel('Pressure reduction relative to homogeneous [%]');
title('Pressure Reduction Induced by Elastic Grading');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig5, ...
    figures_folder + "fig_09e_pressure_reduction_vs_load.png", ...
    'Resolution', 300);

%% 14. Plot validity ratio vs load

fig6 = figure('Color', 'w');
set(fig6, 'Position', [100 100 1000 620]);

plot(P_values, a_over_D_hom, 'LineWidth', 3);
hold on;
plot(P_values, a_over_D_fgm, 'LineWidth', 3);

yline(0.2, '--', 'a/D = 0.2 validity limit', ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

xline(P_ref, '--', sprintf('P_{ref} = %.0f N', P_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

xlabel('Applied load P [N]');
ylabel('Geometrical validity ratio a/D [-]');
title('Effect of Applied Load on Validity Ratio');

legend({'Homogeneous Hertz', 'Graded Gamma model'}, ...
    'Location', 'northwest');

ylim([0, 0.25]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig6, ...
    figures_folder + "fig_09f_validity_ratio_vs_load.png", ...
    'Resolution', 300);

%% 15. Final message

fprintf('Saved:\n');
fprintf('- fig_09a_contact_radius_vs_load.png\n');
fprintf('- fig_09b_indentation_depth_vs_load.png\n');
fprintf('- fig_09c_max_pressure_vs_load.png\n');
fprintf('- fig_09d_severity_index_vs_load.png\n');
fprintf('- fig_09e_pressure_reduction_vs_load.png\n');
fprintf('- fig_09f_validity_ratio_vs_load.png\n');
fprintf('- data_09_parametric_load.csv\n');
fprintf('- table_09_parametric_load_reference.csv\n\n');