      subroutine render(rnd, tkIdx)
      use iso_c_binding
      use sdl2
      
      type(c_ptr) :: rnd
      integer :: tkIdx

      integer result


      result = SDL_RenderClear(rnd)
      call SDL_RenderPresent(rnd)

      end subroutine render
