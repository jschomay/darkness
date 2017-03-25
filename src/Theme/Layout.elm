module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.Storyline exposing (..)
import ClientTypes exposing (..)


view :
    Bool
    -> String
    -> String
    -> List (Html Msg)
    -> List (List (Html Msg))
    -> Html Msg
view hideQuickBar currentSceneId currentSceneTitle quickBarItems storyLine =
    div [ class <| "Game Game--" ++ currentSceneId ]
        [ div [ classList [ ( "QuickBar", True ), ( "QuickBar--hidden", hideQuickBar ) ] ] quickBarItems
        , div [ class "Layout" ]
            [ Theme.Storyline.view currentSceneId currentSceneTitle storyLine
            ]
        ]
