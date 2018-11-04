c#######################################################################
c     Checks for a given SDL scan code whether the key is down.
      function is_key_down(keyCo)
      use iso_c_binding
      use sdl2
      logical :: is_key_down
      integer :: keyCo
      type(c_ptr) :: keysC
      integer(1), pointer :: keys(:)
      integer :: numKc
      integer :: numKcA(1)
c     ------------------------------------------------------------------
      keysC = SDL_GetKeyboardState(numKc)
      numKcA(1) = numKc
      call c_f_pointer(keysC, keys, numKcA)

      is_key_down = keys(keyCo + 1) .eq. 1
      end function
c#######################################################################
      subroutine init_field()
        include 'state.h'
        integer :: x=1, y=1
c     ------------------------------------------------------------------
 10     if (x .le. size(Fld, 2)) then
          y = 1
 20       if (y .le. size(Fld, 1)) then
            Fld(y, x) = 0

            if (x == int(size(Fld, 2)/2) + 1) then
                  Fld(y, x) = 8
            endif
            y = y + 1
            goto 20
          endif
          x = x + 1
          goto 10
        endif

        call new_tet(1)
        call new_tet(2)

      end subroutine init_field
c#######################################################################
      subroutine input_update()
        include 'state.h'
        logical :: is_key_down
c     ------------------------------------------------------------------
c     Rotating
        if (is_key_down(4)) then
          BlkRot(1) = .true.
        endif
        if (is_key_down(79)) then
          BlkRot(2) = .true.
        endif

c     Up/down
        if (is_key_down(26)) then
          BlkMov(1) = -1
        endif
        if (is_key_down(82)) then
          BlkMov(2) = -1
        endif

        if (is_key_down(22)) then
          BlkMov(1) = 1
        endif
        if (is_key_down(81)) then
          BlkMov(2) = 1
        endif

c     Speedup
        if (is_key_down(7)) then
          BlkSpd(1) = .true.
        endif
        if (is_key_down(80)) then
          BlkSpd(2) = .true.
        endif
      end subroutine input_update
c#######################################################################
      subroutine new_tet(player)
        integer :: player
        integer :: tx, ty
        include 'state.h'
c       Shape of the tetrominos. Add more later.
        integer :: tetBlk(-2:2, -2:2, 1)
        data tetBlk/0,0,0,0,0,
     +              0,0,0,0,0,
     +              0,1,1,1,1,
     +              0,0,0,0,0,
     +              0,0,0,0,0/
c     ------------------------------------------------------------------
        tx = -2
 20     if (tx .le. 2) then
          ty = -2
 30       if (ty .le. 2) then
            TetFld(ty, tx, player) = tetBlk(ty, tx, 1)
            ty = ty + 1
            goto 30
          endif
          tx = tx + 1
          goto 20
        endif

        if (player .eq. 1) then
          TetPos(1,1) = size(Fld, 1)/2 + 1
          TetPos(2,1) = 3
        endif
        if (player .eq. 2) then
          TetPos(1,2) = TetPos(1,1)
          TetPos(2,2) = size(Fld, 2)-2
        endif

      end subroutine new_tet
c#######################################################################
      function check_tet(tet, x, y)
        logical :: check_tet
        integer :: x, y
        integer :: tet(-2:2, -2:2)
        integer :: tx, ty
        include 'state.h'
c     ------------------------------------------------------------------
        tx = -2
 20     if (tx .le. 2) then
        ty = -2
 30       if (ty .le. 2) then
            if ((tet(ty, tx) .eq. 0)) then
              goto 40
            endif
            if (y + ty .gt. size(Fld, 1)) then
c            .or.
c     +          y + ty .le. 0 .or.
c     +          x + tx .gt. size(Fld, 2)
c     +          x + tx .le. 0) then
              check_tet = .false.
              return
            endif
            if (Fld(y + ty, x + tx) .gt. 0) then
              check_tet = .false.
              return
            endif
 40         ty = ty + 1
            goto 30
          endif
          tx = tx + 1
          goto 20
        endif
        check_tet = .true.
      end function
c#######################################################################
      subroutine rotate_tet(player)
        integer :: player
      end subroutine rotate_tet
c#######################################################################
      subroutine arrive_tet(player)
        integer :: player
        integer :: tx, ty
        include 'state.h'
c     ------------------------------------------------------------------  
        tx = -2
 20     if (tx .le. 2) then
          ty = -2
 30       if (ty .le. 2) then
            if (TetFld(ty, tx, player) .gt. 0) then
              Fld(TetPos(1, player) + ty, TetPos(2, player) + tx) =
     +            TetFld(ty, tx, player)
            endif
            ty = ty + 1
            goto 30
          endif
          tx = tx + 1
          goto 20
        endif

        call new_tet(player)
      end subroutine arrive_tet
c#######################################################################
      subroutine gameupdate(tkIdx)
        integer :: tkIdx
        include 'state.h'
        logical :: is_key_down
        logical ::check_tet
        integer :: player
        integer :: x, y, tx, ty
c     ------------------------------------------------------------------       
        player = 1
 10     if (player .le. 2) then

c         Updating?
          if ((mod(tkIdx, 2) .eq. 0) .or. BlkSpd(player)) then
            if (TetPos(1, player) - 2 .ge. 1 .and.
     +          TetPos(1, player) + 2 .le. size(Fld, 1)) then

            endif

            if (BlkRot(player)) then
              call rotate_tet(player)
            endif

            x = TetPos(2, player) + 3 - 2*player
            if (check_tet(TetFld(:,:,player),
     +                    x, TetPos(1, player))) then
              TetPos(2, player) = x
            else
              call arrive_tet(player)
            endif
c           Reset input
            BlkMov(player) = 0
            BlkSpd(player) = .false.
            BlkRot(player) = .false.
          endif

          player = player + 1
          goto 10
        endif

        Fld(1,1) = 4

        if (is_key_down(79)) then
          Fld(4,4) = 4
        endif
        if (is_key_down(80)) then
          Fld(1,1) = 5
        endif

      end subroutine gameupdate