import Browser
import Html exposing (Html, div, text, button, input, h1, pre, ul, li)
import Html.Attributes exposing (style, placeholder, value, href)
import Html.Events exposing (onInput, onClick)
import String exposing(fromInt)
import Dict

init: Model
init =
    { query = ""
    , suggestions = []
    }

type alias Model =
    { query: String
    , suggestions: List String
    }

type Msg
    = Change String
    | SetQuery String

    
suggestions_for query =
   Dict.fromList [
        ("a", ["alfabeto", "abadía", "arnau"])
        , ("al", ["alfabeto", "alfalfa"])
        ]
        |> Dict.get(query)
        |> Maybe.withDefault []

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


update: Msg -> Model -> Model
update msg model =
    case msg of
        Change str ->
          { model | query = str, suggestions = suggestions_for(str)}
        SetQuery str ->
          { model | query = str, suggestions = [] }

main =
    Browser.sandbox
       { init = init
       , view = view
       , update = update
       }
