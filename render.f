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
      subroutine to_byte(ints, bytes, size)
      integer :: size
      integer, dimension(1:) :: ints(size)
      integer(1), dimension(1:) :: bytes(size)
      integer i
c     ------------------------------------------------------------------
      i = 1
 10   if (i .le. size) then
        if (ints(i) .gt. 127) then
          bytes(i) = int(min(ints(i), 255) - 256, 1)
        else
          bytes(i) = int(max(0, ints(i)), 1)
        endif
        i = i + 1
        goto 10
      endif
      end subroutine
c#######################################################################
c     Renders a single block
c     Batching blocks of the same color would make this much more efficient,
c     but for simplicity we do everything one by one every frame.
      subroutine render_blk(rnd, x, y, blkCol)
      use sdl2
      type(c_ptr) :: rnd
      integer :: x, y, blkCol
      include 'state.h'
      include 'screenstate.h'
      integer result
      type(SDL_Rect) rects(1)
c     Colors for IOTSZJL, fix
      integer colors(4, 8)
      data colors/240, 5, 240, 240,
     +            240, 240, 5, 240,
     +            127, 5, 240, 240,
     +            5, 240, 5, 240,
     +            240, 5, 5, 240,
     +            5, 5, 240, 240,
     +            240, 127, 5, 240,
     +            127, 127, 127, 240/
      integer(1) colorB(4)
      real border
      parameter(border = 0.2)
c     ------------------------------------------------------------------
      if (blkCol .eq. blkNON) then
        return
      endif

c     "normal" border, bottom left
      call to_byte(colors(:, blkCol), colorB, 4)
      result = SDL_SetRenderDrawColor(rnd,
     +  colorB(1), colorB(2), colorB(3), colorB(4))
      rects(1)%x = (x-1) * BlkSz + FldTLX
      rects(1)%y = (y-1) * BlkSz + FldTLY
      rects(1)%w = BlkSz
      rects(1)%h = BlkSz
      result = SDL_RenderFillRects(rnd, rects, 1)

c     Dark border, top right
      call to_byte(int(colors(:, blkCol) * 0.8), colorB, 4)
      result = SDL_SetRenderDrawColor(rnd,
     +  colorB(1), colorB(2), colorB(3), colorB(4))
      rects(1)%w = int(BlkSz * (1.0 - border))
      rects(1)%h = rects(1)%w
      rects(1)%x = (x-1) * BlkSz + FldTLX + (BlkSz - rects(1)%w)
      rects(1)%y = (y-1) * BlkSz + FldTLY
      result = SDL_RenderFillRects(rnd, rects, 1)

c     Bright middle
      call to_byte(int(colors(:, blkCol) + 60), colorB, 4)
      result = SDL_SetRenderDrawColor(rnd,
     +  colorB(1), colorB(2), colorB(3), colorB(4))
      rects(1)%w = int(BlkSz * (1.0 - border * 2))
      rects(1)%h = rects(1)%w
      rects(1)%x = (x-1) * BlkSz + FldTLX + (BlkSz - rects(1)%w) / 2
      rects(1)%y = (y-1) * BlkSz + FldTLY + (BlkSz - rects(1)%w) / 2
      result = SDL_RenderFillRects(rnd, rects, 1)

      end subroutine
c#######################################################################
      subroutine render_fld(rnd)
      use iso_c_binding
      type(c_ptr) :: rnd
      include 'state.h'
      integer :: x, y, player
c     ------------------------------------------------------------------
      x = 1
 10   if (x .le. size(Fld, 2)) then
        y = 1
 20     if (y .le. size(Fld, 1)) then
          call render_blk(rnd, x, y, Fld(y,x))
          y = y + 1
          goto 20
        endif
        x = x + 1
        goto 10
      endif

c     Render player tets
      player = 1
 50   if (player .le. 2) then
        x = -2
 30     if (x .le. 2) then
          y = -2
 40       if (y .le. 2) then
            call render_blk(rnd,
     +            TetPos(2, player) + x, TetPos(1, player) + y,
     +            TetFld(y, x, player))
            y = y + 1
            goto 40
          endif
          x = x + 1
          goto 30
        endif
        player = player + 1
        goto 50
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

      BlkSz = min(w / fldSzX, h / fldSzY)
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
c      call debug_fill_field()
      call render_fld(rnd)

      call SDL_RenderPresent(rnd)
      end subroutine render
c#######################################################################