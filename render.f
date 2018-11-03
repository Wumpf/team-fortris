c     Fill entire field for debugging
      subroutine debug_fill_field()
        include 'state.h'

        integer :: x=1, y=1
 10     if (x .le. size(Fld, 2)) then
          y = 1
 20       if (y .le. size(Fld, 1)) then
            Fld(y, x) = mod(x + y, (blkFIX+1))
            y = y + 1
            goto 20
          endif
          x = x + 1
          goto 10
        endif
      end subroutine debug_fill_field


      subroutine render_field(rnd)
        use iso_c_binding
        use sdl2
        type(c_ptr) :: rnd

        include 'state.h'

        integer result
        type(SDL_Rect) rects(1)

c       Block size in pixels
        integer :: RectSz
        parameter(RectSz = 30)

        integer :: x, y, blkCol

c       Colors for IOTSZJL, fix
        integer(1) colors(4, 8)
        data colors/-1, 0, -1, -1,
     +              -1, -1, 0, -1,
     +              100, 0, -1, -1,
     +              0, -1, 0, -1,
     +              -1, 0, 0, -1,
     +              0, 0, -1, -1,
     +              -1, 100, 0, -1,
     +              100, 100, 100, -1/

        call debug_fill_field()

c       Loop through x,y and render blocks
        x = 1
 10     y = 1
 20     blkCol = Fld(y, x)

c       If background, don't render anything
        if (blkCol .ne. 0) then
  
c         Render rectangle
          result = SDL_SetRenderDrawColor(rnd,
     +      colors(1, blkCol),
     +      colors(2, blkCol),
     +      colors(3, blkCol),
     +      colors(4, blkCol))
  
          rects(1)%x = (x-1) * RectSz
          rects(1)%y = (y-1) * RectSz
          rects(1)%w = RectSz
          rects(1)%h = RectSz
  
          result = SDL_RenderFillRects(rnd, rects, 1)
        endif
  
          y = y + 1
          if (y .le. size(Fld, 1)) then
            goto 20
          endif
  
        x = x + 1
        if (x .le. size(Fld, 2)) then
          goto 10
        endif
      end subroutine render_field


      subroutine render(rnd, tkIdx)
        use iso_c_binding
        use sdl2
        type(c_ptr) :: rnd
        integer :: tkIdx

        integer result
        integer(1) bgCol(4)
        data bgCol/0, 0, 0, -1/

c       Clear background
        result = SDL_SetRenderDrawColor(rnd,
     +      bgCol(1), bgCol(2), bgCol(3), bgCol(4))
        result = SDL_RenderClear(rnd)

        call render_field(rnd)

        call SDL_RenderPresent(rnd)
      end subroutine render