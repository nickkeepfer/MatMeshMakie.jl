using GLMakie
using GeometryBasics

"""
    plot_mesh_with_materials(mesh::GeometryBasics.Mesh, materials::Dict, asset_mtl::String, asset_dir::String)

Helper function to plot a mesh with its associated materials.

# Arguments
- `mesh::GeometryBasics.Mesh`: The mesh object to plot.
- `materials::Dict`: Dictionary containing material properties.
- `asset_mtl::String`: The path to the MTL file (optional).
- `asset_dir::String`: The directory where textures are stored.

# Output
- A plot is displayed showing the 3D object with its associated materials.
"""
function plot_mesh_with_materials(mesh::GeometryBasics.Mesh, materials::Dict, asset_mtl::String, asset_dir::String)
    fig = Figure(resolution=(1920, 1080))
    pl = PointLight(Point3f(100, 100, 100), RGBf(0.1, 0.1, 0.1))
    al = AmbientLight(RGBf(0.3, 0.3, 0.3))
    lscene = LScene(fig[1, 1], show_axis=true, scenekw=(lights=[pl, al],))

    face_materials = get_face_materials(mesh)
    material_mesh_dict = split_mesh_by_material(mesh, face_materials)

    for (material_name, sub_mesh_faces) in material_mesh_dict
        sub_mesh = GeometryBasics.Mesh(GeometryBasics.coordinates(mesh), sub_mesh_faces)
        material_properties = get_material_properties(asset_mtl, material_name, materials)
        ambient_texture = isempty(material_properties[:ambient_texture]) ? nothing : FileIO.load(joinpath(asset_dir, material_properties[:ambient_texture]))

        mesh!(lscene, sub_mesh, shading=true, color=ifelse(isnothing(ambient_texture), material_properties[:color], ambient_texture),
              ambient=material_properties[:ambient], diffuse=material_properties[:diffuse], specular=material_properties[:specular],
              shininess=material_properties[:shininess], alpha=material_properties[:alpha])
    end

    display(fig)
end

"""
    plot_obj_mtl(asset_obj::String, asset_mtl::String="")

Plots an OBJ file with its associated MTL file.

# Arguments
- `asset_obj::String`: The path to the OBJ file.
- `asset_mtl::String`: The path to the MTL file (optional).

# Output
- A plot is displayed showing the 3D object with its associated materials.
"""
function plot_obj_mtl(asset_obj::String, asset_mtl::String="")
    if !isfile(asset_obj)
        @error "OBJ file not found: $asset_obj"
        return
    end

    materials = isempty(asset_mtl) ? Dict("default_material" => MtlMaterial()) : readMtlFile(asset_mtl)
    asset_dir = joinpath(dirname(asset_obj), "Textures")
    mesh = FileIO.load(asset_obj)

    plot_mesh_with_materials(mesh, materials, asset_mtl, asset_dir)
end

"""
    plot_obj_mtl(mesh::GeometryBasics.Mesh, asset_mtl::String="")

Plots a mesh object with its associated MTL file.

# Arguments
- `mesh::GeometryBasics.Mesh`: The mesh object to plot.
- `asset_mtl::String`: The path to the MTL file (optional).

# Output
- A plot is displayed showing the 3D object with its associated materials.
"""
function plot_obj_mtl(mesh::GeometryBasics.Mesh, asset_mtl::String="")
    materials = isempty(asset_mtl) ? Dict("default_material" => MtlMaterial()) : readMtlFile(asset_mtl)
    asset_dir = "path/to/Textures"  # Define or pass this as needed

    plot_mesh_with_materials(mesh, materials, asset_mtl, asset_dir)
end


"""
    plot_submeshes(submesh_material_dict::OrderedDict{String, Tuple{GeometryBasics.Mesh, Dict{Symbol, Any}}}, asset_dir::String; texture_dir::Union{String, Nothing}=nothing, lscene::Union{LScene, Nothing}=nothing)

Plots sub-meshes with their associated materials.

# Arguments
- `submesh_material_dict::OrderedDict{String, Tuple{GeometryBasics.Mesh, Dict{Symbol, Any}}}`: An ordered dictionary containing sub-meshes and their associated material properties.
- `asset_dir::String`: The directory containing the asset files.
- `texture_dir::Union{String, Nothing}`: Optional directory containing texture files. Defaults to `asset_dir`.
- `lscene::Union{LScene, Nothing}`: Optional LScene to plot into. If not provided, a new LScene is created.

# Output
- A plot is displayed showing the 3D sub-meshes with their associated materials.
- Returns the `LScene` used for plotting.
"""
function plot_submeshes(submesh_material_dict::OrderedDict{String, Tuple{GeometryBasics.Mesh, Dict{Symbol, Any}}}, asset_dir::String; texture_dir::Union{String, Nothing}=nothing, lscene::Union{LScene, Nothing}=nothing)
    # Set texture directory to asset directory if not provided
    texture_dir = isnothing(texture_dir) ? asset_dir : texture_dir
    
    # Create a new LScene if not provided
    if isnothing(lscene)
        fig = Figure(resolution=(1920, 1080))
        pl = PointLight(Point3f(100, 100, 100), RGBf(0.1, 0.1, 0.1))  # Point light
        al = AmbientLight(RGBf(0.3, 0.3, 0.3))  # Ambient light
        lscene = LScene(fig[1, 1], show_axis=false, scenekw=(lights=[pl, al],))
    end
    
    for (material_name, (sub_mesh, material_properties)) in submesh_material_dict
        # Check if a diffuse texture is available
        ambient_texture_path = material_properties[:ambient_texture]
        ambient_texture = isempty(ambient_texture_path) ? nothing : FileIO.load(joinpath(texture_dir, ambient_texture_path))
        # Plot the mesh with material properties
        mesh!(
            lscene, 
            sub_mesh, 
            shading=true, 
            color=ifelse(isnothing(ambient_texture), material_properties[:color], ambient_texture),
            ambient=material_properties[:ambient],
            diffuse=material_properties[:diffuse],
            specular=material_properties[:specular],
            shininess=material_properties[:shininess],
            alpha=material_properties[:alpha],
        )
    end   
    return lscene
end
