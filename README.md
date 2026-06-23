# Elastic Modulus Grading for Contact Mitigation in Functionally Graded Ceramics

![MATLAB](https://img.shields.io/badge/MATLAB-Analytical%20Modeling-orange)
![Contact Mechanics](https://img.shields.io/badge/Field-Contact%20Mechanics-blue)
![FGM](https://img.shields.io/badge/Material-Functionally%20Graded%20Materials-green)
![Micromechanics](https://img.shields.io/badge/Course-Micromechanics-lightgrey)
![Politecnico di Milano](https://img.shields.io/badge/University-Politecnico%20di%20Milano-red)

---

## Overview

Brittle ceramics are widely used in engineering and biomedical applications thanks to their high stiffness, wear resistance, and chemical stability. However, their limited fracture toughness makes them vulnerable to surface damage under concentrated contact loading.

When a spherical indenter presses against a ceramic surface, localized tensile stresses may develop near the contact boundary. If these stresses exceed the material resistance, Hertzian cone cracks can nucleate and propagate, eventually compromising structural integrity.

One strategy to mitigate this failure mechanism is the use of **Functionally Graded Materials (FGMs)**, where the elastic modulus varies continuously with depth. A compliant surface combined with a progressively stiffer substrate can redistribute contact stresses, enlarge the contact area, and reduce peak pressure.

This project investigates how elastic grading influences contact mechanics using an analytical framework based on the **Gamma contact model** proposed by Jitcharoen et al. The objective is to quantify the effects of grading on contact radius, indentation depth, pressure distribution, contact severity, and the propensity for Hertzian cone-crack initiation.

---

## Engineering Motivation

The physical idea behind the project can be summarized as:

```text
Homogeneous ceramic
↓
Localized contact stresses
↓
High tensile stresses
↓
Cone crack initiation

Functionally graded ceramic
↓
Larger contact area
↓
Stress redistribution
↓
Lower peak pressure
↓
Reduced crack propensity
```

Rather than increasing fracture toughness directly, elastic grading acts as a passive stress-management strategy.

---

## Research Question

The central question addressed in this project is:

> How does elastic modulus grading modify Hertzian contact mechanics and influence the conditions associated with cone-crack initiation in brittle ceramics?

More specifically, the study investigates:

- the influence of the grading exponent k;
- the influence of the grading coefficient E₀;
- the influence of applied load P;
- the validity limits of the analytical model;
- the relationship between pressure reduction and crack suppression.

---

## Physical Background

### Classical Hertzian Contact

For a homogeneous elastic half-space loaded by a rigid sphere, Hertz theory predicts:

- contact radius a;
- indentation depth h;
- pressure distribution p(r);
- maximum pressure p₀.

The contact pressure follows a semi-elliptical distribution and reaches its maximum at the center of the contact.

Although Hertz theory provides an elegant analytical solution, it assumes homogeneous material properties and therefore cannot capture the effects of elastic grading.

---

### Functionally Graded Materials

In a Functionally Graded Material, the elastic modulus varies continuously with depth according to:

\[
E(z)=E_0 z^k
\]

where:

- E(z) = elastic modulus at depth z;
- E₀ = grading coefficient;
- k = grading exponent.

The grading exponent controls the shape of the stiffness profile:

- small k → weak grading;
- large k → strong grading.

The grading coefficient controls the overall stiffness level of the material.

---

## Reference Analytical Model

This project is based on the analytical formulation proposed by:

**Jitcharoen et al.**

The model introduces the Gamma formulation for axisymmetric contact between a rigid spherical indenter and a power-law graded elastic half-space.

Unlike classical Hertz theory, the contact radius becomes the primary unknown of the problem.

Once the contact radius is obtained, all remaining quantities can be computed analytically:

- indentation depth h;
- pressure distribution p(r);
- maximum pressure p₀.

The formulation naturally reduces to the classical Hertz solution when the grading effect vanishes.

---

## Methodology

The project follows a fully analytical and reproducible workflow implemented in MATLAB.

### Step 1 — Classical Hertz Reference Solution

Reference contact quantities are computed for a homogeneous material:

- contact radius;
- indentation depth;
- maximum pressure.

Script:

```text
main_01_hertz_classic.m
```

---

### Step 2 — Elastic Profile Definition

The power-law elastic grading profile is generated and visualized.

Script:

```text
main_02_elastic_profile.m
```

---

### Step 3 — Gamma Contact Solution

The analytical Gamma formulation is solved numerically to obtain:

- contact radius;
- indentation depth;
- pressure distribution.

Script:

```text
main_03_graded_gamma_model.m
```

---

### Step 4 — Homogeneous vs Graded Comparison

Direct comparison between Hertzian and graded solutions.

Script:

```text
main_04_homogeneous_vs_graded.m
```

---

### Step 5 — Parametric Study on Grading Exponent

Investigation of the influence of k on contact mechanics.

Scripts:

```text
main_05_parametric_k.m
main_06_pressure_profiles_vs_k.m
```

---

### Step 6 — Validity-Domain Assessment

Verification of the analytical assumption:

\[
a/D < 0.2
\]

Script:

```text
main_07_validity_domain_k.m
```

---

### Step 7 — Parametric Study on Grading Coefficient

Investigation of the influence of E₀.

Script:

```text
main_08_parametric_E0.m
```

---

### Step 8 — Parametric Study on Applied Load

Investigation of load dependence.

Script:

```text
main_09_parametric_load.m
```

---

### Step 9 — Design-Oriented Severity Maps

Generation of design maps in the (k,E₀) parameter space.

Script:

```text
main_10_k_E0_severity_map.m
```

---

### Step 10 — Crack-Suppression Interpretation

Introduction of a simplified indicator connecting pressure mitigation and crack suppression.

Script:

```text
main_11_crack_suppression_indicator.m
```

---

## Key Quantities

### Contact Severity Index

A dimensionless severity metric is defined as:

\[
S_p=\frac{p_{0,FGM}}{p_{0,HOM}}
\]

where:

- Sₚ = contact severity index;
- p₀,FGM = graded maximum pressure;
- p₀,HOM = Hertzian maximum pressure.

Interpretation:

- Sₚ = 1 → no benefit;
- Sₚ < 1 → pressure reduction;
- smaller Sₚ → better contact mitigation.

---

### Crack-Suppression Indicator

A simplified crack-suppression indicator is defined as:

\[
I_{cc}=1-S_p
\]

Interpretation:

- Icc = 0 → no improvement;
- larger Icc → stronger pressure mitigation;
- larger Icc → lower expected tendency for cone-crack initiation.

This indicator does not represent a fracture-mechanics criterion, but provides an intuitive engineering measure of the potential benefit of elastic grading.

---

## Main Results

### Effect of Grading Exponent k

Increasing k produces:

- larger contact radius;
- larger indentation depth;
- lower maximum pressure;
- stronger crack-suppression indicator.

The strongest pressure reductions are obtained for large grading exponents.

---

### Effect of Grading Coefficient E₀

Increasing E₀ produces:

- smaller contact radius;
- lower indentation depth;
- higher maximum pressure;
- reduced mitigation effect.

A softer graded surface promotes pressure redistribution more effectively.

---

### Effect of Applied Load

As the load increases:

- contact radius increases;
- indentation depth increases;
- maximum pressure increases.

However, the graded solution remains consistently less severe than the homogeneous Hertzian solution over the entire investigated load range.

---

## Design Maps

A major outcome of the project is the generation of design-oriented maps in the (k,E₀) parameter space.

These maps provide direct guidance on how grading parameters influence:

- contact severity;
- pressure reduction;
- geometrical validity.

The maps can therefore be used as preliminary design tools for functionally graded ceramic systems.

---

## Validity Domain

The Gamma formulation relies on the assumption:

\[
a/D < 0.2
\]

where:

- a = contact radius;
- D = characteristic grading depth.

The entire investigated parameter range remains below this limit.

The reference configuration proposed in the original paper satisfies:

\[
a/D \approx 0.056
\]

which is well inside the validity domain.

Therefore, all conclusions are obtained within the theoretical assumptions of the analytical model.

---

## Engineering Interpretation

The physical mechanism observed throughout the study can be summarized as:

```text
Compliant surface
↓
Larger contact radius
↓
Pressure redistribution
↓
Lower contact severity
↓
Lower tensile stresses
↓
Reduced cone-crack propensity
```

Elastic grading does not eliminate contact stresses.

Instead, it redistributes them over a larger area, reducing local stress concentrations that are typically responsible for Hertzian cone-crack initiation.

---

## Repository Structure

```text
Micromechanics-Hertzian-FGM
│
├── 00_docs/
│   └── README.md
│
├── 01_matlab/
│   ├── functions/
│   ├── README.md
│   ├── main_01_hertz_classic.m
│   ├── main_02_elastic_profile.m
│   ├── main_03_graded_gamma_model.m
│   ├── main_04_homogeneous_vs_graded.m
│   ├── main_05_parametric_k.m
│   ├── main_06_pressure_profiles_vs_k.m
│   ├── main_07_validity_domain_k.m
│   ├── main_08_parametric_E0.m
│   ├── main_09_parametric_load.m
│   ├── main_10_k_E0_severity_map.m
│   └── main_11_crack_suppression_indicator.m
│
├── 02_results/
│   ├── data/
│   ├── figures/
│   ├── tables/
│   └── README.md
│
├── 03_presentation/
│   ├── Micromechanics_Tremolada.pdf
│   └── README.md
│
└── README.md
```

---

## Main Conclusions

- Elastic grading significantly modifies Hertzian contact behavior.
- Increasing the grading exponent enlarges the contact area and reduces peak pressure.
- Pressure reductions greater than 50% can be achieved within the investigated parameter space.
- Reduced contact severity is associated with a lower propensity for Hertzian cone-crack initiation.
- The reference configuration proposed in the original paper remains safely inside the analytical validity domain.
- Functionally graded ceramics represent an effective strategy for passive stress mitigation under concentrated contact loading.

---

## Future Developments

Potential extensions of the present work include:

- Finite Element Analysis (FEA);
- explicit stress-field evaluation;
- fracture-mechanics-based crack initiation criteria;
- stress intensity factor calculations;
- experimental validation;
- optimization of grading profiles;
- design of bioinspired ceramic systems.

---

## Author

**Federico Tremolada**

M.Sc. Student in Biomechanics and Biomaterials  
Politecnico di Milano

Micromechanics Course Project
