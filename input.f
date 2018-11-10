c#######################################################################
      subroutine input_update(tkIdx)
        include 'input.h'
        include 'state.h'
        integer :: tkIdx, tkDiff
        logical :: is_key_down
        integer :: player
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

c     Skip update step 0, 2-5
        player = 1
 10     if (player .le. 2) then
          tkDiff = tkIdx - MovTk(player)
          if (BlkMov(player) .ne. 0) then
            if (MovTk(player) .eq. -1) then
              MovTk(player) = tkIdx
            endif

            if (tkDiff .le. 3 .and. tkDiff .ne. 1) then
              BlkMov(player) = 0
            endif
          else
            MovTk(player) = -1
          endif
          
          player = player + 1
          goto 10
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