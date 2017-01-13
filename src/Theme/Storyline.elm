module Theme.Storyline exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import ClientTypes exposing (..)


view :
    List StorySnippet
    -> Maybe String
    -> Html Msg
view storyLine ending =
    let
        storyLi i { interactableName, interactableCssSelector, narration } =
            let
                numLines =
                    List.length storyLine

                key =
                    interactableName ++ (toString <| numLines - i)

                classes =
                    [ ( "Storyline__Item", True )
                    , ( "Storyline__Item--" ++ interactableCssSelector, True )
                    , ( "u-fade-in", i == 0 )
                    ]
            in
                ( key
                , li [ classList classes ] <|
                    [ h4 [ class "Storyline__Item__Action" ] <| [ text interactableName ]
                    , p [ class "Storyline__Item__Narration markdown-body" ] [ text narration ]
                    ]
                        ++ if i == 0 && ending /= Nothing then
                            [ h5
                                [ class "Storyline__Item__Ending" ]
                                [ text <| Maybe.withDefault "The End" ending ]
                            ]
                           else
                            []
                )
    in
        Html.Keyed.ol [ class "Storyline" ]
            (List.indexedMap storyLi storyLine)
