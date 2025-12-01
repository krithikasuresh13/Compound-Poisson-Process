# Compound Poisson Process with Exponential Jumps

This repository contains an **interactive R Shiny application** for simulating and visualizing the compound Poisson process

$$
S(t) = \sum_{i=1}^{N(t)} X_i,
$$

where  
- \( N(t) \sim \text{Poisson}(\lambda t) \) (exponential interarrival times), and  
- \( X_i \overset{\text{iid}}{\sim} \text{Exponential}(\mu) \).  

The app includes derivations, theoretical overlays, parameter sensitivity controls, and multi-time visualizations.

---

## Features

- Four-panel simulation plots for  
  **t = 10, 100, 1000, 10000**
- Adjustable parameters  
  - Arrival rate \( \lambda \)  
  - Jump rate \( \mu \)  
  - Number of simulations  
- Optional theoretical PDF overlay
- Full mathematical derivation included (Laplace transform, MGF, mean/variance, Bessel-form PDF)
- Normal approximation for large \( \lambda t \)
- Clean UI with interactive response

---

##  How to Run the App

### **1. Install required package**

```r
install.packages("shiny")
