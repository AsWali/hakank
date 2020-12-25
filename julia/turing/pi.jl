#=
  Calculating π

  from Foundations of Probabilistic Programming,
  page 4

=#

using Turing, StatsPlots, DataFrames
include("../jl_utils.jl")

# Well, using PPL for this is probably not the best approach. :-)
@model function pi_calc()
    println("START")
    limit = 10^6
    i = 0 # ~ DiscreteUniform(1,limit)
    n = 1 # ~ DiscreteUniform(1,limit)

    while i < limit
        x ~ Uniform()
        y ~ Uniform()
        if (x*x+y*y) < 1
            n = n + 1
        end
        i = i + 1
    end
    ppi ~ Uniform(3,4)
    ppi = 4*n/limit
end


model = pi_calc()

num_chains = 4
# chains = sample(model, MH(), MCMCThreads(), 1000, num_chains)
chains = sample(model, MH(), 10)

display(chains)
# show_var_dist_pct(chains, :x)
# show_var_dist_pct(chains, :y)
# show_var_dist_pct(chains, :i)
# show_var_dist_pct(chains, :n)
show_var_dist_pct(chains, :ppi)


#=
# Plain simulation
ppi:3.141694144
π  :π
diff: -0.00010149041020701688
  7.368581 seconds (1.03 M allocations: 49.375 MiB)
=#
function pi_calc2(limit=10^9)

    i = 0
    n = 1

    while i < limit
        x = rand()
        y = rand()
        if (x*x+y*y) < 1
            n = n + 1
        end
        i = i + 1
    end

    return 4*n/limit
end

#=
@time ppi= pi_calc2()
println("ppi:$ppi")
println("π  :$(π)")
println("diff: ", π-ppi)
=#
