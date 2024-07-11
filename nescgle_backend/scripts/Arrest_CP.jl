using NESCGLE
using JSON

function main(args...)
    # user inputs
    ξ_str = args[1]
    
    # variable definition
    ξ = parse(Float64, ξ_str)

    # preparing saving folder

    data = Dict()
  
    # Computing spinodal

    # Colloid volume fraction
    C = collect(0.01:0.001:0.58)
    # polymer volume fraction
    P_spinodal = zeros(length(C))
    P_min = 1e-6
    P_max = 1e2
    
    # preparing Input object
    k = collect(0.01:0.1:π)
    # main loop
    for (i, ϕC) in enumerate(C)
        function condition(ϕP)
            I = Input_AO(ϕC, ϕP, ξ, k)
            S = structure_factor(I)
            return sum(S .< 0.0) == 0
        end
        P_spinodal[i] = NESCGLE.bisection(condition, P_min, P_max, 1e-3)
    end
    #saving data
    Spinodal = Dict("phiC" => C, "phiP" => P_spinodal)
    
    # preparing ϕ-T space grid
    C = Spinodal["phiC"]
    P_s = Spinodal["phiP"]
    c = zeros(length(C))
    p = zeros(length(C))
    P_min = 1e-6
    
    # preparing Input object
    k = collect(0.0:0.1:15*π)
    # main loop
    for (i, ϕC) in enumerate(C)
        function condition(ϕP)
            I = Input_AO(ϕC, ϕP, ξ, k)
            iterations, gammas, system = Asymptotic(I, flag = false)
            return system == "Glass" || system == "Dump"
        end
        c[i] = ϕC
        p[i] = NESCGLE.bisection(condition, P_s[i], P_min, 1e-6)
    end
    #saving data
    Arrest = Dict("phiC" => c, "phiP" => p)
    # Complete data output
    data = Dict("Spinodal" => Spinodal, "Arrest" => Arrest)
    println(JSON.json(data))
end

main(ARGS...)