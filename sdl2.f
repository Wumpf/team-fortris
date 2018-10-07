      module sdl2
      use iso_c_binding
      implicit none

      type, bind(c) :: SDL_Event
            integer(c_int32_t) :: etype
            integer(c_int32_t) :: timestamp
            integer(c_int8_t) :: data(48)
      end type SDL_Event

      interface
            function SDL_Init(flags) bind(c, name='SDL_Init')
                  use iso_c_binding
                  implicit none
                  integer(c_int32_t) :: flags
                  integer(c_int) :: SDL_Init
            end function SDL_Init

            subroutine SDL_Quit() bind(c, name='SDL_Quit')
            end subroutine SDL_Quit
            
            subroutine SDL_DestroyWindow(window)
     +        bind(c, name='SDL_DestroyWindow')
                  use iso_c_binding
                  implicit none
                  type(c_ptr) :: window
            end subroutine SDL_DestroyWindow
            
            function SDL_CreateWindow(title, x, y, w, h, flags)
     +        bind(c, name='SDL_CreateWindow')
                  use iso_c_binding
                  implicit none
                  character(c_char), intent(in) :: title(*)
                  integer(c_int), value :: x
                  integer(c_int), value :: y
                  integer(c_int), value :: w
                  integer(c_int), value :: h
                  integer(c_int32_t), value :: flags
                  type(c_ptr) :: SDL_CreateWindow
            end function SDL_CreateWindow

            function SDL_PollEvent(event)
     +        bind(c, name='SDL_PollEvent')
                  use iso_c_binding
                  import :: SDL_Event
                  implicit none
                  type(SDL_Event), intent(out) :: event
                  integer(c_int) :: SDL_PollEvent
            end function SDL_PollEvent
      end interface

      end module sdl2