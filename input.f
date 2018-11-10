c#######################################################################
      subroutine input_update()
        include 'input.h'
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