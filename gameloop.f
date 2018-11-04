c#######################################################################
      program main
      use iso_c_binding
      use sdl2

      type(c_ptr) window, rnd
      type(SDL_Event) event
      integer sdlres

      integer tkIdx
      real tCur, tLstTk ! time at which the last tick occured
      real tkLen
      parameter(tklen = 0.2) ! Tick duration in seconds

      external gameupdate, render, init_field
c     ------------------------------------------------------------------

c     Init SDL with (SDL_INIT_TIMER | SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER)
      sdlres = SDL_Init(8225)
c     (SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI) = 0x00002020 = 8224
      window = SDL_CreateWindow('Team Fortris', 100, 100, 
     +                          1024, 768, 8224)
c     Init renderer with SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
      rnd = SDL_CreateRenderer(window, -1, 6);

      call init_field()

      tLstTk = -1
      tkIdx = 0

c     Gameloop & message pump
   10 continue
c       Consume all messages
   20   sdlres = SDL_PollEvent(event)
        if (sdlres .ne. 0) then
c         Quit received
          if (event%etype .eq. 256) goto 30
          goto 20
        endif

        call input_update()

c       Determine whether it is time to do a tick
        call cpu_time(tCur)
        if (tCur - tLstTk .ge. tkLen) then 
          tLstTk = tLstTk + tkLen
          tkIdx = tkIdx + 1
          call gameupdate(tkIdx)
          call render(rnd, tkIdx)
        endif

      goto 10

   30 call SDL_DestroyRenderer(rnd)
      call SDL_DestroyWindow(window)
      call SDL_Quit()
      stop
      end program
c#######################################################################