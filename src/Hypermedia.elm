module Hypermedia exposing (parse, parseMultiLine)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Combine exposing (..)
import Dict exposing (Dict)


parseMultiLine : (String -> msg) -> Dict String String -> String -> List (Html msg)
parseMultiLine msg display input =
    String.split "\n\n" input
        |> List.map
            (p []
                << \paragraph ->
                    case parse msg display paragraph of
                        Ok children ->
                            children

                        Err errs ->
                            -- Debug.crash <| "Problem parsing your text!  " ++ input
                            [ text <| "<Error, could not parse: \"" ++ input ++ "\">" ]
            )


parse : (String -> msg) -> Dict String String -> String -> Result (List String) (List (Html msg))
parse msg display input =
    let
        parseHelper parser f errorString =
            parser
                |> Combine.map f
                |> Combine.mapError (always [ errorString ])

        storyText =
            parseHelper
                (regex "[^\\[]+")
                text
                "I was looking for unbracketed text."

        interactable =
            let
                toClickable id =
                    span
                        [ onClick <| msg id
                        , class "u-interactable"
                        ]
                        [ text <|
                            Maybe.withDefault ("<Undefined: " ++ id ++ ">") <|
                                Dict.get id display
                        ]
            in
                parseHelper
                    (brackets <| regex "[^\\]]+")
                    toClickable
                    "I was looking for [some text], but I found []."
    in
        case
            Combine.parse
                (mapError
                    ((++) [ "Empty input provided" ])
                    (many1 (storyText <|> interactable))
                )
                input
        of
            Ok ( _, _, result ) ->
                Ok result

            Err ( _, _, errors ) ->
                Err errors
