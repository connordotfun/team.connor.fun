import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Profile exposing (Profile)
import TeamMembers exposing (cofounders, members)
import List


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = Int

init : Model
init =
  0


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

  


profileMsgToMsg : Html Profile.Msg -> Html Msg
profileMsgToMsg = 
  Html.map (\msg -> ProfileMsg msg)

viewProfiles : List Profile -> List (Html Msg)
viewProfiles = 
  List.map (profileMsgToMsg << Profile.view)