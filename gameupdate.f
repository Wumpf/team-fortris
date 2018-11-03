      function is_key_down(keyCo)
        use iso_c_binding
        use sdl2
        logical :: is_key_down
        integer :: keyCo

        type(c_ptr) :: keysC
        integer(1), pointer :: keys(:)
        integer :: numKc
        integer :: numKcA(1)

        keysC = SDL_GetKeyboardState(numKc)
        numKcA(1) = numKc
        call c_f_pointer(keysC, keys, numKcA)

        is_key_down = keys(keyCo + 1) .eq. 1
      end function
      

      subroutine gameupdate(tkIdx)
        integer :: tkIdx
        include 'state.h'

        logical :: is_key_down

        Fld(2,2) = 4

        if (is_key_down(79)) then
          Fld(4,4) = 4
        endif
        if (is_key_down(80)) then
          Fld(1,1) = 5
        endif

        if (Fld(1,1) .ge. 800) then
          Fld(1,1) = 1
        endif
      end subroutine gameupdate
