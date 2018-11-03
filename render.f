      subroutine render(rnd, tkIdx)
      use iso_c_binding
      use sdl2

      include 'state.h'

      type(c_ptr) :: rnd
      integer :: tkIdx

      integer :: x, y, blkCol
      
      integer result
      type(SDL_Rect) rects(1)

c     Block size in pixels
      integer :: RectSz
      parameter(RectSz = 50)

c     Colors for IOTSZJL, fix
      integer(1) colors(4, 8)
      data colors/-1, 0, -1, -1,
     +            -1, -1, 0, -1,
     +            100, 0, -1, -1,
     +            0, -1, 0, -1,
     +            -1, 0, 0, -1,
     +            0, 0, -1, -1,
     +            -1, 100, 0, -1,
     +            100, 100, 100, -1/

      integer(1) bgCol(4)
      data bgCol/0, 0, 0, -1/   

c     Clear background
      result = SDL_SetRenderDrawColor(rnd,
     +    bgCol(1), bgCol(2), bgCol(3), bgCol(4))
      result = SDL_RenderClear(rnd)

c     Loop through x,y and render blocks
      x = 1
 10   y = 1
 20   blkCol = Fld(y, x)

c     If background, don't render anything
      if (blkCol .ne. 0) then

c       Render rectangle
        result = SDL_SetRenderDrawColor(rnd,
     +    colors(1, blkCol),
     +    colors(2, blkCol),
     +    colors(3, blkCol),
     +    colors(4, blkCol))

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

      call SDL_RenderPresent(rnd)

      end subroutine render
