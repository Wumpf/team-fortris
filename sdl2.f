      module sdl2
      use iso_c_binding

      type, bind(c) :: SDL_Event
        integer(c_int32_t) :: etype
        integer(c_int32_t) :: timestamp
        integer(c_int8_t) :: data(48)
      end type SDL_Event

      type, bind(c) :: SDL_Rect
        integer(c_int) :: x
        integer(c_int) :: y
        integer(c_int) :: w
        integer(c_int) :: h
      end type SDL_Rect

      interface
        function SDL_Init(flags) bind(c, name='SDL_Init')
            use iso_c_binding
          integer(c_int32_t) :: flags
          integer(c_int) :: SDL_Init
        end function SDL_Init

        subroutine SDL_Quit() bind(c, name='SDL_Quit')
        end subroutine SDL_Quit
        
        subroutine SDL_DestroyWindow(window)
     +      bind(c, name='SDL_DestroyWindow')
          use iso_c_binding
          type(c_ptr) :: window
        end subroutine SDL_DestroyWindow
        
        function SDL_CreateWindow(title, x, y, w, h, flags)
     +      bind(c, name='SDL_CreateWindow')
          use iso_c_binding
          character(c_char), intent(in) :: title(*)
          integer(c_int), value :: x
          integer(c_int), value :: y
          integer(c_int), value :: w
          integer(c_int), value :: h
          integer(c_int32_t), value :: flags
          type(c_ptr) :: SDL_CreateWindow
        end function SDL_CreateWindow

        function SDL_PollEvent(event)
     +      bind(c, name='SDL_PollEvent')
          use iso_c_binding
          import :: SDL_Event
          type(SDL_Event), intent(out) :: event
          integer(c_int) :: SDL_PollEvent
        end function SDL_PollEvent

        function SDL_CreateRenderer(window, index, flags)
     +      bind(c, name='SDL_CreateRenderer')
          use iso_c_binding
          type(c_ptr), value :: window
          integer(c_int), value :: index
          integer(c_int32_t), value :: flags
          type(c_ptr) :: SDL_CreateRenderer
        end function SDL_CreateRenderer

        subroutine SDL_DestroyRenderer(renderer)
     +      bind(c, name='SDL_DestroyRenderer')
          use iso_c_binding
          type(c_ptr), value :: renderer
        end subroutine SDL_DestroyRenderer

        function SDL_RenderClear(renderer)
     +      bind(c, name='SDL_RenderClear')
          use iso_c_binding
          type(c_ptr), value :: renderer
          integer(c_int) :: SDL_RenderClear
        end function SDL_RenderClear

        subroutine SDL_RenderPresent(renderer)
     +      bind(c, name='SDL_RenderPresent')
          use iso_c_binding
          type(c_ptr), value :: renderer
        end subroutine SDL_RenderPresent

        function SDL_RenderFillRects(renderer, rects, count)
     +      bind(c, name='SDL_RenderFillRects')
          use iso_c_binding
          import :: SDL_Rect
          type(c_ptr), value :: renderer
          type(SDL_Rect), intent(in) :: rects(*)
          integer(c_int), value :: count
          integer(c_int) :: SDL_RenderFillRects
        end function SDL_RenderFillRects

        function SDL_SetRenderDrawColor(renderer, r, g, b, a)
     +      bind(c, name='SDL_SetRenderDrawColor')
          use iso_c_binding
          type(c_ptr), value :: renderer
          integer(c_int8_t), value :: r
          integer(c_int8_t), value :: g
          integer(c_int8_t), value :: b
          integer(c_int8_t), value :: a
          integer(c_int) :: SDL_SetRenderDrawColor
        end function SDL_SetRenderDrawColor

        function SDL_GetRendererOutputSize(renderer, w, h)
     +      bind(c, name='SDL_GetRendererOutputSize')
          use iso_c_binding
          import :: SDL_Rect
          type(c_ptr), value :: renderer
          integer(c_int), intent(out) :: w
          integer(c_int), intent(out) :: h
          integer(c_int) :: SDL_GetRendererOutputSize
        end function SDL_GetRendererOutputSize

c       For scan code lookup check https://www.libsdl.org/tmp/SDL/include/SDL_scancode.h
        function SDL_GetKeyboardState(numkeys)
     +       bind(c, name='SDL_GetKeyboardState')
          use iso_c_binding
          integer(c_int), intent(out) :: numkeys
          type(c_ptr) :: SDL_GetKeyboardState
        end function SDL_GetKeyboardState

      end interface

      end module sdl2
