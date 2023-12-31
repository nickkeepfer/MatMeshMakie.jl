# Examples

This page provides a few examples to help you get started with `MatMeshMakie`.

## Basic Usage

### Plotting a Simple Mesh

```julia
using MatMeshMakie
using FileIO

# Plot the mesh
plot_obj_mtl("example.obj")
```

### Adding Material Properties

```julia
using MatMeshMakie

# Plot mesh with materials
plot_obj_mtl("example.obj", "example.mtl")
```

## Advanced Usage

### Customizing Material Properties

```julia
using MatMeshMakie, GLMakie

# Load materials
materials = readMtlFile("example.mtl")

# Customize material properties
materials[1].ambient = Vec3f(0.2, 0.2, 0.2)

# Plot the mesh with customized materials
plot_obj_mtl("example.obj", materials)
```

### Splitting Mesh by Material

```julia
using MatMeshMakie

# Load mesh and materials
obj_mesh = FileIO.load("example.obj")
materials = readMtlFile("example.mtl")

# Split mesh by material
material_mesh_dict = split_mesh_by_material(obj_mesh, materials)

# Plot each sub-mesh
for (material_name, sub_mesh_faces) in material_mesh_dict
    plot_obj_mtl(sub_mesh_faces, material_name)
end
```

For more details, please refer to the [API Reference](api_reference.md).
