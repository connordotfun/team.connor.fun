import Browser
import Html exposing (Html, button, div, text, img)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style, src)
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
  {cofounders = cofounders, members = members, selectedProfile = Just (Profile "foo" "foo" "foo")}


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
    , div [ class "important-people" ] (viewProfiles model.cofounders) 
    , div [ class "team-people-title" ] [ text "Meet the Team" ]
    , div [ class "team-people"] (viewProfiles model.members)
    ]


viewBio : Maybe Profile -> Html Msg
viewBio selectedProfile =
  case selectedProfile of
    Just profile ->
      div [class "bio-container-container"]
      [ div [ class "bio-container-background", onClick BioExit] []
      , div [ class "bio-container", style "visibility" "visible" ] 
          [ div [class "bio-close-btn", onClick BioExit] [text "×"]
          , img [class "bio-image", src "res/connor-nologo.jpg"][]
          , viewBioInfo profile
          , viewBioText profile
          ]
      ]
      
    Nothing ->
      div [ class "bio-container", style "visibility" "hidden" ] []


viewBioInfo : Profile -> Html Msg
viewBioInfo p =
  div [ class "bio-info-container "]
    [ div [class "bio-name"] [ text p.personName ]
    , div [class "bio-title"] [text p.personTitle ]
    , div [class "bio-tags"] [text "Person, Worker, Boring Person"]
    ]

viewBioText : Profile -> Html Msg
viewBioText p =
  div [ class "bio-text" ] [text "these are the voyages of the starship enterprise on it's ongoing mission to explore stange new worlds and seek out new life and civilizations"]



viewProfiles : List Profile -> List (Html Msg)
viewProfiles = 
  List.map (Profile.view (ProfileEnter) (ProfileLeave) (ProfileClicked))