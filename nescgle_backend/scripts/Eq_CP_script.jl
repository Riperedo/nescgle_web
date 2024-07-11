using NESCGLE
using JSON

function main(args...)
    # user inputs
    ϕC_str, ϕP_str, ξ_str =  args

    # variable definition
    ϕC = parse(Float64, ϕC_str)
    ϕP = parse(Float64, ϕP_str)
    ξ = parse(Float64, ξ_str)

    # Running SCGLE
    # wave vector
    k = collect(0:0.1:15*π)
        
    # computing Static structures
    I = Input_AO(ϕC, ϕP, ξ, k)
    S = structure_factor(I)
    # computing dynamics
    τ, Fs, F, Δζ, Δη, D, W = SCGLE(I)
    # parsing to json output
    structural_data = Dict("k"=>k, "S"=>S)
    dynamics_data = Dict("tau"=>τ, "sISF"=>Fs, "ISF"=>F, "Dzeta"=>Δζ, "Deta"=>Δη, "D"=>D, "MSD"=>W)
    data = Dict("Statics"=>structural_data, "Dynamics"=>dynamics_data)
    println(JSON.json(data))
end

main(ARGS...)
#@time main(ARGS...)
# julia Eq_CP_script.jl 0.25 1.0 0.1
