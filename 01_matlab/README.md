# MATLAB Implementation

This folder contains the MATLAB implementation of the analytical Hertzian contact model for functionally graded ceramics.

## Structure

* `main/` contains the executable scripts used to reproduce the analyses.
* `functions/` contains reusable MATLAB functions for contact-radius calculation, pressure evaluation, penetration depth, severity index and validation.

## Execution Order

The scripts are intended to be run in numerical order:

1. Classical Hertzian contact model
2. Elastic profile visualization
3. Gamma-based graded contact model
4. Validation against the analytical benchmark
5. Homogeneous vs graded contact comparison
6. Parametric study on the grading exponent `k`
7. Pressure profiles for different `k` values
8. Validity-domain check based on `a/D`
9. Parametric study on the grading coefficient `E0`
10. Parametric study on the applied load `P`
11. Severity map in the `(k, E0)` parameter space

## Notes

The implementation is based on the analytical Gamma-function formulation for a power-law graded elastic medium. The real elastic profile of the reference material is used for visualization and physical interpretation, while the pure power-law approximation is used for the closed-form contact solution.
