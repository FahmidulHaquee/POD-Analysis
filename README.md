# Proper Orthogonal Decomposition Applied to PIV Fluid Data

## Executive Summary

This repository details the application of an unsupervised machine learning technique to a dataset containing velocity data at over 4000 locations on a stirred-tank reactor. The fluid system under study is water in a single-phase rotated using a 6-bladed Rushton turbine impeller. The dataset was acquired using 2D Particle Image Velocimetry. The Proper Orthogonal Decomposition is applied to the dataset to uncover dominant coherent structures which exist in the flow. The computational approach taken on MATLAB is discussed, with each step of the methodology explain for its purpose. The POD modes, which relate to the dominant patterns in the flow, are visualised in the results. A discussion of the results follows to better understand the physical interpretation of the modes derived, and comparisons are made with sources from literature to support findings and acquire deeper insights. 

## Table of Contents

- [Setup](#setup)
- [Data](#data)
- [Introduction](#introduction)
- [POD Algorithm](#pod algorithm)
- [Results](#results)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Setup

To reproduce this analysis, please ensure you have the latest version of MATLAB installed on your PC. Clone this repository to your local machine and then navigate to the Pre-processing folder in MATLAB and run the Process_Raw_PIV.m file. This will parse the PIV data from a .vec file to a format which can be processed by MATLAB. The pertinent data will be stored in variables that will remain in memory until you clear them. Run the pre-processing script file using the following command:

``` 
Process_Raw_PIV.m
```

There will be a number of prompts for the user to fill. After these inputs, the script will take about 10 minutes to run. This will vary based on the specifications of your machine. The user will respond to the prompts depending on the data file they are using. The data for this project is scattered across multiple files for different runs of the PIV experiement (varying RPM and clearance height). 

## Data

The data can be found in the data folder of this project. It has been parsed and prepared for processing for the user. The data can be loaded in manually by opening the .mat file within the MATLAB interface. There are numerous files which represent different runs of the PIV experiment, varying in impeller speed and clearance height. 

## Introduction

This project describes the application of the [Proper Orthogonal Decomposition (POD)](https://en.wikipedia.org/wiki/Proper_orthogonal_decomposition)  technique to a fluid data representing a stirred-tank reactor system. The POD is an unsupervised machine learning technique which looks to extract the dominant pattern present in the stirred-tank system. The POD analysis may potentially provide a more modern and alternative way of modelling the mixing behaviour in fluid systems to [Computation Fluid Dynamics (CFD)](https://en.wikipedia.org/wiki/Computational_fluid_dynamics), which uses numerical analysis and computation to predict the state of a system given some initial state and boundaries. 

## Problem Statement

A problem in chemical engineering and fluid mechanics is being able to accurately model the behaviour of a fluid system. The Navier-Stokes equations are a set of differential equations that describe fluid motion of a viscous substance. Although these equations have been developed from first principles using physical laws, it is difficult to model a system using these equations. For most fluid systems, there is an extraordinary number of particles present, thus requiring a computer to calculate the solution for a system. 

Computational Fluid Dynamics attempts to address this problem by making simplifying assumptions to the first principles approach, which can help produce approximate yet more applicable and pracitcal solutions from the Navier-Stokes equations. Usually, the analytical approach is favoured because once a basis is established on how to model a generic system, it can be extrapolated to specific systems. The issue with CFD though is that these models are built semi-empirically, meaning that some experimental data of a similar system informs the governing equations and model for any particular system. There is uncertainty in how similar these systems may be. 

In the context of this project, the physical system studied is the 2D cross section of a stirred-tank vessel, which contains only water. The stirred-tank is the simplest of units of chemical engineering and is commonplace in any industrial site, hence why this system is studied.

[Diagram]

The dataset is in this project represents the x and y-velocity of fluid at ~4,600 locations on a

It is related to the more widely known Principal Component Analysis (PCA) from the field of statistics, which looks to reduce a dataset with many dimensions to fewer, more important dimensions.

With PCA, each data point is projected with only the first few principal components to obtain lower-dimensional whilst preserving as much of the data's variation, in terms of range, variance and standard deviation.

The POD technique is applied to a PIV dataset to extract dominant patters in the fluid motion

## POD-Overview

## POD-Algorithm

## Results

## License

The license for the code can be accessed [here](LICENSE.md)

## Acknowledgements

I would like to thank [Dr. Alberini](https://www.linkedin.com/in/federico-alberini-advance-measurement-research/) for giving his time and effort during weekly mentoring sessions, providing clear and comprehensive explanations of the research problem. Also, I would like to thank [Igor Carvalho](https://www.linkedin.com/in/igorscarvalho/) for his great time and effort in carrying out the PIV experiments, as well as for assisting me with MATLAB programming. 

## References 

[Navier-Stokes Equations](https://en.wikipedia.org/wiki/Navier%E2%80%93Stokes_equations)
