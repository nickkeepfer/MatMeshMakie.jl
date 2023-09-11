# MatMeshMakie

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://nickkeepfer.github.io/MatMeshMakie.jl/)
[![Build Status](https://github.com/nickkeepfer/MatMeshMakie.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/nickkeepfer/MatMeshMakie.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/nickkeepfer/MatMeshMakie.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/nickkeepfer/MatMeshMakie.jl)

## Overview

`MatMeshMakie.jl` is a Julia package for rendering 3D meshes with material properties specified in OBJ and MTL files. It provides functions for loading, parsing, and visualizing 3D models with various material properties as defined in the .mtl file, like ambient color, diffuse color, and textures. The meshes are visualised with [GLMakie](https://docs.makie.org/stable/). 

## Installation

To install `MatMeshMakie.jl`, run the following command in your Julia REPL:

```julia
] add https://github.com/nickkeepfer/MatMeshMakie.jl.git
```

## Usage

Here's a simple example to get started:
(dinosaur mesh from: [CGTrader](https://www.cgtrader.com/items/4627898/download-page))
```julia
using MatMeshMakie

# Load an OBJ file and its associated MTL file
obj_file = "path/to/your.obj"
mtl_file = "path/to/your.mtl"

# Parse the OBJ and MTL files
materials = readMtlFile(mtl_file)

# Render the OBJ file with materials
plot_obj_mtl(obj_file, mtl_file)

```
![Example](https://github.com/nickkeepfer/MatMeshMakie.jl/assets/45045579/2db7a25c-d31a-4668-9a18-50e1666e80df)

For more detailed usage, please refer to the [documentation](https://nickkeepfer.github.io/MatMeshMakie.jl/stable).

## Features

- Load and parse OBJ and MTL files
- Support for textures
