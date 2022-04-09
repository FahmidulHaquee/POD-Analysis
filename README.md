# Proper Orthogonal Decomposition Applied to PIV Fluid Data

## Executive Summary

This repo details the application of an unsupervised machine learning technique to a dataset containing velocity data at over 4000 locations on a stirred-tank reactor. The fluid system under study is water in a single-phase rotated using a 6-bladed Rushton turbine impeller. The dataset was acquired using 2D Particle Image Velocimetry. The Proper Orthogonal Decomposition is applied to the dataset to uncover dominant coherent structures which exist in the flow. The computational approach taken on MATLAB is discussed, with each step of the methodology explain for its purpose. The POD modes, which relate to the dominant patterns in the flow, are visualised in the results. A discussion of the results follows to better understand the physical interpretation of the modes derived, and comparisons are made with sources from literature to support findings and acquire deeper insights. 

## Table of Contents

- [Introduction](#introduction)
- [POD-Overview](#pod-overview)
- [POD-Algorithm](#pod-algorithm)
- [Results](#results)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Introduction

This project describes the application of the Proper Orthogonal Decomposition (POD) technique to a fluid data representing a stirred-tank reactor system. The [POD](https://en.wikipedia.org/wiki/Proper_orthogonal_decomposition) is an unsupervised machine learning technique which looks to extract the dominant pattern present in a physical field.
In the context of this project, where

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
