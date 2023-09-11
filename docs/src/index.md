@meta
CurrentModule = MatMeshMakie

# MatMeshMakie

Documentation for [MatMeshMakie](https://github.com/nickkeepfer/MatMeshMakie.jl).

## Introduction

`MatMeshMakie.jl` is a Julia package designed for working with OBJ and MTL files, providing functionalities for parsing, manipulating, and visualizing 3D models and their associated materials.

## Features

- Parse OBJ files to extract vertex, normal, and texture information.
- Read MTL files to obtain material properties like ambient, diffuse, and specular colors.
- Visualize 3D models with associated materials.
- Support for texture mapping.

## Installation

To install `MatMeshMakie.jl`, run the following command in the Julia REPL:

```julia
] add MatMeshMakie
```

## Quick Start

Here's a quick example to get you started:

```julia
using MatMeshMakie

# Parse an OBJ file
obj_data = readObjFile("path/to/your/file.obj")

# Parse the associated MTL file
mtl_data = readMtlFile("path/to/your/file.mtl")

# Visualize the 3D model with materials
plot_obj_mtl("path/to/your/file.obj", "path/to/your/file.mtl")
```

## Table of Contents

- [Introduction](introduction.md)
- [Installation](installation.md)
- [API Reference](api_reference.md)
- [Examples](examples.md)

## Index
```@index
```

# API
```@autodocs
Modules = [MatMeshMakie]
```

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/nickkeepfer/MatMeshMakie.jl/blob/main/LICENSE) file for details.
