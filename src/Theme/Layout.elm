module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.Storyline exposing (..)
import ClientTypes exposing (..)


view :
    String
    -> String
    -> List (List (Html Msg))
    -> Html Msg
view currentSceneId currentSceneTitle storyLine =
    div [ class <| "Game Game--" ++ currentSceneId ]
        [ div [ class "Layout" ]
            [ Theme.Storyline.view currentSceneId currentSceneTitle storyLine
            ]
        ]
