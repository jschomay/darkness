module Hypermedia
    exposing
        ( parse
        , parseMultiLine
        , extractInteractables
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Combine exposing (..)
import Dict exposing (Dict)


extractInteractables : (String -> msg) -> Dict String String -> String -> List (Html msg)
extractInteractables msg display input =
    String.split "\n\n" input
        |> List.concatMap
            (\paragraph ->
                case parse True msg display paragraph of
                    Ok children ->
                        children

                    Err errs ->
                        [ text <| "<Error, could not parse: \"" ++ input ++ "\".  Check your syntax in this block of text.>" ]
            )


parseMultiLine : (String -> msg) -> Dict String String -> String -> List (Html msg)
parseMultiLine msg display input =
    String.split "\n\n" input
        |> List.map
            (p []
                << \paragraph ->
                    case parse False msg display paragraph of
                        Ok children ->
                            children

                        Err errs ->
                            [ text <| "<Error, could not parse: \"" ++ input ++ "\".  Check your syntax in this block of text.>" ]
            )


parse : Bool -> (String -> msg) -> Dict String String -> String -> Result (List String) (List (Html msg))
parse onlyInteractables msg display input =
    let
        toClickable : String -> Maybe String -> Html msg
        toClickable id textOverride =
            span
                [ onClick <| msg id
                , class "u-interactable"
                ]
                [ Dict.get id display
                    |> Maybe.map (flip Maybe.withDefault textOverride)
                    |> Maybe.withDefault ("<Error, could not find display information for interactable id \"" ++ id ++ "\">")
                    |> text
                ]

        storyTextParser =
            let
                blank =
                    (always <| text "")
            in
                Combine.map
                    (if onlyInteractables then
                        blank
                     else
                        text
                    )
                <|
                    regex "[^\\[]+"

        interactableParser =
            brackets <|
                toClickable
                    <$> regex "[^|\\]]+"
                    <*> maybe (string "|" *> regex "[^\\]]+")
    in
        case
            Combine.parse
                (Combine.mapError
                    ((++) [ "Empty input provided" ])
                    (Combine.many1 (storyTextParser <|> interactableParser))
                )
                input
        of
            Ok ( _, _, result ) ->
                Ok result

            Err ( _, _, errors ) ->
                Err errors
