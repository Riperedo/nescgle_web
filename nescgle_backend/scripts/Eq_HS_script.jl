using NESCGLE
using JSON

function main(args...)
    # user inputs
    ϕ_str =  args[1]

    # variable definition
    ϕ = parse(Float64, ϕ_str)

    
    # Running SCGLE
    
    # wave vector
    k = collect(0:0.1:15*π)
        
    # computing Static structures
    I = Input_HS(ϕ, k, VW = true)
    S = structure_factor(I)
    # computing dynamics
    τ, Fs, F, Δζ, Δη, D, W = SCGLE(I)
    # parsing to json file
    structural_data = Dict("k"=>k, "S"=>S)
    dynamics_data = Dict("tau"=>τ, "sISF"=>Fs, "ISF"=>F, "Dzeta"=>Δζ, "Deta"=>Δη, "D"=>D, "MSD"=>W)
    data = Dict("Statics"=>structural_data, "Dynamics"=>dynamics_data)
    println(JSON.json(data))
end

#@time main(ARGS...)
main(ARGS...)
# julia Eq_HS_script.jl 0.5
