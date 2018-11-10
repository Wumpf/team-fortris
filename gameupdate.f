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
            Fld(y, x) = blkNON

            if ((x .eq. int(size(Fld, 2)/2) + 1) .or.
     +          (y .eq. 1) .or. (y .eq. size(Fld, 1))) then
                  Fld(y, x) = blkFIX
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
          if (.not. RotDwn(1)) then
            BlkRot(1) = .true.
          endif
          RotDwn(1) = .true.
        else
          RotDwn(1) = .false.
        endif
        if (is_key_down(79)) then
          if (.not. RotDwn(2)) then
            BlkRot(2) = .true.
          endif
          RotDwn(2) = .true.
        else
          RotDwn(2) = .false.
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
        real :: randR
        integer:: randI
        include 'state.h'
c       Shape of the tetrominos. Add more later.
        integer :: tetBlk(-2:2, -2:2, 7)
        data tetBlk/0,0,1,0,0,
     +              0,0,1,0,0,
     +              0,0,1,0,0,
     +              0,0,1,0,0,
     +              0,0,0,0,0,
     +
     +              0,0,0,0,0,
     +              0,0,2,2,0,
     +              0,0,2,2,0,
     +              0,0,0,0,0,
     +              0,0,0,0,0,
     +
     +              0,0,0,0,0,
     +              0,0,3,0,0,
     +              0,3,3,3,0,
     +              0,0,0,0,0,
     +              0,0,0,0,0,
     +
     +              0,0,0,0,0,
     +              0,4,0,0,0,
     +              0,4,4,0,0,
     +              0,0,4,0,0,
     +              0,0,0,0,0,
     +
     +              0,0,0,0,0,
     +              0,0,0,5,0,
     +              0,0,5,5,0,
     +              0,0,5,0,0,
     +              0,0,0,0,0,
     +
     +              0,0,0,0,0,
     +              0,0,6,0,0,
     +              0,0,6,0,0,
     +              0,6,6,0,0,
     +              0,0,0,0,0,
     +
     +              0,0,0,0,0,
     +              0,0,7,0,0,
     +              0,0,7,0,0,
     +              0,0,7,7,0,
     +              0,0,0,0,0/
c     ------------------------------------------------------------------
        call random_number(randR)
        randI = 1 + floor((7)*randR)
        TetFld(:, :, player) = tetBlk(:, :, randI)


        if (player .eq. 1) then
          TetPos(1,1) = size(Fld, 1)/2 + 1
          TetPos(2,1) = 0
        endif
        if (player .eq. 2) then
          TetPos(1,2) = TetPos(1,1)
          TetPos(2,2) = size(Fld, 2)
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
            if ((tet(ty, tx) .eq. 0) .or.
     +          x + tx .gt. size(Fld, 2) .or.
     +          x + tx .le. 0) then
              goto 40
            endif
            if (y + ty .gt. size(Fld, 1) .or.
     +          y + ty .le. 0 ) then
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
      subroutine rotate_tet(player, result)
        integer :: player
        integer :: result(-2:2, -2:2)
        integer :: tx, ty
        include 'state.h'
c     ------------------------------------------------------------------
        tx = -2
 20     if (tx .le. 2) then
          ty = -2
 30       if (ty .le. 2) then
            result(ty, tx) = TetFld(tx, -ty, player)
            ty = ty + 1
            goto 30
          endif
          tx = tx + 1
          goto 20
        endif
      end subroutine rotate_tet
c#######################################################################
      subroutine lose_player(player)
        integer :: player
        include 'state.h'
c     ------------------------------------------------------------------
        write(*,*) 'Player died: ', player

      end subroutine lose_player
c#######################################################################
      subroutine arrive_tet(player)
        integer :: player
        integer :: tx, ty, px, py
        integer :: minX, maxX
        include 'state.h'
c     ------------------------------------------------------------------  
        minX = 999
        maxX = 0
        tx = -2
 20     if (tx .le. 2) then
          ty = -2
 30       if (ty .le. 2) then
            if (TetFld(ty, tx, player) .gt. 0) then
              px = TetPos(2, player) + tx
              py = TetPos(1, player) + ty
              if (px .gt. size(Fld, 2) .or.
     +            px .le. 0) then
                call lose_player(player)
                goto 40
              endif
              Fld(TetPos(1, player) + ty, TetPos(2, player) + tx) =
     +            TetFld(ty, tx, player)
              maxX = max(maxX, TetPos(2, player) + tx)
              minX = min(minX, TetPos(2, player) + tx)
            endif
            ty = ty + 1
            goto 30
          endif
          tx = tx + 1
          goto 20
        endif

        call check_for_fix_lines(minX, maxX)
        call new_tet(player)
 40   end subroutine arrive_tet

c#######################################################################
      subroutine check_for_fix_lines(minX, maxX)
        integer :: minX, maxX
        integer :: tx, ty
        include 'state.h'
c     ------------------------------------------------------------------  
        tx = minX
 20     if (tx .le. maxX) then
          ty = 2
 30       if (ty .le. size(Fld, 1) - 1) then
            if (Fld(ty, tx) .eq. blkNON) then
              goto 40
            endif
            ty = ty + 1
            goto 30
          endif

          ty = 2
 50       if (ty .le. size(Fld, 1) - 1) then
            Fld(ty, tx) = blkBli
            ty = ty + 1
            goto 50
          endif

 40       tx = tx + 1
          goto 20
        endif
      end subroutine check_for_fix_lines
c#######################################################################
      subroutine gameupdate(tkIdx)
        integer :: tkIdx
        include 'state.h'
        logical :: is_key_down
        logical :: check_tet
        integer :: player
        integer :: x, y, tx, ty
        integer :: rotTet(-2:2, -2:2)
c     ------------------------------------------------------------------       
        player = 1
 10     if (player .le. 2) then

          if (BlkMov(player) .ne. 0) then
            if (check_tet(TetFld(:,:,player),
     +                    TetPos(2, player),
     +                    TetPos(1, player) + BlkMov(player))) then
              TetPos(1, player) = TetPos(1, player) + BlkMov(player)
            endif
            BlkMov(player) = 0
          endif

          if (BlkRot(player)) then
            call rotate_tet(player, rotTet)
            if (check_tet(rotTet,
     +                    TetPos(2, player),
     +                    TetPos(1, player))) then
              TetFld(:,:,player) = rotTet
            endif
            BlkRot(player) = .false.
          endif

c         Updating?
          if ((mod(tkIdx, 2) .eq. 0) .or. BlkSpd(player)) then
            if (TetPos(1, player) - 2 .ge. 1 .and.
     +          TetPos(1, player) + 2 .le. size(Fld, 1)) then

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
      end subroutine gameupdate