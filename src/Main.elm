import Browser
import Html exposing (Html, div, text, button, input, h1)
import Html.Attributes exposing (style, placeholder, value)
import Html.Events exposing (onInput)
import String exposing(fromInt)

init =
    ""

type Msg
    = Change String

view model =
    div [] [
        input [ placeholder "Search", value model, onInput Change ] []
        , h1 [] [text("Searched: " ++ model)]
    ]

update: Msg -> String.String -> String.String
update msg model =
    case msg of
        Change str ->
            str

main =
    Browser.sandbox
       { init = init
       , view = view
       , update = update
       }
