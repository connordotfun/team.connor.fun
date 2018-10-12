module Profile exposing (..)

import Browser
import Html exposing (Html, div, text, img)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onMouseEnter, onMouseLeave)

type alias Profile = 
  { imageName: String
  , personName: String
  , personTitle: String
  }


type Msg 
  = StartHover Profile
  | EndHover Profile


view : Profile -> Html Msg
view profile = 
  div
    [ class "profile"
    , onMouseEnter (StartHover profile) 
    , onMouseLeave (EndHover profile)
    ]
    [ div [class "profile-inner"] 
      [ div [ class "profile-image" ][ img [src "res/connor-nologo.jpg"][] ]
      , div [ class "profile-name" ][ text profile.personName ]
      , div [ class "profile-title" ][ text profile.personTitle ]
      ]
    ]
    