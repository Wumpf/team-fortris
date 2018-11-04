      integer :: Fld(16, 33)
c     Last index is the player id 
      integer :: TetPos(2,2)
      integer :: TetFld(-2:2, -2:2, 2)
      common /gState/ Fld, TetPos, TetFld

      integer :: BlkMov(2)
      logical :: BlkSpd(2)
      logical :: BlkRot(2)
      common /gInput/ BlkMov, BlkSpd, BlkRot

c     Block enum
      integer :: blkNON,
     +           blkI, blkO, blkT, blkS, blkZ, blkJ, blkL, 
     +           blkFIX
      
      parameter(blkNON = 0)
      parameter(blkI = 1, blkO = 2, blkT = 3, blkS = 4, blkZ = 5,
     +          blkJ = 6, blkL = 7)
      parameter(blkFIX = 8)