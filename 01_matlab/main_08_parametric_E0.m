%% main_08_parametric_E0.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Parametric study of the grading coefficient E0 in the analytical Gamma
% model.
%
% The study evaluates how E0 affects:
% - contact radius a
% - indentation depth h
% - maximum contact pressure p0
% - severity index S = p0_FGM / p0_HOM
%
% Physical meaning:
% E0 controls the stiffness level of the power-law graded material:
%
% E(z) = E0*z^k
%
% Increasing E0 makes the graded material globally stiffer, reducing contact
% spreading and increasing local contact pressure.
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
k      = params.graded.k;
nu     = params.graded.nu;

%% 3. Homogeneous reference solution

hom = hertz_classic(P, R, E_s, nu_s, E_i, nu_i);

a_hom  = hom.a;
h_hom  = hom.h;
p0_hom = hom.p0;

%% 4. E0 range

E0_values = linspace(0.5*E0_ref, 1.5*E0_ref, 200);

a_values  = zeros(size(E0_values));
h_values  = zeros(size(E0_values));
p0_values = zeros(size(E0_values));
S_values  = zeros(size(E0_values));
a_over_D  = zeros(size(E0_values));

%% 5. Parametric loop

for i = 1:length(E0_values)

    E0 = E0_values(i);

    a = graded_contact_radius_gamma(P, D, E0, k, nu);
    res = graded_contact_from_radius(P, D, k, a);

    a_values(i)  = res.a;
    h_values(i)  = res.h;
    p0_values(i) = res.p0;
    S_values(i)  = severity_index(res.p0, p0_hom);
    a_over_D(i)  = res.a / D;

end

%% 6. Reference graded case

a_ref = graded_contact_radius_gamma(P, D, E0_ref, k, nu);
res_ref = graded_contact_from_radius(P, D, k, a_ref);

h_ref      = res_ref.h;
p0_ref     = res_ref.p0;
S_ref      = severity_index(p0_ref, p0_hom);
a_over_D_ref = a_ref / D;

%% 7. Display results

fprintf('\nPARAMETRIC STUDY - GRADING COEFFICIENT E0\n');
fprintf('--------------------------------------------------\n');
fprintf('E0 range                       = %.3f to %.3f GPa mm^(-k)\n', ...
    min(E0_values), max(E0_values));
fprintf('Reference E0                   = %.3f GPa mm^(-k)\n', E0_ref);
fprintf('Reference contact radius a     = %.4f mm\n', a_ref);
fprintf('Reference indentation depth h  = %.6f mm\n', h_ref);
fprintf('Reference maximum pressure p0  = %.2f MPa = %.2f GPa\n', p0_ref, p0_ref/1000);
fprintf('Reference severity index S     = %.3f\n', S_ref);
fprintf('Reference a/D                  = %.4f\n', a_over_D_ref);
fprintf('--------------------------------------------------\n\n');

%% 8. Save data table

parametric_table = table(E0_values', ...
    a_values', h_values', p0_values', p0_values'/1000, S_values', a_over_D', ...
    'VariableNames', {'E0_GPa_mm_minus_k', ...
                      'a_mm', ...
                      'h_mm', ...
                      'p0_MPa', ...
                      'p0_GPa', ...
                      'severity_index', ...
                      'a_over_D'});

writetable(parametric_table, ...
    data_folder + "data_08_parametric_E0.csv");

%% 9. Save summary table

summary_table = table(E0_ref, k, a_ref, h_ref, p0_ref, p0_ref/1000, ...
    S_ref, a_over_D_ref, ...
    'VariableNames', {'E0_reference_GPa_mm_minus_k', ...
                      'k_reference', ...
                      'a_reference_mm', ...
                      'h_reference_mm', ...
                      'p0_reference_MPa', ...
                      'p0_reference_GPa', ...
                      'severity_index_reference', ...
                      'a_over_D_reference'});

writetable(summary_table, ...
    tables_folder + "table_08_parametric_E0_reference.csv");

%% 10. Plot contact radius vs E0

fig1 = figure('Color', 'w');
set(fig1, 'Position', [100 100 950 600]);

plot(E0_values, a_values, 'LineWidth', 3);
hold on;

xline(E0_ref, '--', sprintf('E_{0,ref} = %.3f', E0_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(a_hom, '--', sprintf('a_{HOM} = %.3f mm', a_hom), ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

scatter(E0_ref, a_ref, 80, 'filled');

xlabel('Grading coefficient E_0 [GPa mm^{-k}]');
ylabel('Contact radius a [mm]');
title('Effect of Grading Coefficient E_0 on Contact Radius');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig1, ...
    figures_folder + "fig_08a_contact_radius_vs_E0.png", ...
    'Resolution', 300);

%% 11. Plot indentation depth vs E0

fig2 = figure('Color', 'w');
set(fig2, 'Position', [100 100 950 600]);

plot(E0_values, h_values, 'LineWidth', 3);
hold on;

xline(E0_ref, '--', sprintf('E_{0,ref} = %.3f', E0_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(h_hom, '--', sprintf('h_{HOM} = %.4f mm', h_hom), ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

scatter(E0_ref, h_ref, 80, 'filled');

xlabel('Grading coefficient E_0 [GPa mm^{-k}]');
ylabel('Indentation depth h [mm]');
title('Effect of Grading Coefficient E_0 on Indentation Depth');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig2, ...
    figures_folder + "fig_08b_indentation_depth_vs_E0.png", ...
    'Resolution', 300);

%% 12. Plot maximum pressure vs E0

fig3 = figure('Color', 'w');
set(fig3, 'Position', [100 100 950 600]);

plot(E0_values, p0_values/1000, 'LineWidth', 3);
hold on;

xline(E0_ref, '--', sprintf('E_{0,ref} = %.3f', E0_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(p0_hom/1000, '--', sprintf('p_{0,HOM} = %.2f GPa', p0_hom/1000), ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

scatter(E0_ref, p0_ref/1000, 80, 'filled');

xlabel('Grading coefficient E_0 [GPa mm^{-k}]');
ylabel('Maximum contact pressure p_0 [GPa]');
title('Effect of Grading Coefficient E_0 on Maximum Contact Pressure');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig3, ...
    figures_folder + "fig_08c_max_pressure_vs_E0.png", ...
    'Resolution', 300);

%% 13. Plot severity index vs E0

fig4 = figure('Color', 'w');
set(fig4, 'Position', [100 100 950 600]);

plot(E0_values, S_values, 'LineWidth', 3);
hold on;

xline(E0_ref, '--', sprintf('E_{0,ref} = %.3f', E0_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

yline(1, '--', 'S = 1 homogeneous reference', ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

scatter(E0_ref, S_ref, 80, 'filled');

xlabel('Grading coefficient E_0 [GPa mm^{-k}]');
ylabel('Severity index S = p_{0,FGM}/p_{0,HOM} [-]');
title('Effect of Grading Coefficient E_0 on Contact Severity');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig4, ...
    figures_folder + "fig_08d_severity_index_vs_E0.png", ...
    'Resolution', 300);

%% 14. Plot validity ratio a/D vs E0

fig5 = figure('Color', 'w');
set(fig5, 'Position', [100 100 950 600]);

plot(E0_values, a_over_D, 'LineWidth', 3);
hold on;

yline(0.2, '--', 'a/D = 0.2 validity limit', ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

xline(E0_ref, '--', sprintf('E_{0,ref} = %.3f', E0_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

scatter(E0_ref, a_over_D_ref, 80, 'filled');

xlabel('Grading coefficient E_0 [GPa mm^{-k}]');
ylabel('Geometrical validity ratio a/D [-]');
title('Effect of E_0 on Validity Ratio');

ylim([0, 0.25]);

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig5, ...
    figures_folder + "fig_08e_validity_ratio_vs_E0.png", ...
    'Resolution', 300);

%% 15. Final message

fprintf('Saved:\n');
fprintf('- fig_08a_contact_radius_vs_E0.png\n');
fprintf('- fig_08b_indentation_depth_vs_E0.png\n');
fprintf('- fig_08c_max_pressure_vs_E0.png\n');
fprintf('- fig_08d_severity_index_vs_E0.png\n');
fprintf('- fig_08e_validity_ratio_vs_E0.png\n');
fprintf('- data_08_parametric_E0.csv\n');
fprintf('- table_08_parametric_E0_reference.csv\n\n');