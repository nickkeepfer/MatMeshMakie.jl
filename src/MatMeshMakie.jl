module MatMeshMakie

using GeometryBasics
using DataStructures
using FileIO
using GLMakie
using Colors

include("MtlMaterial.jl")
include("MtlParser.jl")
include("ObjParser.jl")
include("Plotting.jl")

export MtlMaterial, readMtlFile, get_face_materials, split_mesh_by_material,
       get_material_properties, get_submesh_material_properties, plot_obj_mtl,
       plot_submeshes

end
