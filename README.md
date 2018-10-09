# Team Fortris

## Fortran

This project is as much about trying a simple game idea as about learning Fortran 77.  
Since it it surprisingly hard to get a F77 compiler on Windows these days we use Mingw/GCC's gfortran which only supports >=F95.
Also, proper C bindings are only available with F03 so we're sort of stuck with that as well. And F90's modules are also quite convenient for building the whole thing...  
So instead we just try to limit ourselves here a bit by using fixed form and avoiding some of the nice features.

Some useful resources that help(ed) us on this adventure:
* https://web.stanford.edu/class/me200c/tutorial_77/
* https://en.wikipedia.org/wiki/Fortran
* c interop
    * https://gcc.gnu.org/onlinedocs/gfortran/Interoperability-with-C.html#Interoperability-with-C
    * https://people.sc.fsu.edu/~jburkardt/f_src/f90_calls_c/f90_calls_c.html
