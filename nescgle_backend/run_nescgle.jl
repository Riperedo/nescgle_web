using NESCGLE
using JSON

function run_calculations(args...)
    # user inputs
    ϕ_str, kStart_str, kEnd_str, VW_str = args

    # variable definition
    ϕ = parse(Float64, ϕ_str)
    kStart = parse(Float64, kStart_str)
    kEnd = parse(Float64, kEnd_str)
    k = collect(kStart:0.1:kEnd)
    VW = parse(Bool, VW_str)
    
    # computing Static structures
    I = NESCGLE.Input_HS(ϕ, k, VW=VW)
    S = NESCGLE.structure_factor(I)
    # computing dynamics
    τ, Fs, F, Δζ, Δη, D, W = NESCGLE.SCGLE(I)
    #NESCGLE.save_data("sdk.dat", [k, S], header="k\tS")
    # parsing to json file
    data = Dict("k"=>k, "S"=>S, "tau"=>τ, "sISF"=>Fs, "ISF"=>F, "Dzeta"=>Δζ, "Deta"=>Δη, "D"=>D, "MSD"=>W)
    filename = "sdk.json"
    open(filename, "w") do file
        JSON.print(file, data)
    end
    println("Calculation complete.")

end

run_calculations(ARGS...)