# mouse_xenograft_gbm_simulation
Code associated with paper "Anatomically aware simulation of patient-specific glioblastoma xenografts"


# Matlab code for *"Anatomically aware simulation of patient-specific glioblastoma xenografts"*

## Description
This repository contains MATLAB code and data used in the publication:  
*"Anatomically aware simulation of patient-specific glioblastoma xenografts"*  
The project implements an agent-based stochastic model of migrating and proliferating GBM cells inside a mouse brain domain.

## Contents
**Scripts**
- `demo_simulation.m`: Script to run a simulation. Saves the final configuration and parameters in "simulation/simdata" and "simulations/parameters".
- `compare.m`: Script that takes a simulation and compares against tumor data.

**Support functions**
- `SimulationFunction.m`: Function for running a simulation. Used inside demo_simulation.
- `create_comparison_image.m`: Support function that helps in creating a visualization.
- `create_slice.m`: Support function that helps in creating slice of the simulated brain.


**Data**
- `combined_brain.mat/`: .mat file containing the brain domain information. This is a merged brain containing both white matter (WM) and vasculature (BV).


- `README.md`: Documentation for the repository.

## Getting Started
1. Clone this repository:
   ```bash
   git clone https://github.com/maadam-123/mouse_xenograft_gbm_simulation.git
