% 
% Ski assignment problem in ASP.
%
% From
% Jeffrey Lee Hellrung, Jr.: PIC 60, Fall 2008 – Final Review, December 12, 2008
% http://www.math.ucla.edu/~jhellrun/course_files/Fall%25202008/PIC%252060%2520-%2520Data%2520Structures%2520and%2520Algorithms/final_review.pdf
% """
% 5. Ski Optimization! Your job at Snapple is pleasant but in the winter you've 
% decided to become a ski bum. You've hooked up with the Mount Baldy Ski Resort. 
% They'll let you ski all winter for free in exchange for helping their ski rental 
% shop with an algorithm to assign skis to skiers. Ideally, each skier should 
% obtain a pair of skis whose height matches his or her own height exactly. 
% Unfortunately, this is generally not possible. We define the disparity between 
% a skier and his or her skis to be the absolute value of the difference between 
% the height of the skier and the pair of skis. Our objective is to find an 
% assignment of skis to skiers that minimizes the sum of the disparities. 
% ...
% Illustrate your algorithm by explicitly filling out the A[i, j] table for the 
% following sample data:
%   * Ski heights: 1, 2, 5, 7, 13, 21.
%   * Skier heights: 3, 4, 7, 11, 18.
%
% """
% 
%
% This was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also http://www.hakank.org/answer_set_programming/
%

#const num_skis = 6.
#const num_skiers = 5.

% domains
skiers(1..num_skiers).
skis(1..num_skis).

ski_height(1,1).
ski_height(2,2).
ski_height(3,5).
ski_height(4,7).
ski_height(5,13).
ski_height(6,21).

skier_height(1,3).
skier_height(2,4).
skier_height(3,7).
skier_height(4,11).
skier_height(5,18).

% assignment unique index of x
1 { skier(Skier, Ski)  : skis(Ski) } 1 :- skiers(Skier).

% atmost one ski for each skier
{ skier(Skier, Ski)  : skiers(Skier) } 1 :- skis(Ski).

#minimize [ skier(Skier, Ski) : skier_height(Skier, SkierHeight) : ski_height(Ski, SkiHeight) = #abs(SkierHeight - SkiHeight) ].


#hide.
#show skier(Skier, Ski).