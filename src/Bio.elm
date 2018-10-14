module Bio exposing(Bio, RemoteBio (..), fetchBio, viewText)
import Http
import Url.Builder as Url
import Json.Decode as Decode
import Html exposing (Html, div, text)

type alias Bio = String

type RemoteBio
  = NotRequested
  | Fetching
  | Failure Http.Error
  | Succes Bio


fromResult : Result Http.Error Bio -> RemoteBio
fromResult result = 
  case result of 
    Err e -> Failure e
    Ok x -> Succes x


sendBioRequest : ((RemoteBio) -> msg) -> Http.Request Bio -> Cmd msg
sendBioRequest toMsg r =
  (Http.send (toMsg << fromResult)) r


decodeBio : Decode.Decoder Bio
decodeBio =
  Decode.at ["bio"] (Decode.string)

getBioUrl : String -> String
getBioUrl name = 
  Url.absolute ["res", "people", name ++ ".json"] []

requestBio : String -> Http.Request Bio
requestBio name =
  Http.get (getBioUrl name) decodeBio


fetchBio : String -> ((RemoteBio) -> msg) -> Cmd msg
fetchBio name toMsg =
  sendBioRequest toMsg (requestBio name)


viewText : RemoteBio -> Html msg 
viewText bio =
  case bio of
    NotRequested ->
      div [] [text "No Bio Found"]
    Fetching ->
      div [] [text "Loading..."]
    Succes b ->
      div [] [ text b ]
    Failure e ->
      div [] [ text "Something went wrong loading the bio" ]