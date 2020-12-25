#=
  The BUGS Book
  Example 2.5.1, "The how many trick"

  Cf ~/jags/bugs_book_2_5_1.jags
  """
  model {
    for (i in 1:20) {
     Y[i] ~ dgamma(4, 0.04)
    }
    cum[1] <- Y[1]
    for (i in 2:20) {
      cum[i] <- cum[i - 1] + Y[i]
    }
    for (i in 1:20) {
      cum.step[i] <- i*step(1000 - cum[i])
      x[i] <- ifelse(cum[i] < 1001, 1, 0) #
    }
    # number <- ranked(cum.step[], 20) # maximum number in cum.step ## NOTE: ranked is not in JAGS
    number <- sort(cum.step[]) # maximum number in cum.step
    check <- equals(cum.step[20], 0) # always 1 if I=20 big enough
  }

  Output:
           Mean       SD  Naive SE Time-series SE
x[1]  1.000e+00 0.000000 0.000e+00      0.000e+00
x[2]  1.000e+00 0.000000 0.000e+00      0.000e+00
x[3]  1.000e+00 0.000000 0.000e+00      0.000e+00
x[4]  1.000e+00 0.000000 0.000e+00      0.000e+00
x[5]  9.999e-01 0.012247 5.000e-05      5.000e-05
x[6]  9.976e-01 0.049101 2.005e-04      2.043e-04
x[7]  9.810e-01 0.136350 5.566e-04      5.566e-04
x[8]  9.141e-01 0.280293 1.144e-03      1.131e-03
x[9]  7.578e-01 0.428418 1.749e-03      1.741e-03
x[10] 5.222e-01 0.499512 2.039e-03      2.039e-03
x[11] 2.825e-01 0.450235 1.838e-03      1.793e-03
x[12] 1.195e-01 0.324340 1.324e-03      1.307e-03
x[13] 4.015e-02 0.196313 8.014e-04      8.014e-04
x[14] 9.867e-03 0.098841 4.035e-04      4.035e-04
x[15] 2.117e-03 0.045959 1.876e-04      1.897e-04
x[16] 4.500e-04 0.021209 8.658e-05      8.988e-05
x[17] 1.667e-05 0.004082 1.667e-05      1.667e-05
x[18] 0.000e+00 0.000000 0.000e+00      0.000e+00
x[19] 0.000e+00 0.000000 0.000e+00      0.000e+00
x[20] 0.000e+00 0.000000 0.000e+00      0.000e+00
  """


  Cf ~/blog/bugs_book_2_5_1.blog
     ~/webppl/bugs_book_2_5_1.wppl

   Distribution of ix:
12.00000 =>    8898  (0.222450)
11.00000 =>    8239  (0.205975)
13.00000 =>    7365  (0.184125)
10.00000 =>    5209  (0.130225)
14.00000 =>    4494  (0.112350)
9.00000 =>    2373  (0.059325)
15.00000 =>    1829  (0.045725)
8.00000 =>     767  (0.019175)
16.00000 =>     495  (0.012375)
7.00000 =>     157  (0.003925)
17.00000 =>     123  (0.003075)
18.00000 =>      29  (0.000725)
6.00000 =>      18  (0.000450)
19.00000 =>       3  (0.000075)
5.00000 =>       1  (0.000025)


Distribution of x (the change point arra")
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  8968 (0.2242)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  8020 (0.2005)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  7477 (0.186925)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  5173 (0.129325)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  4491 (0.112275)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  2387 (0.059675)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  1833 (0.045825)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  753 (0.018825)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]    =>  549 (0.013725)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  168 (0.0042)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0]    =>  128 (0.0032)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]    =>  26 (0.00065)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0]    =>  22 (0.00055)
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0]    =>  5 (0.000125)

=#


using Turing, StatsPlots, DataFrames
include("jl_utils.jl")

@model function bugs_book_2_5_1()
    n = 20

    y = tzeros(n)
    cum = tzeros(n)
    cum_step = tzeros(n)
    x = tzeros(n)
    for i in 1:n
        # Note:BLOG has second parameter b, webbpl 1/b
        y[i] ~ Gamma(3.0,1/0.04)
        if i == 1
            cum[i] = y[1]+1
        else
            cum[i] = cum[i-1] + y[i] + i
        end
        if cum[i] > 1000.0
            cum_step[i] = i*cum[i]
        else
            cum_step[i] = 0.0
        end

        # A change point
        # x[i] ~ flip(0.5)
        if cum[i] < 1001.0
            x[i] = 1.0
        else
            x[i] = 0.0
        end
    end

    # number ~ Uniform(0,50_000)
    number = maximum(cum_step)

    # Max number with 1
    # ix ~ DiscreteUniform(1,20)
    ix, _ = findmax([i*(x[i]==1) for i in 1:n])

    # return number
    return ix
    # return x
end

model = bugs_book_2_5_1()

num_chains = 4

# chains = sample(model, Prior(), MCMCThreads(), 10_000, num_chains)
chains = sample(model, MH(), MCMCThreads(), 10_000, num_chains)
# chains = sample(model, PG(15), MCMCThreads(), 10_000, num_chains)
# chains = sample(model, SMC(1000), MCMCThreads(), 10_000, num_chains)
# chains = sample(model, IS(), MCMCThreads(), 10_000, num_chains)

display(chains)
# display(plot(chains))

gen = generated_quantities(model, chains)
show_var_dist_pct(gen, 40)
