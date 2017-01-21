module Theme.Storyline exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import ClientTypes exposing (..)


view :
    List (Html Msg)
    -> Html Msg
view storyLine =
    let
        storyLi i story =
            let
                numLines =
                    List.length storyLine

                key =
                    toString <| numLines - i

                classes =
                    classList
                        [ ( "Storyline__Item", True )
                        , ( "u-fade-in", True )
                        ]
            in
                ( key, li [ classes ] [ p [] [ story ] ] )
    in
        Html.Keyed.ol [ class "StoryLine" ]
            (List.indexedMap storyLi storyLine)
