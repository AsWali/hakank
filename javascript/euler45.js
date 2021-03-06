/* 

  Euler #45 in JavaScript.

  Problem 45:
  """  
  Triangle, pentagonal, and hexagonal numbers are generated by the following formulae:

  Triangle 	  	Tn=n(n+1)/2 	  	1, 3, 6, 10, 15, ...
  Pentagonal 	  	Pn=n(3n−1)/2 	  	1, 5, 12, 22, 35, ...
  Hexagonal 	  	Hn=n(2n−1) 	  	1, 6, 15, 28, 45, ...

  It can be verified that T(285) = P(165) = H(143) = 40755.

  Find the next triangle number that is also pentagonal and hexagonal.
  """

  This JavaScript program was created by Hakan Kjellerstrand, hakank@gmail.com
  See also my JavaScript page: http://www.hakank.org/javascript_progs/

*/

'use strict';
const {timing2} = require('./js_utils.js');

const pent = function(n) { return Math.floor(n*(3*n-1) / 2); }
const tri  = function(n) { return Math.floor(n*(n+1) / 2);   }
const hex  = function(n) { return n*(2*n-1);                 }


// 5ms
const euler45a = function() {
    let t = 285+1;
    let tt = tri(t);
    let p = 165;
    let pp = pent(p);
    let h = 143;
    let hh = hex(h);
    while (tt !== pp || pp !== hh)  {
        t++;
        tt = tri(t);
        if (tt > pp) { p++; pp = pent(p); }
        if (pp > hh) { h++; hh = hex(h);  }
        if (tt > hh) { h++; hh = hex(h);  }
    }
    
    return tt;
}

timing2(euler45a); // 5ms
