port module Main exposing (..)

import Engine exposing (..)
import Story.Manifest exposing (..)
import Story.Scenes exposing (..)
import Html exposing (..)
import Theme.Layout
import ClientTypes exposing (..)
import Dict exposing (Dict)
import Hypermedia exposing (parse)


type alias Model =
    { engineModel : Engine.Model
    , loaded : Bool
    , storyLine : List String
    }


main : Program Never Model ClientTypes.Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


stripAttributes : List ( Id, Attributes ) -> List Id
stripAttributes =
    List.map Tuple.first


stripNarration : List ( Id, List ( Id, Rule, Narration ) ) -> List ( Id, List ( Id, Rule ) )
stripNarration =
    List.map <|
        Tuple.mapSecond <|
            List.map <|
                \( id, rule, _ ) -> ( id, rule )


init : ( Model, Cmd ClientTypes.Msg )
init =
    ( { engineModel =
            Engine.init
                { items = stripAttributes items
                , locations = stripAttributes locations
                , characters = stripAttributes characters
                }
                (stripNarration scenes)
                [ moveTo "darkness"
                , loadScene "begining"
                ]
      , loaded = False
      , storyLine =
            [ "It is in the face of [darkness1], that we remember the importance of light." ]
      }
    , Cmd.none
    )


update :
    ClientTypes.Msg
    -> Model
    -> ( Model, Cmd ClientTypes.Msg )
update msg model =
    case msg of
        Interact interactableId ->
            let
                ( newEngineModel, maybeMatchedRuleId ) =
                    Engine.update interactableId model.engineModel

                narration =
                    getNarration maybeMatchedRuleId
                        |> Maybe.withDefault (getAttributes interactableId |> .description)
            in
                ( { model
                    | engineModel = newEngineModel
                    , storyLine = model.storyLine ++ [ narration ]
                  }
                , Cmd.none
                )

        Loaded ->
            ( { model | loaded = True }
            , Cmd.none
            )


port loaded : (Bool -> msg) -> Sub msg


subscriptions : Model -> Sub ClientTypes.Msg
subscriptions model =
    loaded <| always Loaded


content : Dict String Narration
content =
    Dict.fromList <|
        List.concatMap
            (Tuple.second
                >> (List.map (\( key, _, narration ) -> ( key, narration )))
            )
            scenes


getNarration : Maybe String -> Maybe String
getNarration ruleId =
    ruleId
        |> Maybe.andThen (flip Dict.get content)
        |> Maybe.andThen List.head


getAttributes : Id -> Attributes
getAttributes id =
    case Dict.get id interactables of
        Nothing ->
            Debug.crash <| "Cannot find an interactable for id " ++ id

        Just attrs ->
            attrs


interactables : Dict Id Attributes
interactables =
    Dict.fromList (items ++ locations ++ characters)


parse : String -> Html Msg
parse storyText =
    case Hypermedia.parse (Dict.map (always .name) interactables) storyText of
        Ok children ->
            div [] children

        Err errs ->
            Debug.crash "Problems parsing hypermedia!"


view :
    Model
    -> Html ClientTypes.Msg
view model =
    Theme.Layout.view <| List.map parse model.storyLine
