      program main
      implicit none

c Import SDL functions
      interface
            function SDL_GetRevisionNumber() 
     +        bind(c, name='SDL_GetRevisionNumber')
                  use iso_c_binding
                  implicit none
                  integer(kind=c_int) :: SDL_GetRevisionNumber
            end function SDL_GetRevisionNumber
      end interface

      write(*, '(i0)') SDL_GetRevisionNumber()

      stop
      end
