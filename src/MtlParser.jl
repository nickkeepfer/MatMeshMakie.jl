using GeometryBasics
using Colors
using DataStructures
using FileIO

"""
    readMtlFile(filepath::String)

Reads an MTL file and returns a vector of `MtlMaterial` objects.

# Arguments
- `filepath::String`: The path to the MTL file.

# Returns
- `Vector{MtlMaterial}`: A vector containing the parsed materials.
"""
function readMtlFile(filepath::String)
    open(filepath, "r") do io
        return readMtlFile(io)
    end
end

"""
    readMtlFile(io::IO; debug=false)

Reads an MTL file from an IO stream and returns a vector of `MtlMaterial` objects.

# Arguments
- `io::IO`: The IO stream to read from.
- `debug::Bool`: Whether to print debug information (default is `false`).

# Returns
- `Vector{MtlMaterial}`: A vector containing the parsed materials.
"""
function readMtlFile(io::IO; debug=false)
    materials = Vector{MtlMaterial}()
    while !eof(io)
        line = strip(chomp(readline(io)))
        if !startswith(line, "#") && !isempty(line)
            line_parts = split(line)
            command, remainder = line_parts[1], join(line_parts[2:end], " ")
            
            if command == "newmtl"
                push!(materials, MtlMaterial())
                materials[end].name = remainder
            elseif command == "Ka"
                materials[end].ambient = parseMtlColor(remainder)
            elseif command == "Kd"
                materials[end].diffuse = parseMtlColor(remainder)
            elseif command == "Ks"
                materials[end].specular = parseMtlColor(remainder)
            elseif command == "Tf"
                materials[end].transmission_filter = parseMtlColor(remainder)
            elseif command == "illum"
                materials[end].illum = parse(Int, remainder)
            elseif command == "d"
                materials[end].dissolve = parse(Float32, remainder)
            elseif command == "Ns"
                materials[end].specular_exponent = parse(Float32, remainder)
            elseif command == "map_Ka"
                materials[end].ambient_texture = parseMtlTextureMap(remainder)
            elseif command == "map_Kd"
                materials[end].diffuse_texture = parseMtlTextureMap(remainder)
            elseif command == "map_Ks"
                materials[end].specular_texture = parseMtlTextureMap(remainder)
	    elseif command == "map_refl"
        	materials[end].reflection_texture = parseMtlTextureMap(remainder)
            elseif command == "bump" || command == "map_bump"
                materials[end].bump_map = parseMtlTextureMap(remainder)
            elseif command == "Tr"
                materials[end].transparency = parse(Float32, remainder)
            elseif command == "Ni"
                materials[end].optical_density = parse(Float32, remainder)
            elseif command == "Ke"
                materials[end].emissive = parseMtlColor(remainder)
            else
                @warn Unknown "line while parsing wavefront .mtl: '$line'"
            end
        end
    end
    if debug
        for material in materials
            println("Parsed material: $(material.name)")
            println("  Ambient: $(material.ambient)")
            println("  Diffuse: $(material.diffuse)")
            println("  Specular: $(material.specular)")
            println("  Transmission Filter: $(material.transmission_filter)")
            println("  Illumination Model: $(material.illum)")
            println("  Dissolve: $(material.dissolve)")
            println("  Specular Exponent: $(material.specular_exponent)")
            println("  Ambient Texture: $(material.ambient_texture)")
            println("  Diffuse Texture: $(material.diffuse_texture)")
            println("  Specular Texture: $(material.specular_texture)")
	        println("  Reflection Texture: $(material.reflection_texture)")
            println("  Bump Map: $(material.bump_map)")
            println("  Transparency: $(material.transparency)")
            println("  Optical Density: $(material.optical_density)")
            println("  Emissive: $(material.emissive)")
            println("------")
        end
    end
    return materials
end

"""
    parseMtlColor(s::String)

Parses a color string in the MTL format and returns it as a `Vec3f`.

# Arguments
- `s::String`: The color string to parse.

# Returns
- `Vec3f`: The parsed color.
"""
function parseMtlColor(s::String)
    line_parts = split(s)
    return Vec3f(parse(Float32, line_parts[1]), parse(Float32, line_parts[2]), parse(Float32, line_parts[3]))
end

"""
    convert_windows_path_to_linux(windows_path::AbstractString)

Converts a Windows file path to a Linux-compatible file path.

# Arguments
- `windows_path::AbstractString`: The Windows file path.

# Returns
- `String`: The Linux-compatible file path.
"""
function convert_windows_path_to_linux(windows_path::AbstractString)
    # Remove drive letter and colon
    linux_path = replace(windows_path, r"^[a-zA-Z]:" => "")
    # Replace backslashes with forward slashes
    linux_path = replace(linux_path, "\\" => "/")
    return linux_path
end

"""
    parseMtlTextureMap(s::String)

Parses a texture map string in the MTL format and returns the filename.

# Arguments
- `s::String`: The texture map string to parse.

# Returns
- `String`: The parsed filename.
"""
function parseMtlTextureMap(s::String)
    # Use a regular expression to find the file path
    match_obj = match(r"[a-zA-Z]:[\\\/].+\.png", s)
    filepath = match_obj !== nothing ? match_obj.match : ""
    # Convert to Linux-compatible path
    filepath = convert_windows_path_to_linux(filepath)
    # Extract only the filename from the full path
    filename = basename(filepath)
    return filename
end


"""
    get_material_properties(mtl_file::String, material_name::String, materials)

Returns a dictionary of material properties for a given material name.

# Arguments
- `mtl_file::String`: The path to the MTL file.
- `material_name::String`: The name of the material to look for.
- `materials`: The vector of `MtlMaterial` objects to search in.

# Returns
- `Dict`: A dictionary containing the material properties.
"""
function get_material_properties(mtl_file::String, material_name::String, materials)
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
