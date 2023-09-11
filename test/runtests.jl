using MatMeshMakie
using Test
using GeometryBasics
using DataStructures
using FileIO
using Colors

# Test MtlParser functions
@testset "MtlParser Tests" begin
    mtl_file = joinpath(@__DIR__, "assets", "drex.mtl")
    materials = readMtlFile(mtl_file)
    
    @test length(materials) > 0  # At least one material should be parsed
    
    for material in materials
        @test material.name isa String
        @test material.ambient isa Vec3f
        @test material.specular isa Vec3f
        @test material.diffuse isa Vec3f
        @test material.transmission_filter isa Vec3f
        @test material.illum isa Int
        @test material.dissolve isa Float32
        @test material.specular_exponent isa Float32
        @test material.ambient_texture isa String
        @test material.specular_texture isa String
        @test material.diffuse_texture isa String
        @test material.reflection_texture isa String
        @test material.bump_map isa String
        @test material.transparency isa Float32
        @test material.optical_density isa Float32
        @test material.emissive isa Vec3f
    end
end

# Test ObjParser functions
@testset "ObjParser Tests" begin
    obj_file = joinpath(@__DIR__, "assets", "drex.obj")
    mtl_file = joinpath(@__DIR__, "assets", "drex.mtl")
    
    # Test face_materials
    face_materials = get_face_materials(obj_file)
    @test length(face_materials) > 0  # At least one face material should be parsed
    @test face_materials[1] isa String  # Material name should be a string
    
    # Test mesh loading and splitting
    obj_mesh = FileIO.load(obj_file)  # Assuming FileIO can load the obj file
    @test obj_mesh isa GeometryBasics.Mesh  # Should be a Mesh type
    
    material_mesh_dict = split_mesh_by_material(obj_mesh, face_materials)
    @test length(keys(material_mesh_dict)) > 0  # At least one sub-mesh should be created
    
    # Additional checks for sub-meshes
    for (key, sub_mesh_faces) in material_mesh_dict
        @test length(sub_mesh_faces) > 0  # Each sub-mesh should have faces
    end
    
    # Test material properties for each sub-mesh
    materials = readMtlFile(mtl_file)
    for (material_name, sub_mesh_faces) in material_mesh_dict
        material_properties = get_material_properties(mtl_file, material_name, materials)
        
        # Validate material properties
        @test material_properties[:color] isa ColorTypes.RGB
        @test material_properties[:ambient] isa Vec3f
        @test material_properties[:diffuse] isa Vec3f
        @test material_properties[:specular] isa Vec3f
        @test material_properties[:shininess] isa Float32
        @test material_properties[:alpha] isa Float32
        @test material_properties[:transmission_filter] isa Vec3f
        @test material_properties[:illum] isa Int
        @test material_properties[:ambient_texture] isa String
        @test material_properties[:diffuse_texture] isa String
        @test material_properties[:specular_texture] isa String
        @test material_properties[:reflection_texture] isa String
        @test material_properties[:bump_map] isa String
        @test material_properties[:transparency] isa Float32
        @test material_properties[:optical_density] isa Float32
        @test material_properties[:emissive] isa Vec3f
    end
end
