# Copyright 2021 Hakan Kjellerstrand hakank@bonetmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
#
#     http://www.apache.org/licenses/LICENSE-2.0 
#
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 

"""

  Ormat game in OR-tools CP-SAT Solver.

  From bit-player "The Ormat Game"
  http://bit-player.org/2010/the-ormat-game
  '''
  I'm going to give you a square grid, with some of the cells colored 
  and others possibly left blank. We'll call this a template. Perhaps 
  the grid will be one of these 3x3 templates:
  
  [see pictures at the web page]
  
  You have a supply of transparent plastic overlays that match the 
  grid in size and shape and that also bear patterns of black dots:
  
  [ibid.]

  Your task is to assemble a subset of the overlays and lay them on 
  the template in such a way that dots cover all the colored squares 
  but none of the blank squares. You are welcome to superimpose multiple 
  dots on any colored square, but overall you want to use as few overlays 
  as possible. To make things interesting, I'll suggest a wager. I'll pay 
  you $3 for a correct covering of a 3x3 template, but you have to pay me 
  $1 for each overlay you use. Is this a good bet?
  '''
  
  This is a prototype which the following limitations:
  - the overlays is not generated dynamically for each n
  - it just shows which overlays that is used. It would be nice
    with a much more graphical output.
  - the questions asked by bit-player is not answered (it requires
    more analysis)

  That said, here is solutions of the three problems stated at the web page
  with minimum number of overlays.
     x is an indicator matrix which overlay to use
     overlay used is a set representation of the overlay used
     num_overlays is the number of overlays used

  This is a port of my old CP model ormat_game.py  

  This model was created by Hakan Kjellerstrand (hakank@gmail.com)
  Also see my other OR-tools models: http://www.hakank.org/or_tools/
  
"""
from __future__ import print_function
from ortools.sat.python import cp_model as cp
import math, sys
# from cp_sat_utils import *
import string, sys


class SolutionCollector(cp.CpSolverSolutionCallback):
    """SolutionCollector for generating overlays"""
    def __init__(self, n, x, collection):
        cp.CpSolverSolutionCallback.__init__(self)
        self.__n = n
        self.__x = x
        self._collection = collection
        self.__solution_count = 0

    def OnSolutionCallback(self):
        self.__solution_count += 1
        n = self.__n
        ov = [[self.Value(self.__x[i][j]) for i in range(n)] for j in range(n)]
        self._collection.append(ov)

    def SolutionCount(self):
        return self.__solution_count

#
# Generate all the overlays for a specific size (n)
#
def get_overlays(n=3, debug=0):

    model = cp.CpModel()

    #
    # decision variables
    # 
    x = []
    for i in range(n):
        t = []
        for j in range(n):
            t.append(model.NewIntVar(0,1, "x[%i][%i]"%(i,j)))
        x.append(t)

    #
    # constraints
    #
    for i in range(n):
        model.Add(sum([x[i][j] for j in range(n)]) == 1)
        model.Add(sum([x[j][i] for j in range(n)]) == 1)

    
    solver = cp.CpSolver()
    overlays = []
    solution_collector = SolutionCollector(n, x,overlays)
    _status = solver.SearchForAllSolutions(model,solution_collector)

    # if status == cp.OPTIMAL:
    #   True
    
    return overlays



#
# print a problem
#
def print_problem(problem, n):
    print("Problem:")
    for i in range(n):
        for j in range(n):
            print(problem[i][j], " ",end=" ")
        print('')
    print('')
            

#
# print a solution
#
def print_solution(x, overlays):
    f = len(x)
    n = len(overlays[0])
    print("f:",f, " n: ", n)
    # print("x: ", x)
    print("num overlays:", sum(x))
    for o in range(f):
        if x[o] == 1:
            print("Overlay", o)
            for i in range(n):
                for j in range(n):
                    print(overlays[o][i][j], " ",end=" ")
                print('')
            print('')


def main(problem, overlays, n, debug=0):
    
    model = cp.CpModel()

    # data
    f = len(overlays)
    
    # declare variables
    x =  [model.NewIntVar(0, 1, "x[%i]" %i) for i in range(f)]
    num_overlays = model.NewIntVar(0, f, 'num_overlays')

    y = {}
    for i in range(n):
        for j in range(n):
            y[(i,j)] = model.NewIntVar(0,f,"y[%i,%i]"%(i,j))

    # constraints
    for i in range(n):
        model.Add(sum([y[(i,j)] for j in range(n)]) > 0)
        model.Add(sum([y[(j,i)] for j in range(n)]) > 0)

    model.Add(sum(x) == num_overlays)

    for i in range(n):
        for j in range(n):
            model.Add(y[(i,j)] == sum([(x[o])*(overlays[o][i][j]) for o in range(f)]))
            if problem[i][j] == 1:
                model.Add(y[(i,j)] >= 1)
            if problem[i][j] == 0:
                model.Add(y[(i,j)] == 0)

    model.Minimize(num_overlays)

    # solution and search
    solver = cp.CpSolver()
    solver.parameters.search_branching = cp.PORTFOLIO_SEARCH
    solver.parameters.cp_model_presolve = False
    # solver.parameters.linearization_level = 0
    # solver.parameters.cp_model_probing_level = 0

    status = solver.Solve(model)
    
    the_solution = []
    if status == cp.OPTIMAL:
        t = [solver.Value(x[i]) for i in range(f)]
        the_solution = t
        print("Num overlays: ", sum([solver.Value(x[i]) for i in range(f)]))

    print("\nOptimal solution:")
    print_solution(the_solution, overlays)
    print("Num overlays: ", sum(the_solution))

    print()
    print("NumConflicts:", solver.NumConflicts())
    print("NumBranches:", solver.NumBranches())
    print("wall_time:", solver.WallTime())
    print()


# problem 1
problem1 = {
   "n": 3,
   "p": [
    [1,0,0],
    [0,1,1],
    [0,1,1]
    ]
   }

# # Problem grid 2
problem2 = {
  "n": 3,
  "p": [
    [1,1,1],
    [1,1,1],
    [1,1,1]
    ]
}

# Problem grid 3
problem3 = {
  "n": 3,
  "p": [
    [1,1,1],
    [1,1,1],
    [1,1,0]
    ]
}

# This rotation of the above works
problem4 = {
  "n": 3,
  "p": [
    [1,1,1],
    [1,1,1],
    [0,1,1]
    ]
}


# This is a _bad_ problem since all rows
# and colutions must have at least one cell=1
problem5 = {
  "n": 3,
  "p": [
    [0,0,0],
    [0,1,1],
    [0,1,1]
    ]
}

# # Problem grid 4 (n = 4)
problem6 = {
  "n": 4,
  "p": [
    [1,1,1,1],
    [1,1,1,1],
    [1,1,1,1],
    [1,1,0,0]
    ]
}

# variant
problem7 = {
  "n": 4,
  "p": [
    [1,1,1,1],
    [1,1,1,1],
    [1,1,1,1],
    [1,1,1,0]
    ]
}

# variant
problem8 = {
  "n": 4,
  "p": [
    [1,1,1,1],
     [1,1,1,1],
     [1,1,1,1],
     [1,1,1,1]
     ]
}


# Problem grid 5 (n = 5)
# This is under the section "Out of bounds"
problem9 = {
  "n": 5,
  "p": [
    [1,1,1,1,1],
    [1,1,1,1,1],
    [1,1,1,1,1],
    [1,1,1,1,1],
    [1,1,0,0,0]
    ]
}

# Problem grid 6 (n = 6)
# # This is under the section "Out of bounds"%
problem10 = {
  "n": 6,
  "p": [
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,0,0,0,0]
    ]
}

#
# Problem (n=7)
# hard
problem11 = {
  "n": 7,
  "p": [
    [1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1],
    [0,1,1,1,1,1,1],
    [0,0,1,1,1,1,1],
    [0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1],
    [0,0,0,0,0,1,1]
    ]
}

#
# Problem (n=7), "flags"
#
# quite hard
#
problem12 = {
  "n": 7,
  "p": [
    [0,0,0,1,1,1,1],
    [0,0,0,1,1,1,1],
    [0,0,0,1,1,1,1],
    [1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1]
    ]
}

#
# Wrapper for solving a problem
# 
def solve_problem(p, n):
    print_problem(p, n)
    overlays = get_overlays(n, debug)
    main(p, overlays, n, debug)

#
# Solve all problems
#
def solve_all():
  ps = [problem1,problem2,problem3,problem4,problem5,problem6,
        problem7,problem8,problem9,problem10,problem11,problem12]
  for p in ps:
    solve_problem(p["p"],p["n"])
    print()

problem = problem12
if __name__ == '__main__':
    debug = 1
    # solve_problem(problem["p"],problem["n"])
    solve_all()

