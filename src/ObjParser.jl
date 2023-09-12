using GeometryBasics
using DataStructures

"""
    get_face_materials(obj_filepath::String)

Returns a vector of material names associated with each face in the OBJ file.

# Arguments
- `obj_filepath::String`: The path to the OBJ file.

# Returns
- `Vector{String}`: A vector containing the material names associated with each face.
"""
function get_face_materials(obj_filepath::String)
    face_materials = String[]  # To store the material associated with each face
    current_material = "default"  # Default material name

    open(obj_filepath, "r") do io
        for full_line in eachline(io)
            line = strip(chomp(full_line))

            if !startswith(line, "#") && !isempty(line)
                lines = split(line)
                command = popfirst!(lines)

                if "f" == command
                    # Associate the current material with this face
                    # Since each face is a quad, push the material twice to account for the two triangles
                    push!(face_materials, current_material)
                    push!(face_materials, current_material)
                elseif "usemtl" == command
                    # Update the current material
                    current_material = lines[1]
                end
            end
        end
    end

    return face_materials
end

function get_material_properties(material_name::String, materials::Vector{MtlMaterial})
    target_material_index = findfirst(m -> m.name == material_name, materials)
    material = isnothing(target_material_index) ? MtlMaterial() : materials[target_material_index]

    if isnothing(target_material_index)
        println("Material not found: $material_name")
    end

    return Dict(
        :color => RGB(material.ambient...),
        :ambient => Vec3f(material.ambient),
        :diffuse => Vec3f(material.diffuse),
        :specular => Vec3f(material.specular),
        :shininess => material.specular_exponent,
        :alpha => material.dissolve,
        :transmission_filter => Vec3f(material.transmission_filter),
        :illum => material.illum,
        :ambient_texture => material.ambient_texture,
        :diffuse_texture => material.diffuse_texture,
        :specular_texture => material.specular_texture,
        :reflection_texture => material.reflection_texture,
        :bump_map => material.bump_map,
        :transparency => material.transparency,
        :optical_density => material.optical_density,
        :emissive => Vec3f(material.emissive)
    )
end


# For Mesh object
function get_face_materials(mesh::GeometryBasics.Mesh)
    face_materials = String[]  # To store the material associated with each face
    current_material = "default"  # Default material name

    for face in GeometryBasics.faces(mesh)
        # Associate the current material with this face
        # Since each face is a triangle, push the material once
        push!(face_materials, current_material)
    end

    return face_materials
end

"""
    split_mesh_by_material(mesh, face_materials)

Splits a mesh into sub-meshes based on the material names associated with each face.

# Arguments
- `mesh`: The original mesh.
- `face_materials`: A vector containing the material names associated with each face.

# Returns
- `OrderedDict{String, Vector{GeometryBasics.NgonFace{3, OffsetInteger{-1, UInt32}}}}`: An ordered dictionary where the keys are material names and the values are vectors of faces associated with each material.
"""
function split_mesh_by_material(mesh, face_materials)
    # Initialize a dictionary to store sub-meshes
    material_mesh_dict = OrderedDict{String, Vector{GeometryBasics.NgonFace{3, OffsetInteger{-1, UInt32}}}}()

    last_used_material = "default"  # Initialize with a default material

    # Loop through the faces to split the mesh by material
    for (face_idx, face) in enumerate(GeometryBasics.faces(mesh))
        # Use the last used material if this face doesn't have an associated material
        material_name = face_idx <= length(face_materials) ? face_materials[face_idx] : last_used_material

        # Update the last used material
        last_used_material = material_name

        # Initialize sub-mesh if not already present
        if !haskey(material_mesh_dict, material_name)
            material_mesh_dict[material_name] = []
        end

        # Add the face to the corresponding sub-mesh
        push!(material_mesh_dict[material_name], face)
    end

    return material_mesh_dict
end

"""
    get_submesh_material_properties(asset_obj::String, asset_mtl::String)

Returns an ordered dictionary containing sub-meshes and their associated material properties.

# Arguments
- `asset_obj::String`: The path to the OBJ file.
- `asset_mtl::String`: The path to the MTL file.

# Returns
- `OrderedDict{String, Tuple{GeometryBasics.Mesh, Dict{Symbol, Any}}}`: An ordered dictionary where the keys are material names and the values are tuples containing the sub-mesh and a dictionary of material properties.
"""
function get_submesh_material_properties(asset_obj::String, asset_mtl::String)
    # Initialize the dictionary to store sub-meshes and material properties
    submesh_material_dict = OrderedDict{String, Tuple{GeometryBasics.Mesh, Dict{Symbol, Any}}}()

    # Load mesh and materials
    obj_mesh = FileIO.load(asset_obj)
    face_materials = get_face_materials(asset_obj)
    materials = readMtlFile(asset_mtl)

    # Split mesh by material
    material_mesh_dict = split_mesh_by_material(obj_mesh, face_materials)

    for (material_name, sub_mesh_faces) in material_mesh_dict
        # Create sub-mesh
        sub_mesh = GeometryBasics.Mesh(GeometryBasics.coordinates(obj_mesh), sub_mesh_faces)

        # Get material properties
        material_properties = get_material_properties(asset_mtl, material_name, materials)

        # Add sub-mesh and material properties to the dictionary
        submesh_material_dict[material_name] = (sub_mesh, material_properties)
    end

    return submesh_material_dict
end
