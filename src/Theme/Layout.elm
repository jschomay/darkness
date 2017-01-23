module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.Storyline exposing (..)
import ClientTypes exposing (..)


view :
    List (List (Html Msg))
    -> Html Msg
view storyLine =
    div [ class <| "Game" ]
        [ div [ class "Layout" ]
            [ Theme.Storyline.view storyLine ]
        ]
