c#######################################################################
c     Fill entire field for debugging
      subroutine debug_fill_field()
      include 'state.h'
      integer :: x=1, y=1
c     ------------------------------------------------------------------
 10   if (x .le. size(Fld, 2)) then
        y = 1
 20     if (y .le. size(Fld, 1)) then
          Fld(y, x) = mod(x + y, (blkFIX+1))
          y = y + 1
          goto 20
        endif
        x = x + 1
        goto 10
      endif
      end subroutine debug_fill_field
c#######################################################################
c     Renders a single block
c     Batching blocks of the same color would make this much more efficient,
c     but for simplicity we do everything one by one every frame.
      subroutine render_blk(rnd, x, y)
      use sdl2
      type(c_ptr) :: rnd
      integer :: x, y
      include 'state.h'
      include 'screenstate.h'
      integer result
      type(SDL_Rect) rects(1)
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
c     ------------------------------------------------------------------
      if (Fld(y, x) .eq. blkNON) then
        return
      endif

c     Render rectangle
      result = SDL_SetRenderDrawColor(rnd,
     +  colors(1, Fld(y, x)),
     +  colors(2, Fld(y, x)),
     +  colors(3, Fld(y, x)),
     +  colors(4, Fld(y, x)))

      rects(1)%x = (x-1) * BlkSz + FldTLX
      rects(1)%y = (y-1) * BlkSz + FldTLY
      rects(1)%w = BlkSz
      rects(1)%h = BlkSz

      result = SDL_RenderFillRects(rnd, rects, 1)

      end subroutine
c#######################################################################
      subroutine render_fld(rnd)
      use iso_c_binding
      type(c_ptr) :: rnd
      include 'state.h'
      integer :: x, y
c     ------------------------------------------------------------------
      x = 1
 10   if (x .le. size(Fld, 2)) then
        y = 1
 20     if (y .le. size(Fld, 1)) then
          call render_blk(rnd, x, y)
          y = y + 1
          goto 20
        endif
        x = x + 1
        goto 10
      endif
      end subroutine render_fld
c#######################################################################
      subroutine update_screen_params(rnd)
      use sdl2
      type(c_ptr) :: rnd
      include 'state.h'
      include 'screenstate.h'
      integer result, w, h
      integer fldSzX, fldSzY
c     ------------------------------------------------------------------
      fldSzX = size(Fld, 2)
      fldSzY = size(Fld, 1)
      result = SDL_GetRendererOutputSize(rnd, w, h)

      BlkSz = min(w / fldSzX, w / fldSzY)
      FldTLX = (w - fldSzX * BlkSz) / 2
      FldTLY = (h - fldSzY * BlkSz) / 2
      end subroutine update_screen_params
c#######################################################################
      subroutine render(rnd, tkIdx)
      use sdl2
      type(c_ptr) :: rnd
      integer :: tkIdx

      integer result
      integer(1) bgCol(4)
      data bgCol/0, 0, 0, -1/
c     ------------------------------------------------------------------
      result = SDL_SetRenderDrawColor(rnd,
     +    bgCol(1), bgCol(2), bgCol(3), bgCol(4))
      result = SDL_RenderClear(rnd)

      call update_screen_params(rnd)
c     call debug_fill_field()
      call render_fld(rnd)

      call SDL_RenderPresent(rnd)
      end subroutine render
c#######################################################################