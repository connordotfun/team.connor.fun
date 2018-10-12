module Profile exposing (..)

import Browser
import Html exposing (Html, div, text, img)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onMouseEnter, onMouseLeave, onClick)

type alias Profile = 
  { imageName: String
  , personName: String
  , personTitle: String
  }

view : Profile -> (Profile -> msg) -> (Profile -> msg) -> (Profile -> msg) -> Html msg
view profile enterHandler exitHandler clickHandler = 
  div
    [ class "profile"
    , onMouseEnter (enterHandler profile) 
    , onMouseLeave (exitHandler profile)
    , onClick (clickHandler profile)
    ]
    [ div [class "profile-inner"] 
      [ div [ class "profile-image" ][ img [src "res/connor-nologo.jpg"][] ]
      , div [ class "profile-name" ][ text profile.personName ]
      , div [ class "profile-title" ][ text profile.personTitle ]
      ]
    ]

  