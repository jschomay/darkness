module Tests exposing (..)

import Test exposing (..)
import Expect
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict
import Hypermedia exposing (..)


all : Test
all =
    describe "All tests"
        [ describe "Hypermedia" hypermediaTests
        ]


type Msg
    = Msg String


hypermediaTests : List Test
hypermediaTests =
    [ describe "parse"
        [ test "basic sample" <|
            \() ->
                let
                    input : String
                    input =
                        "You can feel the [1] blowing, you can smell the [2] and the [3] between the palm trees looks mighty inviting."

                    expectation : Result (List String) (List (Html Msg))
                    expectation =
                        Ok
                            [ text "You can feel the "
                            , span
                                [ onClick <| Msg "1"
                                , class "u-interactable"
                                ]
                                [ text "wind" ]
                            , text " blowing, you can smell the "
                            , span
                                [ onClick <| Msg "2"
                                , class "u-interactable"
                                ]
                                [ text "ocean" ]
                            , text " and the "
                            , span
                                [ onClick <| Msg "3"
                                , class "u-interactable"
                                ]
                                [ text "hammock" ]
                            , text " between the palm trees looks mighty inviting."
                            ]
                in
                    Expect.equal (toString expectation) <| toString <| Hypermedia.parse Msg (Dict.fromList [ ( "1", "wind" ), ( "2", "ocean" ), ( "3", "hammock" ) ]) input
        ]
    ]
