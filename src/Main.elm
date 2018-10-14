import Browser
import Html exposing (Html, button, div, text, img)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style, src)
import Profile exposing (Profile)
import TeamMembers exposing (cofounders, members)
import List
import Bio exposing(..)
import Dict exposing (Dict)

import Debug

main =
  Browser.element 
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


-- MODEL

type alias ProfileInfo =
  { profile: Profile
  , bio: RemoteBio
  }


type alias Model = 
  { cofounders: List Profile
  , members: List Profile
  , selectedProfile: Maybe ProfileInfo
  , bios: Dict String RemoteBio
  }

init : () -> (Model, Cmd Msg)
init _ =
  let
    model = 
      { cofounders = cofounders
      , members = members
      , selectedProfile = Nothing
      , bios = generateInitialBios (List.append cofounders members)
      }
    in
  (model, Cmd.none)

generateInitialBios: List Profile -> Dict String RemoteBio
generateInitialBios profiles = 
  Dict.fromList (List.map (\p -> (p.imageName, Bio.NotRequested)) profiles)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- UPDATE

type Msg 
  = ProfileClicked Profile
  | ProfileEnter Profile
  | ProfileLeave Profile
  | BioExit
  | NewBioFetched String RemoteBio


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ProfileClicked p ->
      let
        (profileInfo, cmd) = selectProfileInfo p model.bios
      in
        ({model | selectedProfile = Just profileInfo}, cmd)
    
    NewBioFetched name rb ->
      ({model | bios = Dict.insert name rb model.bios}, Cmd.none)
    BioExit ->
      ({model | selectedProfile = Nothing}, Cmd.none)

    _ ->
      (model, Cmd.none)


selectProfileInfo : Profile -> Dict String RemoteBio -> (ProfileInfo, Cmd Msg)
selectProfileInfo profile bios =
  let
    (remoteBio, cmd) = selectProfileBio profile.imageName bios
  in
    (ProfileInfo profile remoteBio, cmd)


selectProfileBio : String -> Dict String RemoteBio -> (RemoteBio, Cmd Msg)
selectProfileBio name bios =
  case Dict.get name bios of
    Just rb -> 
      case rb of
        NotRequested ->
          (Fetching, fetchBio name (NewBioFetched name))
        _ -> (rb, Cmd.none)

    Nothing -> 
      (NotRequested, Cmd.none) -- it's a bit bad that this state can happen

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


viewBio : Maybe ProfileInfo -> Html Msg
viewBio selectedProfile =
  case selectedProfile of
    Just profileInfo ->
      div [class "bio-container-container"]
      [ div [ class "bio-container-background", onClick BioExit] []
      , div [ class "bio-container", style "visibility" "visible" ] 
          [ div [class "bio-close-btn", onClick BioExit] [text "×"]
          , img [class "bio-image", src "res/connor-nologo.jpg"][]
          , viewBioInfo profileInfo.profile
          , viewBioText profileInfo.bio
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

viewBioText : RemoteBio -> Html Msg
viewBioText bio =
  div [ class "bio-text" ] 
    [ Bio.viewText bio

    ]



viewProfiles : List Profile -> List (Html Msg)
viewProfiles = 
  List.map (Profile.view (ProfileEnter) (ProfileLeave) (ProfileClicked))