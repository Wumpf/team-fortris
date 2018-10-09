      program main
      use iso_c_binding
      use sdl2

      type(c_ptr) window
      type(SDL_Event) event
      integer sdlres
      

c     Init SDL with (SDL_INIT_TIMER | SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER)
      sdlres = SDL_Init(8225)
      window = SDL_CreateWindow('Team Fortris', 100, 100, 1024, 768, 0)

      
c     Gameloop & message pump
   10 continue
c           Consume all messages
   20       sdlres = SDL_PollEvent(event)
            if (sdlres .ne. 0) then
c                 Quit received
                  if (event%etype .eq. 256) goto 30
                  goto 20
            endif

c     TODO: Update, render, present
      goto 10

   30 call SDL_DestroyWindow(window)
      call SDL_Quit()
      stop
      end program
