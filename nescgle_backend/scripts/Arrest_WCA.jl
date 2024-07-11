using NESCGLE
using JSON

function main(args...)
    # user inputs
    ν_str =  args[1]
    
    # variable definition
    ν = parse(Int64, ν_str)

    # preparing saving folder

    data = Dict

    # preparing ϕ-T space grid
    phi = collect(0.58:0.001:0.7)
    Temperature = zeros(length(phi))
    T_min = 1e-6
    T_max = 1e1
        
    # preparing Input object
    k = collect(0:0.1:15*π)
    # main loop
    for (i, ϕ) in enumerate(phi)
        function condition(T)
            I = Input_WCA(ϕ, T, k)
            iterations, gammas, system = Asymptotic(I, flag = false)
            return system == "Glass"
        end
        Temperature[i] = NESCGLE.bisection(condition, T_min, T_max, 1e-6)
    end
    #saving data
    Arrest = Dict("phi"=>phi, "Temp"=>Temperature)
    # Complete data output
    data = Dict("Arrest" => Arrest)
    println(JSON.json(data))
    
    println("Calculation complete.")
end

@time main(ARGS...)
# julia Arrest_WCA.jl 6.0 
