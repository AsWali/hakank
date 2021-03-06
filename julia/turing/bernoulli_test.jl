#=
  Test of Bernoulli

  See
     ~/blog/bernoulli_test.blog
     ~/webppl/bernoulli_test.wppl
=#

# using Memoization
using Turing, StatsPlots, DataFrames
using ReverseDiff, Zygote, Tracker
# Turing.setadbackend(:reversediff)
# Turing.setadbackend(:zygote)
# Turing.setadbackend(:tracker)
include("jl_utils.jl")

@model function bernoulli_test(y)
    prob ~ Beta(4,4)
    n = length(y)
    for i in 1:n
        y[i] ~ Bernoulli(prob)
    end

end

# Generated by R:
# > rbinom(120,1,0.3)
# I.e. prob should be around 0.3
#=
y = [0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,1,1,0,1,0,
    1,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,1,1,0,1,0,1,0,0,1,1,0,0,0,1,0,1,0,0,0,
    0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,1,0,0,1,0,1,1,0,0,1,0,0,1,0,1,1,
    0,1,0,1,0,0,0,0,0,1,0,0]
=#
# Generate data
y = rand(Bernoulli(0.3),1_000)
println("length(y):$(length(y))")
# println("y:$y")
model = bernoulli_test(y)
num_chains = 4

# chains = sample(model, Prior(), MCMCThreads(), 1000, num_chains)

# chains = sample(model, MH(), 10_000)
chains = sample(model, MH(), MCMCThreads(), 10_000, num_chains)

# chains = sample(model, PG(20), MCMCThreads(), 10_000, num_chains)
# chains = sample(model, PG(20), 1_000)
# chains = sample(model, IS(), MCMCThreads(), 10_000, num_chains) # Nope: does not handle the observation
# chains = sample(model, IS(), 10_000)

# chains = sample(model, SMC(), 10_000)


# chains = sample(model, NUTS(1000,0.65), MCMCThreads(), 40_000, num_chains)
# chains = sample(model, Gibbs(MH(:zlabels),NUTS(1000,0.65,:m,:b,:sigma)), MCMCThreads(), 40_000, num_chains)

display(chains)
