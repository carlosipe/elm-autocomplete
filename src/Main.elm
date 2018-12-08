port module Main exposing(..)
import Browser
import Html exposing (Html, div, text, button, input, h1, pre, ul, li)
import Html.Attributes exposing (style, placeholder, value, href)
import Html.Events exposing (onInput, onClick)
import String exposing(fromInt)
import Dict
import Http
import Json.Decode exposing (Decoder, list, string, decodeString)
import Json.Encode as E

port autocompleted : String.String -> Cmd msg

init: () -> (Model, Cmd Msg)
init _ =
  (
    { query = ""
    , suggestions = []
    , error = ""
    }
    , Cmd.none
  )

type alias Model =
    { query: String
    , suggestions: List String
    , error: String
    }

type Msg
    = Change String
    | SetQuery String
    | DisplaySuggestions (Result Http.Error (List String))

    
suggestionsFor query =
  Http.get
  { url = "/a.json?search=" ++ query
  , expect = Http.expectJson DisplaySuggestions suggestionsDecoder
  }

suggestionsDecoder: Decoder (List String)
suggestionsDecoder =
    list string

view: Model -> Html Msg
view model =
    div [] [
        input [ placeholder "Search", value model.query, onInput Change ] []
        , pre [] [text(Debug.toString(model))]
        , suggestionsView model.suggestions
      ]

suggestionsView suggestions =
      ul [] (suggestions
        |> List.map(\s -> li [onClick (SetQuery s)] [text(s)]))

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Change str ->
          ({ model | query = str }, suggestionsFor str )
        SetQuery str ->
          ({ model | query = str, suggestions = [] }, autocompleted(str))
        DisplaySuggestions result ->
            case result of
                Ok suggestions ->
                  ( { model | suggestions = suggestions, error = "" }, Cmd.none )
                Err error ->
                  ( { model | error = Debug.toString(error) }, Cmd.none )

main =
    Browser.element
       { init = init
       , view = view
       , update = update
       , subscriptions = (\_ -> Sub.none)
       }
