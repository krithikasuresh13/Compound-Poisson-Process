# Compound Poisson Process Simulation Using R Shiny

This repository contains an interactive R Shiny application that simulates and visualizes the compound Poisson process:

$$
S(t) = X_1 + X_2 + \cdots + X_{N(t)}.
$$

where:

- \(N(t)\) is a Poisson process with rate \(\lambda\)
- \(X_i\) are i.i.d. exponential(\(\mu\)) random variables
- \(N(t)\) and \(X_i\) are independent

The project derives the theoretical distribution of \(S(t)\), simulates the process numerically, and visualizes its behavior with a dynamic Shiny dashboard.

---

#  Mathematical Derivation

## 1. Distribution of \(N(t)\)

If interarrival times are exponential(\(\lambda\)), then:

$$
N(t) \sim \text{Poisson}(\lambda t)
$$

---

## 2. Conditional distribution of \(S(t)\)

Given \(N(t)=n\):

- \(S(t)\) is the sum of \(n\) exponential(\(\mu\)) random variables
- Therefore:

$$
S(t)\mid N(t)=n \sim \text{Gamma}(n, \mu)
$$

(Shape = \(n\), Rate = \(\mu\))

---

## 3. Conditional distribution of \(S(t)\)

### At zero:

$$
P\big(S(t)=0\big) = e^{-\lambda t}
$$

### For \(s>0\):

$$
f_{S(t)}(s) =
e^{-(\lambda t + \mu s)}
\frac{\lambda t \mu}{\sqrt{\lambda t \mu s}}
I_1\!\left(2\sqrt{\lambda t \mu s}\right),
\qquad s>0
$$

where \(I_1(\cdot)\) is the modified Bessel function of the first kind.

---

## 4. Mean and Variance

$$
E[S(t)] = \frac{\lambda t}{\mu}
$$

$$
\mathrm{Var}(S(t)) = \frac{2\lambda t}{\mu^2}
$$

---

#  Project Objectives

- Derive distribution of the compound Poisson–Exponential process  
- Simulate \(S(t)\) numerically  
- Plot histograms at  
  - \(t = 10\)  
  - \(t = 100\)  
  - \(t = 1000\)  
  - \(t = 10000\)
- Build R Shiny app to visualize  
  - Histograms  
  - Custom time distribution  
  - Sample paths  
  - Sensitivity to \(\lambda\) and \(\mu\)

---

#  Features of the Shiny App

- Multi-panel histograms for four fixed times  
- Slider-based parameter tuning  
- Theoretical PDF overlays  
- Sample path visualization  
- Real-time sensitivity analysis

---

#  How to Run the App

### Install dependency
```r
install.packages("shiny")
```
---
##  Interpretation of Parameters

### **Effect of \(lambda\)**
- Higher \(lambda\) → more frequent jumps.
- Leads to larger values of \(S(t)\).
- Reduces the probability of no jumps:
  $$P(S(t)=0)=e^{-\lambda t}.$$

---

### **Effect of \(mu\)**
- Higher \(mu\) → smaller jump sizes.
- Decreases both the mean and variance of the process:
  $$E[S(t)] = \frac{\lambda t}{\mu}, \qquad \mathrm{Var}(S(t)) = \frac{2\lambda t}{\mu^2}.$$

---

### **Effect of \(t\)**
- Both mean and variance grow **linearly** in \(t\).
- By the Central Limit Theorem, for large \(t\):
  $$S(t) \approx 
  \mathcal{N}\!\left(
    \frac{\lambda t}{\mu},\;
    \frac{2\lambda t}{\mu^2}
  \right).$$

---
