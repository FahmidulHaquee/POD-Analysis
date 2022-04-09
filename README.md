# Proper Orthogonal Decomposition Applied to PIV Fluid Data

## Executive Summary

This repository details the application of an unsupervised machine learning technique to a dataset containing velocity data at over 4000 locations on a stirred-tank reactor. The fluid system under study is water in a single-phase rotated using a 6-bladed Rushton turbine impeller. The dataset was acquired using 2D Particle Image Velocimetry. The Proper Orthogonal Decomposition is applied to the dataset to uncover dominant coherent structures which exist in the flow. The computational approach taken on MATLAB is discussed, with each step of the methodology explain for its purpose. The POD modes, which relate to the dominant patterns in the flow, are visualised in the results. A discussion of the results follows to better understand the physical interpretation of the modes derived, and comparisons are made with sources from literature to support findings and acquire deeper insights. 

## Table of Contents

- [Setup](#setup)
- [Data](#data)
- [Introduction](#introduction)
- [POD Algorithm](#pod-algorithm)
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

A problem in chemical engineering and fluid mechanics is being able to accurately model the mixing behaviour of a fluid system. It is important to understand the mixing behaiour of a fluid system because this can determine the bulk composition for a batch process or the product composition for a continuous process at any given time. This has important commercial applications because if the mixing behaviour is not investigated, not only may some reactant leave unreacted, some reactant may also back-react with the product, producing an off-spec output, lowering revenue and increasing costs.

## Modelling a Fluid System

The Navier-Stokes equations are a set of differential equations that describe fluid motion of a viscous substance. Although these equations have been developed from first principles using physical laws, it is difficult to model a system using these equations. For most fluid systems, there is an extraordinary number of particles present, thus requiring a computer to calculate the solution for a system. 

Computational Fluid Dynamics attempts to address this problem by making simplifying assumptions to the first principles approach, which can help produce approximate yet more applicable and pracitcal solutions from the Navier-Stokes equations. Usually, the analytical approach is favoured because once a basis is established on how to model a generic system, it can be extrapolated to specific systems. The issue with CFD though is that these models are built semi-empirically, meaning that some experimental data of a similar system informs the governing equations and model for any particular system. There is uncertainty in how similar these systems may be. 

[Machine learning](https://en.wikipedia.org/wiki/Machine_learning) algorithms provides an alternative means of characterising a fluid system. Machine learning involve self-teaching algorithms that learn through experience and data compute an output given some input to a model. Machine learning can be classed into 3 categories: supervised, unsupervised and reinforcement learning. Unsupervised learning is applied when the data is unlabelled, implying that the "features" which dictate the output of the model are not previously known. Once the features are known, supervised learning can be applied to build a classification/regression model for the system. For this research problem, it is not previously known to the researcher what features in this dataset are most important. Thus, unsupervised learning is desired for and applied to this context to uncover the important features which constitute this fluid flow.

There are a number of unsupervised learning techniques to find the most pertient features of a dataset. These include clustering, principal component analysis and k-means. The most relevant of them is the [Principal Component Analysis (PCA)](https://en.wikipedia.org/wiki/Principal_component_analysis) from the field of statistics, which looks to reduce a dataset with many dimensions to fewer, more important dimensions. In this case, there are many possible flows and fluctuations that contribute to the behaviour the system. Thus, the PCA can be applied to project every data point using only the pertinent features. If the newly modelled system captures most of the original information whilst using fewer dimensions/features than the original, then it can be said that these fewer features account for most of the behaviour of the system.

## POD Algorithm

The POD technique is applied to a PIV dataset to extract dominant patterns that resemble the bulk behaviour in the studied fluid system.  For further insight, an article by Weiss provides an excellent explanation through the use of a step-by-step example to provide phyiscal intuition on a complicated mathemtical process. In general, the POD computes the eigendecomposition of a covariance matrix. The covariance matrix 

### Compute Snapshot Matrix

The data has to arranged into a particular format before it can be fed into the POD algorithm. For every instance of time, the Nx by Ny flowfield has to be re-arranged into a 1 by Nx * Ny matrix, where Nx and Ny are the number of different x and y locations captured respectively. The following code achieves this:

```
```

### Subtract Temporal Mean

For the system, we are only interested in the fluctuations in velocity. Therefore, the average mean with time is calculated for each location, and then subtracted from each data point for that location. After finding the most relevant features, the temporal mean can be added back onto the data points for each point in space and time to reconstruct a low-order model. A low-order model 

```
```

### Calculate Covariance

The covariance between velocities at different points on the tank is an interesting metric because it describes the correlation between data points. For two points in close proximity, the velocity signals will not be identical but will tend to follow each other, as seen in the figure below. 

If we plot the velocity data for these points over time, an elipse can generally be observed. This implies that there is some correlation between these points in the turbulent flow.

```
```

### Removing NaNs

```
```

### Returning NaNs

```
```

### Retaining High TKE Modes

[Turbulence kinetic energy (TKE)](https://en.wikipedia.org/wiki/Turbulence_kinetic_energy)

```
```

## Results

## License

The license for the code can be accessed [here](LICENSE.md)

## Acknowledgements

I would like to thank [Dr. Alberini](https://www.linkedin.com/in/federico-alberini-advance-measurement-research/) for giving his time and effort during weekly mentoring sessions, providing clear and comprehensive explanations of the research problem. Also, I would like to thank [Igor Carvalho](https://www.linkedin.com/in/igorscarvalho/) for his great time and effort in carrying out the PIV experiments, as well as for assisting me with MATLAB programming. 
