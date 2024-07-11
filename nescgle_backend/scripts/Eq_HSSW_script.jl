using NESCGLE
using JSON

function main(args...)
    # user inputs
    ϕ_str, T_str, λ_str =  args

    # variable definition
    ϕ = parse(Float64, ϕ_str)
    T = parse(Float64, T_str)
    λ = parse(Float64, λ_str)

    # Running SCGLE
    # wave vector
    k = collect(0:0.1:15*π)
        
    # computing Static structures
    I = Input_SW(ϕ, T, λ, k)
    S = structure_factor(I)
    # computing dynamics
    τ, Fs, F, Δζ, Δη, D, W = SCGLE(I)
    # parsing to json file
    structural_data = Dict("k"=>k, "S"=>S)
    dynamics_data = Dict("tau"=>τ, "sISF"=>Fs, "ISF"=>F, "Dzeta"=>Δζ, "Deta"=>Δη, "D"=>D, "MSD"=>W)
    data = Dict("Statics"=>structural_data, "Dynamics"=>dynamics_data)
    println(JSON.json(data))
end

main(ARGS...)
#@time main(ARGS...)
#julia Eq_HSSW_script.jl 0.25 1.0 1.5
