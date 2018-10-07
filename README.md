# Team Fortris

## Fortran

This project is as much about trying a simple game idea as about learning Fortran 77.  
Since it it surprisingly hard to get a F77 compiler on Windows these days we use Mingw/GCC's gfortran which only supports >=F95.
Inevitably we drag in F03 features, but the SDL C bindings we need wouldn't be feasible anyways (at least not without compiler extensions).  
So instead we just modified a few compiler settings to get closer to that dusty F77 feel (most notably using fixed form code)

Some useful resources that help(ed) us on this adventure:
* https://web.stanford.edu/class/me200c/tutorial_77/
* https://en.wikipedia.org/wiki/Fortran
* c interop
    * https://gcc.gnu.org/onlinedocs/gfortran/Interoperability-with-C.html#Interoperability-with-C
    * https://people.sc.fsu.edu/~jburkardt/f_src/f90_calls_c/f90_calls_c.html
