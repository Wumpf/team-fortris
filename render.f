      subroutine render(rnd, tkIdx)
      use iso_c_binding
      use sdl2

      type(c_ptr) :: rnd
      integer :: tkIdx

      integer result
      type(SDL_Rect) rects(2)
      integer(1) colors(4, 2)
      data colors/0, 0, 0, -1, -1, 0, 0, -1/

      rects(1)%x = 0
      rects(1)%y = 0
      rects(1)%w = 100
      rects(1)%h = 100
      rects(2)%x = 120
      rects(2)%y = 120
      rects(2)%w = 50
      rects(2)%h = 50

      result = SDL_SetRenderDrawColor(rnd,
     +    colors(1, 1), colors(2, 1), colors(3, 1), colors(4, 1))
      result = SDL_RenderClear(rnd)

      result = SDL_SetRenderDrawColor(rnd,
     +    colors(1, 2), colors(2, 2), colors(3, 2), colors(4, 2))
      result = SDL_RenderFillRects(rnd, rects, 2)

      call SDL_RenderPresent(rnd)

      end subroutine render
