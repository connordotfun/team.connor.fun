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
  {cofounders = cofounders, members = members}


-- UPDATE

type Msg 
  = ProfileMsg Profile.Msg 

update : Msg -> Model -> Model
update msg model =
  model

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "content" ]
    [ div [ class "page-title" ] [ text "The connor.fun Crew" ] 
    , div [ class "important-people-title"] [ text "Meet the Cofounders" ] 
    , div [ class "important-people" ] (viewProfiles cofounders) 
    , div [ class "team-people-title" ] [ text "Meet the Team" ]
    , div [ class "team-people"] (viewProfiles members)
    ]


viewBio : Maybe Profile -> Html Msg
viewBio selectedProfile =
  case selectedProfile of
    Just profile ->
      div [ class "bio-container", style "visibility" "visible" ] [ (text "this is a bio for " ++ profile.personName) ]
    Nothing ->
      div [ class "bio-container", style "visibility" "hidden" ] []


profileMsgToMsg : Html Profile.Msg -> Html Msg
profileMsgToMsg = 
  Html.map (\msg -> ProfileMsg msg)



viewProfiles : List Profile -> List (Html Msg)
viewProfiles = 
  List.map (profileMsgToMsg << Profile.view)