# Presentation

This folder contains the final presentation developed for the Micromechanics course project.

Title:

"Elastic Modulus Gradation Effects on Hertzian Contact and Crack Suppression in FG Ceramics"

---

# Objective

The presentation investigates how elastic grading modifies Hertzian contact mechanics and how it can be used to reduce contact severity in brittle materials.

The work is based on the analytical Gamma formulation proposed by:

Jitcharoen et al.

and implemented in MATLAB.

---

# Main Research Question

Can a properly designed elastic modulus gradient:

- increase the contact area,
- redistribute contact stresses,
- reduce peak pressure,
- and potentially suppress Hertzian cone-crack formation?

---

# Presentation Structure

1. Introduction
   - Hertzian contact
   - Functionally graded materials (FGMs)
   - Cone-crack problem

2. Analytical Model
   - Elastic modulus power-law profile
   - Gamma-based formulation
   - Model assumptions

3. MATLAB Implementation
   - Numerical solution of contact radius
   - Computation of indentation depth
   - Computation of pressure distribution

4. Results
   - Pressure redistribution
   - Parametric analysis on k
   - Validity domain
   - Severity maps

5. Engineering Interpretation
   - Contact mitigation
   - Pressure reduction
   - Crack-suppression indicator

6. Conclusions
   - Main findings
   - Model limitations
   - Future developments

---

# Key Parameters

Reference configuration:

- Grading exponent:
  k = 0.497

- Grading coefficient:
  E0 = 85.325 GPa mm^-k

- Applied load:
  P = 2000 N

---

# Main Findings

The analytical model predicts that:

- Elastic grading enlarges the contact area.
- Maximum contact pressure is significantly reduced.
- Pressure redistribution becomes stronger for larger k.
- The investigated configurations remain within the analytical validity domain.
- Contact-pressure reductions greater than 50% can be achieved compared with the homogeneous Hertz solution.

---

# Limitations

The present work evaluates contact pressure redistribution only.

It does not directly calculate:

- subsurface stress fields,
- stress intensity factors,
- crack initiation criteria,
- crack propagation.

A complete fracture-mechanics assessment would require finite-element analysis.

---

# Presentation Duration

Approximate duration:

20–25 minutes

---

# Author

Federico Tremolada

MSc Biomedical Engineering

Politecnico di Milano

Micromechanics Course Project
