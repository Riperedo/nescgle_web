using NESCGLE
using JSON

function main(args...)
    # user inputs
    ν_str, ϕ_str, T_str =  args

    # variable definition
    ν = parse(Float64, ν_str)
    ϕ = parse(Float64, ϕ_str)
    T = parse(Float64, T_str)

    # Running SCGLE
    # wave vector
    k = collect(0:0.1:15*π)
        
    # computing Static structures
    I = Input_WCA(ϕ, T, k, ν = ν)
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
# julia Eq_WCA_script.jl 6.0 0.61 1.0
