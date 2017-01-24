module Theme.Storyline exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import ClientTypes exposing (..)


view :
    String
    -> List (List (Html Msg))
    -> Html Msg
view currentScene storyLine =
    let
        storyLi i story =
            let
                numLines =
                    List.length storyLine
            in
                ( currentScene ++ (toString i), li [ class "Storyline__Item" ] story )
    in
        Html.Keyed.ol [ id "Storyline", class "Storyline" ]
            (List.indexedMap storyLi storyLine)
