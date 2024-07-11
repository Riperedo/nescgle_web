using NESCGLE
using JSON

function main(args...)
    # user inputs
    λ_str =  args[1]
    
    # variable definition
    λ = parse(Float64, λ_str)

    # preparing saving folder
    
    data = Dict()

    # computiing spinodal
    
    # Colloid volume fraction
    phi = collect(0.01:0.001:0.58)
    # Colloid Temperature
    T_spinodal = zeros(length(phi))
    T_min = 1e-6
    T_max = 1e2
        
    # preparing Input object
    k = collect(0:0.1:π)
    # main loop
    for (i, ϕ) in enumerate(phi)
        function condition(T)
            I = Input_SW(ϕ, T, λ, k)
            S = structure_factor(I)
            return sum(S .< 0.0) > 0
        end
        T_spinodal[i] = NESCGLE.bisection(condition, T_min, T_max, 1e-6)
    end
    #saving data
    Spinodal = Dict("phi"=>phi, "Temp"=>T_spinodal)
    
    # preparing ϕ-T space grid
    Phi = Spinodal["phi"]
    T_s = Spinodal["Temp"]
    phi = zeros(length(Phi))
    Temperature = zeros(length(phi))
    T_max = 5.0
        
    # preparing Input object
    k = collect(0:0.1:15*π)
    # main loop
    for (i, ϕ) in enumerate(Phi)
        function condition(T)
            I = Input_SW(ϕ, T, λ, k)
            iterations, gammas, system = Asymptotic(I, flag = false)
            return system == "Glass"
        end
        phi[i] = ϕ
        Temperature[i] = NESCGLE.bisection(condition, T_s[i], T_max, 1e-3)
    end
    #saving data
    Arrest = Dict("phi"=>phi, "Temp"=>Temperature)
    # Complete data output
    data = Dict("Spinodal" => Spinodal, "Arrest" => Arrest)
    println(JSON.json(data))
end

#@time main(ARGS...)
main(ARGS...)
# julia Arrest_HSSW.jl 1.5
