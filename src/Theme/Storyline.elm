module Theme.Storyline exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import ClientTypes exposing (..)


view :
    List (List (Html Msg))
    -> Html Msg
view storyLine =
    let
        storyLi i story =
            let
                numLines =
                    List.length storyLine

                classes =
                    classList
                        [ ( "StoryLine__Item", True )
                        , ( "u-fade-in", True )
                        ]
            in
                ( toString i, li [ classes ] story )
    in
        Html.Keyed.ol [ class "StoryLine" ]
            (List.indexedMap storyLi storyLine)
