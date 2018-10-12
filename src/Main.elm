import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)
import Profile exposing (Profile)
import TeamMembers exposing (cofounders, members)
import List


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = 
  { cofounders: List Profile
  , members: List Profile
  , selectedProfile: Maybe Profile
  }

init : Model
init =
  {cofounders = cofounders, members = members, selectedProfile = Nothing}


-- UPDATE

type Msg 
  = ProfileClicked Profile
  | ProfileEnter Profile
  | ProfileLeave Profile
  | BioExit

update : Msg -> Model -> Model
update msg model =
  case msg of
    ProfileClicked p ->
      case model.selectedProfile of --if the user clicks anywhere off the bio, they are asking for exit
        Just _ ->
          update BioExit model
        Nothing ->
          {model | selectedProfile = Just p}
    
    BioExit ->
      {model | selectedProfile = Nothing}

    _ ->
      model

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "content" ]
    [ viewBio model.selectedProfile
    , div [ class "page-title" ] [ text "The connor.fun Crew" ] 
    , div [ class "important-people-title"] [ text "Meet the Cofounders" ] 
    , div [ class "important-people" ] (viewProfiles cofounders) 
    , div [ class "team-people-title" ] [ text "Meet the Team" ]
    , div [ class "team-people"] (viewProfiles members)
    ]


viewBio : Maybe Profile -> Html Msg
viewBio selectedProfile =
  case selectedProfile of
    Just profile ->

      div [class "bio-container-container"]
      [ div [ class "bio-container-background"] []
      , div [ class "bio-container", style "visibility" "visible" ] 
          [ div [class "bio-close-btn", onClick BioExit] [text "×"]

          ]
      ]
      
    Nothing ->
      div [ class "bio-container", style "visibility" "hidden" ] []



viewProfiles : List Profile -> List (Html Msg)
viewProfiles = 
  List.map (\p -> Profile.view p (ProfileEnter) (ProfileLeave) (ProfileClicked))