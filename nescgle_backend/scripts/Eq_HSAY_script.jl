using NESCGLE
using JSON

function main(args...)
    # user inputs
    ϕ_str, T_str, z_str =  args

    # variable definition
    ϕ = parse(Float64, ϕ_str)
    T = parse(Float64, T_str)
    z = parse(Float64, z_str)
    
    # Running SCGLE
    # wave vector # WARNING NaN at k=0 for this system
    k = collect(0.01:0.1:15*π)
        
    # computing Static structures
    I = T < 100 ? Input_Yukawa(ϕ, 1/T, z, k) : Input_HS(ϕ, k, VW=true)
    #I = Input_Yukawa(ϕ, 1/T, z, k)
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
#julia Eq_HSAY_script.jl 0.25 1.5 2.0
