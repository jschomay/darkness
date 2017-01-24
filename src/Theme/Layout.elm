module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.Storyline exposing (..)
import ClientTypes exposing (..)


view :
    String
    -> List (List (Html Msg))
    -> Html Msg
view currentScene storyLine =
    div [ class <| "Game Game--" ++ currentScene ]
        [ div [ class "Layout" ]
            [ Theme.Storyline.view currentScene storyLine
            ]
        ]
