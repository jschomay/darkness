module Theme.Storyline exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import ClientTypes exposing (..)


view :
    String
    -> String
    -> List (List (Html Msg))
    -> Html Msg
view currentSceneId currentSceneTitle storyLine =
    let
        storyLi i story =
            let
                numLines =
                    List.length storyLine
            in
                ( currentSceneId ++ (toString i)
                , li
                    [ class "Storyline__Item"
                    , style
                        [ ( "opacity"
                          , toString <|
                                Basics.max
                                    0.15
                                    (toFloat (i + 1) / (toFloat <| List.length storyLine))
                          )
                        ]
                    ]
                    story
                )

        sceneTitle =
            (if currentSceneTitle /= "" then
                [ h3 [ class "Storyline__SceneTitle" ] [ text <| "\"" ++ currentSceneTitle ++ "\"" ] ]
             else
                []
            )
    in
        div [ id "Storyline", class "Storyline" ] <|
            sceneTitle
                ++ [ Html.Keyed.ol []
                        (List.indexedMap storyLi storyLine)
                   ]
