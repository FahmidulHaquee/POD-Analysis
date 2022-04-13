# Proper Orthogonal Decomposition Applied to PIV Fluid Data

## Abstract

This repository details the application of an unsupervised machine learning technique to a dataset containing velocity data at over 4000 locations on a stirred-tank reactor. The fluid system under study is water in a single-phase rotated using a 6-bladed Rushton turbine impeller. The dataset was acquired using 2D Particle Image Velocimetry. The Proper Orthogonal Decomposition is applied to the dataset to uncover dominant coherent structures which exist in the flow. The computational approach taken on MATLAB is discussed, with each step of the methodology explain for its purpose. The POD modes, which relate to the dominant patterns in the flow, are visualised in the results. A discussion of the results follows to better understand the physical interpretation of the modes derived, and comparisons are made with sources from literature to support findings and acquire deeper insights. 

## Table of Contents

- [Setup](#setup)
- [Data](#data)
- [Introduction](#introduction)
- [Problem Statement](#problem-statement)
- [Modelling a Fluid System](#modelling-a-fluid-system)
- [POD Algorithm](#pod-algorithm)
    - [Compute Snapshot Matrix](#compute-snapshot-matrix)
    - [Subtract Temporal Mean](#subtract-temporal-mean)
    - [Calculate Covariance](#calculate-covariance)
    - [Performing Eigendecomposition](#performing-eigendecomposition)
    - [Removing NaNs](#removing-nans)
    - [Returning NaNs](#returning-nans)
    - [Retaining High TKE Modes](#retaining=high-tke-modes)
    - [Plotting Modes](#plotting-modes)
- [Results](#results)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Contact](#contact)

## Setup

To reproduce this analysis, please ensure you have the latest version of MATLAB installed on your PC. Clone this repository to your local machine and then navigate to the Pre-processing folder in MATLAB and run the Process_Raw_PIV.m file. This will parse the PIV data from a .vec file to a format which can be processed by MATLAB. The pertinent data will be stored in variables that will remain in memory until you clear them. Run the pre-processing script file using the following command:

``` 
Process_Raw_PIV.m
```

There will be a number of prompts for the user to fill. After these inputs, the script will take about 10 minutes to run. This will vary based on the specifications of your machine. The user will respond to the prompts depending on the data file they are using. The data for this project is scattered across multiple files for different runs of the PIV experiement (varying RPM and clearance height). 

## Data

The data can be found in the data folder of this project. It has been parsed and prepared for processing for the user. The data can be loaded in manually by opening the .mat file within the MATLAB interface. There are numerous files which represent different runs of the PIV experiment, varying in impeller speed and clearance height. 

## Introduction

This project describes the application of the [Proper Orthogonal Decomposition (POD)](https://en.wikipedia.org/wiki/Proper_orthogonal_decomposition) technique to fluid data representing the velocity at 4,000 locations on a stirred-tank reactor. The POD is an unsupervised machine learning technique which looks to extract the dominant pattern present in the stirred-tank system. The POD analysis may potentially provide a more modern and alternative way of modelling the mixing behaviour in fluid systems to [Computation Fluid Dynamics (CFD)](https://en.wikipedia.org/wiki/Computational_fluid_dynamics), which uses numerical analysis and computation to predict the state of a system given some initial state and boundaries. 

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
% Initialise X snapshot matrix
X = [];

% Extract x,y velocity from CellTableArray containing all our data 
for i = 1:height(CellTableArray_100)
    T = CellTableArray_100{i,1};
    
    % extract x velocity
    x_vel = T(:,{'inst vel x'});
    x_vel = table2array(x_vel);
  
    % extract y velocity
    y_vel = T(:,{'inst vel y'});
    y_vel = table2array(y_vel);
        
    % calculate overall velociy
    vel = (x_vel.^2 + y_vel.^2).^(1/2);
        
    % take the column and enter into matrix
    X = horzcat(X,vel);
     
end
```

### Subtract Temporal Mean

For the system, we are only interested in the fluctuations in velocity. Therefore, the average mean with time is calculated for each location, and then subtracted from each data point for that location. After finding the most relevant features, the temporal mean can be added back onto the data points for each point in space and time to reconstruct a low-order model. A low-order model..

```
for i = 1:height(T)
    temp_mean_x = T(i,{'avg vel x'}); % Temproal Average x velocity for 
    temp_mean_x = table2array(temp_mean_x);
    temp_mean_y = T(i,{'avg vel y'});
    temp_mean_y = table2array(temp_mean_y);
    temp_mean = (temp_mean_x.^2 + temp_mean_y.^2).^(1/2);
    X(:,i) = X(:,i) - temp_mean;
end
```

### Calculate Covariance

In statistics, covaraince is defined as the joint probability of two variables (think postive, negative and neutral correlation). The covariance between velocities at different points on the tank is an interesting metric because it describes the correlation between data points. If for two points in close proximity, the velocity signals tend to follow each other, or move out-of-sync with each other, this implies that the velocity at these two points are correlated with each other. 

The dataset contains NaNs and when comptuting the covariance of a matrix containing NaNs, an error is thrown. Thus, the built-in MATLAB function cannot compute the covariance of the snapshot matrix. Instead, a variation of the covariance function was used, wherein NaNs are simply replaced by 0 to enable the computation. This function was taken from this [source](http://pordlabs.ucsd.edu/matlab/nan.htm).

```
function [C]=nancov(A,B)

% Program to compute a covariance matrix ignoring NaNs
%
% C = nancov(A,B)
%
% Nancov determines A*B whilst ignoring NaNs 
% NaNs are replaced by 0
% Each element, C(i,j), normalized by the number of 
% non-NaN values in the vector product A(i,:)*B(:,j).
%
% A - LHS matrix 
% B - RHS matrix 
% C - Covariance matrix

N_matA=~isnan(A); % Counter matrix
N_matB=~isnan(B);

A(isnan(A))=0; % Replace NaNs in A,B, and counter matrices
B(isnan(B))=0; % with zeros

Npts=N_matA*N_matB;
C=(A*B)./Npts;

end 
```
The covariance of the snapshot matrix is the computed as follows:

```
[C]=nancov(X',X);
```

### Removing NaNs

Before substracting the temporal mean and calculating the covariace, the NaNs present in the data are removed. There are NaNs deliberately introduced by the data, to reflect the position of the impeller and shaft, and NaNs that are unintentionally introduced as a consequence of errors associated with the experiment and processing the data. For now, we are focused on the NaNs that are deliberately introduced, and do not require them when performing the decomposition. The NaNs that are due to experimental errors will remain in the data. When calculating the covariance, a variation of the in-built MATLAB function is written and shown to overcome the issue of NaNs preventing relevant calculations. 

```
% 3. Extract and Remove NaN rows
% Copy mean table, instead of overwrite
T = meanTable_100;

% Add index column
T.Index = (1:height(T)).';

% Re order columns
T = T(:, [end, 1:end-1]);

% Extract rows where CHC == -2 i.e. values are NaN
Delete_NaNs = T.CHC == -2; 

% Extract NaN rows
NaNs_rows =  T(Delete_NaNs,:);

% Removes columns where CHC = -2
X(:,Delete_NaNs) = [];

% Removes rows where CHC = -2
T(Delete_NaNs,:) = []; 
```

### Returning NaNs

After calculating the POD modes, the NaNs which were extracted are now returned to the modes. Since the index column are consistent between both tables, it is relatively simple procedure to insert the NaNs back into the output.

```
% 8. Insert NaN rows back into POD Modes 

NaNs_rows = table2array(NaNs_rows);
POD_modes = table2array(POD_modes);
POD_modes = vertcat(POD_modes,NaNs_rows);
POD_modes = array2table(POD_modes,...
    'VariableNames',{'Index','x_loc','y_loc','Mode1','Mode2','Mode3'});

% Sort based on index
POD_modes = sortrows(POD_modes,'Index','ascend');
```

### Retaining High TKE Modes

[Turbulence kinetic energy (TKE)](https://en.wikipedia.org/wiki/Turbulence_kinetic_energy) is defined as the kinetic energy per unit mass associated with eddies in turbulent flow. Modes can be associated with a number that describes how much that mode contributes to the total TKE. Modes with a higher TKE contribution can be considered to be physically significant, and may indicate the presence of a structure in the flow. Modes with a lower TKE contribution can be disregarded as insignificant. 

```
% 6. Plot Sigma Values

% Compute the fraction of total energy, 
E_frac  = (LAMBDA/sum(LAMBDA))*100;

% Take first 10 modes
ilam = sort(ilam);

% Mode # on x
% Sigma value on Y1
x = ilam;
y = E_frac;
figure
plot(x(1:10),y(1:10));
xlabel('Mode #') 
ylabel('%TKE') 
title('150 RPM - CT3 - Mode # against %TKE')

% 7. Extract Significant Modes
% From previous figure
% Determine how many pertitent modes

POD_modes = PHI(1:3,:); % first 3 modes
POD_modes = POD_modes'; % transpose

i_x_y = T(:,1:3); % all index, x and y locations
i_x_y = table2array(i_x_y); % array

% join arrays
POD_modes = horzcat(i_x_y,POD_modes);
POD_modes = array2table(POD_modes,...
    'VariableNames',{'Index','x_loc','y_loc','Mode1','Mode2','Mode3'});
```
## Plotting Modes

To provide a view of the modes with respect to the fluid system, a 2D contour plot is drawn, which essentially incorporates 3 dimensions: the x location, the y location and the velocity at each x-y pair.

```
% 9. Plot 2D contour plots for POD modes

x = table2array(POD_modes(:,2)); % x co-ordinates
y = table2array(POD_modes(:,3)); % y co-ordinates

n = 4; % corresponding to t =1. For mode 2 and mode 3, 
% use n = 5 and 6 respectively
z = table2array(POD_modes(:,n)); % Mode n

[xq,yq] = meshgrid(0:0.01:1,0:0.01:1);
vq = griddata(x,y,z,xq,yq,'cubic');
figure
contourf(xq,yq,vq,30,'edgecolor','none')
colormap(jet)
colorbar
xlabel('Normalised X') 
ylabel('Normalised Y') 
title('Mode n at t = 1, at 150 RPM - CT3 - With NaNs')

% The two figure windows will be overlapped
```

## Results

## License

The license for the code can be accessed [here](LICENSE.md)

## Acknowledgements

I would like to thank [Dr. Alberini](https://www.linkedin.com/in/federico-alberini-advance-measurement-research/) for giving his time and effort during weekly mentoring sessions, providing clear and comprehensive explanations of the research problem. Also, I would like to thank [Igor Carvalho](https://www.linkedin.com/in/igorscarvalho/) for his great time and effort in carrying out the PIV experiments, as well as for assisting me with MATLAB programming. 

## Contact

For more information, please feel free to reach out to me on [LinkedIn](https://www.linkedin.com/in/fahmidul-haque-b7a96b123/).
