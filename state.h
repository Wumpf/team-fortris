      integer :: Fld(8, 33)
c     Last index is the player id 
      integer :: TetPos(2,2)
      integer :: TetFld(-2:2, -2:2, 2)
      common /gState/ Fld, TetPos, TetFld

c     Block enum
      integer :: blkNON,
     +           blkI, blkO, blkT, blkS, blkZ, blkJ, blkL, 
     +           blkFIX, blkBli
      
      parameter(blkNON = 0)
      parameter(blkI = 1, blkO = 2, blkT = 3, blkS = 4, blkZ = 5,
     +          blkJ = 6, blkL = 7)
      parameter(blkFIX = 8)
      parameter(blkBli = 12)