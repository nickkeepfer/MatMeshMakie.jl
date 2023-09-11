# API Reference

This section provides a comprehensive list of all functions and types available in `MaterialMeshMakie`.

## Types

### `MtlMaterial`

```julia
struct MtlMaterial
    name::String
    ambient::Vec3f
    ...
end
```

Represents the properties of a material in the MTL format.

---

## Functions

### `readMtlFile`

```julia
readMtlFile(filepath::String)
```

Reads a `.mtl` file and returns a vector of `MtlMaterial`.

---

### `parseMtlColor`

```julia
parseMtlColor(s::String)
```

Parses a color from a string and returns it as a `Vec3f`.

---

### `plot_obj_mtl`

```julia
plot_obj_mtl(asset_obj, asset_mtl)
```

Plots an OBJ file with its associated MTL file.

---

### `get_material_properties`

```julia
get_material_properties(mtl_file::String, material_name::String, materials)
```

Returns a dictionary of material properties for a given material name.

---

### `get_face_materials`

```julia
get_face_materials(obj_filepath::String)
```

Returns a vector of material names associated with each face in the OBJ file.

---

### `split_mesh_by_material`

```julia
split_mesh_by_material(mesh, face_materials)
```

Splits a mesh into sub-meshes based on material.

---

### `get_submesh_material_properties`

```julia
get_submesh_material_properties(asset_obj::String, asset_mtl::String)
```

Returns an ordered dictionary containing sub-meshes and their associated material properties.

---

For more examples and use-cases, please refer to the [Examples](examples.md) section.
