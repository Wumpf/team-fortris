      integer :: Fld(15, 33)
c     Last index is the player id 
      integer :: TetPos(2,2)
      integer :: TetFld(-2:2, -2:2, 2)
      integer :: tkPaus
      integer :: State
      common /gState/ Fld, TetPos, TetFld, tkPaus, State

      integer :: stPlay, stWin1, stWin2, stShft, stPaus
      parameter(stPlay=0, stWin1=1, stWin2=2, stShft=3, stPaus=4)

c     Block enum
      integer :: blkNON,
     +           blkI, blkO, blkT, blkS, blkZ, blkJ, blkL, 
     +           blkFIX, blkMvL, blkMvR, blkMvN
      
      parameter(blkNON = 0)
      parameter(blkI = 1, blkO = 2, blkT = 3, blkS = 4, blkZ = 5,
     +          blkJ = 6, blkL = 7)
      parameter(blkFIX = 8)
      parameter(blkMvL = 9, blkMvR = 10, blkMvN = 11)