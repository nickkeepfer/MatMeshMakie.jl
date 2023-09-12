using GLMakie
using GeometryBasics

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

    # Check if OBJ file exists
    if !isfile(asset_obj)
        @error "OBJ file not found: $asset_obj"
        return
    end

    # Initialize default material
    default_material = MtlMaterial()

    # Issue a warning if no MTL file is provided
    if isempty(asset_mtl)
        @warn "No MTL file provided. Using default material."
        materials = Dict("default_material" => default_material)
    else
        # Check if MTL file exists
        if !isfile(asset_mtl)
            @error "MTL file not found: $asset_mtl"
            return
        end
        materials = readMtlFile(asset_mtl) 
    end

    # Figure
    fig = Figure(resolution=(1920, 1080))

    # Lighting
    pl = PointLight(Point3f(100, 100, 100), RGBf(0.1, 0.1, 0.1))  # Brighter point light
    al = AmbientLight(RGBf(0.3, 0.3, 0.3))  # Brighter ambient light

    # Scene definition
    lscene = LScene(fig[1, 1], show_axis=true, scenekw=(lights=[pl, al],))

    asset_dir = joinpath(dirname(asset_obj),"Textures")

    # Load mesh and materials
    obj_mesh = FileIO.load(asset_obj)
    face_materials = get_face_materials(asset_obj) 

    # If no MTL file is provided, use default material for all faces
    if isempty(asset_mtl)
        face_materials .= "default_material"
    end

    # Split mesh by material
    material_mesh_dict = split_mesh_by_material(obj_mesh, face_materials) 

    # When loading textures, prepend the directory path
    for (material_name, sub_mesh_faces) in material_mesh_dict
        sub_mesh = GeometryBasics.Mesh(GeometryBasics.coordinates(obj_mesh), sub_mesh_faces)
        material_properties = get_material_properties(asset_mtl, material_name, materials) 

        # Load textures if available
        ambient_texture = isempty(material_properties[:ambient_texture]) ? nothing : FileIO.load(joinpath(asset_dir, material_properties[:ambient_texture]))

        mesh!(lscene,
            sub_mesh,
            shading=true,
            color=ifelse(isnothing(ambient_texture), material_properties[:color], ambient_texture),  # Use material color if no texture is available
            ambient=material_properties[:ambient],
            diffuse=material_properties[:diffuse],
            specular=material_properties[:specular],
            shininess=material_properties[:shininess],
            alpha=material_properties[:alpha],
        )
    end

    display(fig)
end

function plot_obj_mtl(asset_obj::String, materials::Vector{MtlMaterial})

    # Check if OBJ file exists
    if !isfile(asset_obj)
        @error "OBJ file not found: $asset_obj"
        return
    end

    # Figure
    fig = Figure(resolution=(1920, 1080))

    # Lighting
    pl = PointLight(Point3f(100, 100, 100), RGBf(0.1, 0.1, 0.1))  # Brighter point light
    al = AmbientLight(RGBf(0.3, 0.3, 0.3))  # Brighter ambient light

    # Scene definition
    lscene = LScene(fig[1, 1], show_axis=true, scenekw=(lights=[pl, al],))

    asset_dir = joinpath(dirname(asset_obj),"Textures")

    # Load mesh and materials
    obj_mesh = FileIO.load(asset_obj)
    face_materials = get_face_materials(asset_obj)

    # Split mesh by material
    material_mesh_dict = split_mesh_by_material(obj_mesh, face_materials)

    # When loading textures, prepend the directory path
    for (material_name, sub_mesh_faces) in material_mesh_dict
        sub_mesh = GeometryBasics.Mesh(GeometryBasics.coordinates(obj_mesh), sub_mesh_faces)
        material_properties = get_material_properties("", material_name, materials)

        # Load textures if available
        ambient_texture = isempty(material_properties[:ambient_texture]) ? nothing : FileIO.load(joinpath(asset_dir, material_properties[:ambient_texture]))

        mesh!(lscene,
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

    display(fig)
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
