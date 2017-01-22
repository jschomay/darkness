module Hypermedia exposing (parse)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Combine exposing (..)
import Dict exposing (Dict)
import ClientTypes exposing (..)


parse : Dict String String -> String -> Result (List String) (List (Html Msg))
parse display input =
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
                        [ onClick <| Interact id
                        , class "u-interactable"
                        ]
                        [ text <|
                            Maybe.withDefault id <|
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
