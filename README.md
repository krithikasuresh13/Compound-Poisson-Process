# Compound Poisson Process with Exponential Jumps

**Interactive R Shiny app** for simulating and visualizing the compound Poisson process

This project studies the compound Poisson process

\[
S(t) = \sum_{i=1}^{N(t)} X_i,
\]

where  
- \( N(t) \sim \text{Poisson}(\lambda t) \) represents the number of arrivals by time \(t\) (i.e., exponential interarrival times), and  
- \( X_i \overset{\text{iid}}{\sim} \text{Exponential}(\mu) \) are independent jump sizes.
- 
---

## Features

- Four-panel histograms for \(t = 10, 100, 1000, 10000\).  
- Simulation controls for arrival rate \(\lambda\), jump rate \(\mu\), and number of simulations.  
- Theoretical continuous density overlay (Bessel-I form) and normal approximation for large \(\lambda t\).  
- Derivation tab with Laplace transform, MGF, mean & variance, and short interpretation.  
- Export-ready screenshots and ready-to-deploy Shiny app.

---

##  To start (run locally)

1. Install R and RStudio (if not already installed).  
2. From R or RStudio install required packages:

```r
install.packages("shiny")
