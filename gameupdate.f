      subroutine gameupdate(tkIdx)
      integer :: tkIdx
      include 'state.h'
      
      Fld(1,1) = Fld(1,1) + 10
      if (Fld(1,1) .ge. 800) then
        Fld(1,1) = 1
      endif
      
      end subroutine gameupdate
