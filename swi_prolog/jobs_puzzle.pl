/*

  Jobs puzzle in SWI Prolog

  This is a standard problem in Automated Reasoning.
  
  From http://www-unix.mcs.anl.gov/~wos/mathproblems/jobs.html
  """
  Jobs Puzzle
  
  There are four people:  Roberta, Thelma, Steve, and Pete.
  Among them, they hold eight different jobs.
  Each holds exactly two jobs.
  The jobs are chef, guard, nurse, clerk, police officer (gender 
  not implied), teacher, actor, and boxer.
  The job of nurse is held by a male.
  The husband of the chef is the clerk.
  Roberta is not a boxer.
  Pete has no education past the ninth grade.
  Roberta, the chef, and the police officer went golfing together.
 
  Question:  Who holds which jobs?
  """
  
  The answer:
  Chef       Thelma
  Guard      Roberta
  Nurse      Steve
  Clerk      Pete
  Police     Steve
  Teacher    Roberta
  Actor      Pete
  Boxer      Thelma

 

  Model created by Hakan Kjellerstrand, hakank@gmail.com
  See also my SWI Prolog page: http://www.hakank.org/swi_prolog/

*/

:- use_module(library(clpfd)).
:- use_module(hakank_utils).

go :-

        Roberta = 1,
        Thelma = 2,
        Steve = 3,
        Pete = 4,
        
        _Persons = [Roberta, Thelma, Steve, Pete],
        
        Jobs = [Chef, _Guard, Nurse, Clerk, PoliceOfficer, Teacher, Actor, Boxer],
        Jobs ins 1..4,
        
   
        %% Each holds exactly two jobs.
        findall(I-2,between(1,4,I), GCC),
        global_cardinality(Jobs,GCC),
   
        %%  The job of nurse is held by a male.
        (Nurse #= Steve #\/ Nurse #= Pete),

        %%  The husband of the chef is the clerk.
        (Clerk #= Steve   #\/ Clerk #= Pete),
        (Chef  #= Roberta #\/ Chef #= Thelma),
        Chef #\= Clerk,

        %%  Roberta is not a boxer.
        Roberta #\= Boxer,

        %%  Pete has no education past the ninth grade.
        Pete #\= Teacher, 
        Pete #\= PoliceOfficer, 
        Pete #\= Nurse,

        %% Roberta, [and] the chef, and the police officer 
        %% went golfing together.
        all_different([Roberta,Chef,PoliceOfficer]),
        %% Roberta #\= Chef , 
        %% Chef    #\= PoliceOfficer ,
        %% Roberta #\= PoliceOfficer ,

        %% From the name of the job
        (Actor #= Steve #\/ Actor #= Pete),

        %% search
        label(Jobs),

        %% output
        writeln(Jobs),nl,
        PersonsStr = ["Roberta", "Thelma", "Steve", "Pete"],
        JobsStr    = ["Chef", "Guard", "Nurse", "Clerk", "Police", "Teacher", "Actor", "Boxer"],
        findall([Js,Ps],
                (
                 between(1,8,I),
                 element(I,Jobs,J),
                 nth1(I,JobsStr,Js),
                 nth1(J,PersonsStr,Ps)
                 ),
                Sol),
        maplist(format("~s~t~7|: ~s~n"),Sol),
        nl.
