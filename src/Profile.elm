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


type Msg 
  = StartHover Profile
  | EndHover Profile
  | Clicked Profile 

view : Profile -> (() -> Msg) -> Html Msg
view profile clickHandler = 
  div
    [ class "profile"
    , onMouseEnter (StartHover profile) 
    , onMouseLeave (EndHover profile)
    , onClick (Clicked profile)
    ]
    [ div [class "profile-inner"] 
      [ div [ class "profile-image" ][ img [src "res/connor-nologo.jpg"][] ]
      , div [ class "profile-name" ][ text profile.personName ]
      , div [ class "profile-title" ][ text profile.personTitle ]
      ]
    ]

  
update : Profile -> Msg -> Profile
update profile msg =
  case msg of 
    StartHover p ->
      profile
    EndHover p ->
      profile
    Clicked p ->
      profile -- hmmm, this is illegal state...
  