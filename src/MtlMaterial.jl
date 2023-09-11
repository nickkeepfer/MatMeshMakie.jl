using GeometryBasics

"""
    MtlMaterial

A mutable struct representing a material in MTL format.

# Fields

- `name::String`: The name of the material.
- `ambient::Vec3f`: The ambient color of the material.
- `specular::Vec3f`: The specular color of the material.
- `diffuse::Vec3f`: The diffuse color of the material.
- `transmission_filter::Vec3f`: The transmission filter of the material.
- `illum::Int`: The illumination model to use.
- `dissolve::Float32`: The dissolve factor (opacity).
- `specular_exponent::Float32`: The specular exponent for the Phong specular model.
- `ambient_texture::String`: The ambient texture map.
- `specular_texture::String`: The specular texture map.
- `diffuse_texture::String`: The diffuse texture map.
- `reflection_texture::String`: The reflection texture map.
- `bump_map::String`: The bump map.
- `transparency::Float32`: The transparency of the material.
- `optical_density::Float32`: The optical density for the surface.
- `emissive::Vec3f`: The emissive color of the material.
"""
mutable struct MtlMaterial
    name::String
    ambient::Vec3f
    specular::Vec3f
    diffuse::Vec3f
    transmission_filter::Vec3f
    illum::Int
    dissolve::Float32
    specular_exponent::Float32
    ambient_texture::String
    specular_texture::String
    diffuse_texture::String
    reflection_texture::String
    bump_map::String
    transparency::Float32
    optical_density::Float32
    emissive::Vec3f
end

"""
    MtlMaterial()

Constructor function for `MtlMaterial`. Initializes all fields to reasonable default values.

# Returns

- `MtlMaterial`: A new `MtlMaterial` object with all fields set to default values.

# Default Values

- `name`: "default_material"
- `ambient`: Vec3f(0.2, 0.2, 0.2)
- `specular`: Vec3f(1.0, 1.0, 1.0)
- `diffuse`: Vec3f(0.8, 0.8, 0.8)
- `transmission_filter`: Vec3f(1.0, 1.0, 1.0)
- `illum`: 2
- `dissolve`: 1.0
- `specular_exponent`: 10.0
- `ambient_texture`: ""
- `specular_texture`: ""
- `diffuse_texture`: ""
- `reflection_texture`: ""
- `bump_map`: ""
- `transparency`: 0.0
- `optical_density`: 1.0
- `emissive`: Vec3f(0.0, 0.0, 0.0)

# Examples

```julia
mtl = MtlMaterial()
```

"""
function MtlMaterial()
    return MtlMaterial(
        "default_material",  # Name
        Vec3f(0.2, 0.2, 0.2),  # Ambient color
        Vec3f(1.0, 1.0, 1.0),  # Specular color
        Vec3f(0.8, 0.8, 0.8),  # Diffuse color
        Vec3f(1.0, 1.0, 1.0),  # Transmission filter
        2,  # Illumination model
        1.0f0,  # Dissolve factor (opacity)
        10.0f0,  # Specular exponent
        "",  # Ambient texture map
        "",  # Specular texture map
        "",  # Diffuse texture map
        "",  # Reflection texture map
        "",  # Bump map
        0.0f0,  # Transparency
        1.0f0,  # Optical density
        Vec3f(0.0, 0.0, 0.0)  # Emissive color
    )
end