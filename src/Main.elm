port module Main exposing (..)

import Engine exposing (..)
import Story.Manifest exposing (..)
import Story.Rules exposing (..)
import Html exposing (..)
import Theme.Layout
import ClientTypes exposing (..)
import Components exposing (..)
import Dict exposing (Dict)
import Task
import Hypermedia exposing (parse)
import Dom.Scroll as Dom
import List.Zipper as Zipper exposing (Zipper)


type alias Model =
    { engineModel : Engine.Model
    , loaded : Bool
    , storyLine : List String
    , content : Dict String (Maybe (Zipper String))
    }


main : Program Never Model ClientTypes.Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


getIds : List Entity -> List Id
getIds =
    List.map .id


findEntity : Id -> Maybe Entity
findEntity id =
    let
        interactables =
            items ++ locations ++ characters ++ scenes
    in
        List.head <| List.filter (.id >> (==) id) interactables


pluckRules : Engine.Rules
pluckRules =
    let
        foldFn :
            RuleData Engine.Rule
            -> ( Int, Dict String Engine.Rule )
            -> ( Int, Dict String Engine.Rule )
        foldFn { interaction, conditions, changes } ( id, rules ) =
            ( id + 1
            , Dict.insert ((++) "rule" <| toString <| id + 1)
                { interaction = interaction
                , conditions = conditions
                , changes = changes
                }
                rules
            )
    in
        Tuple.second <| List.foldl foldFn ( 1, Dict.empty ) rulesData


pluckContent : Dict String (Maybe (Zipper String))
pluckContent =
    let
        foldFn :
            RuleData Engine.Rule
            -> ( Int, Dict String (Maybe (Zipper String)) )
            -> ( Int, Dict String (Maybe (Zipper String)) )
        foldFn { narrative } ( id, narratives ) =
            ( id + 1
            , Dict.insert ((++) "rule" <| toString <| id + 1)
                (Zipper.fromList narrative)
                narratives
            )
    in
        Tuple.second <| List.foldl foldFn ( 1, Dict.empty ) rulesData


init : ( Model, Cmd ClientTypes.Msg )
init =
    ( { engineModel =
            Engine.init
                { manifest =
                    { items = getIds items
                    , locations = getIds locations
                    , characters = getIds characters
                    }
                , rules = pluckRules
                , startingLocation = "darkness"
                , startingScene = "intro"
                , setup = []
                }
      , loaded = False
      , storyLine =
            [ "\"It is in the face of [darkness], that we remember the importance of light.\"" ]
      , content = pluckContent
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

                newNarrative : String
                newNarrative =
                    case getNarrative model.content maybeMatchedRuleId of
                        Just narrative ->
                            narrative

                        Nothing ->
                            Maybe.withDefault
                                ("<Error, Couldn't find entity from id: \"" ++ interactableId ++ "\">")
                            <|
                                Maybe.map (.description << getDisplay) <|
                                    findEntity interactableId

                isNewScene =
                    Engine.getCurrentScene model.engineModel == Engine.getCurrentScene newEngineModel

                updateNarrative =
                    if isNewScene then
                        model.storyLine ++ [ newNarrative ]
                    else
                        [ newNarrative ]

                newContent =
                    maybeMatchedRuleId
                        |> Maybe.map (\id -> Dict.update id updateContent model.content)
                        |> Maybe.withDefault model.content

                maybeScroll =
                    if isNewScene then
                        Task.attempt (always NoOp) <|
                            Task.mapError identity (Dom.toBottom "scroll-container")
                    else
                        Cmd.none
            in
                ( { model
                    | engineModel = newEngineModel
                    , storyLine = updateNarrative
                    , content = newContent
                  }
                , maybeScroll
                )

        Loaded ->
            ( { model | loaded = True }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )


port loaded : (Bool -> msg) -> Sub msg


subscriptions : Model -> Sub ClientTypes.Msg
subscriptions model =
    loaded <| always Loaded


getNarrative : Dict String (Maybe (Zipper String)) -> Maybe String -> Maybe String
getNarrative content ruleId =
    ruleId
        |> Maybe.andThen (\id -> Dict.get id content)
        |> Maybe.andThen identity
        |> Maybe.map Zipper.current


updateContent : Maybe (Maybe (Zipper String)) -> Maybe (Maybe (Zipper String))
updateContent =
    let
        nextOrStay narration =
            Zipper.next narration
                |> Maybe.withDefault narration
    in
        (Maybe.map >> Maybe.map) nextOrStay


view :
    Model
    -> Html ClientTypes.Msg
view model =
    let
        currentSceneId =
            (Engine.getCurrentScene model.engineModel)

        currentSceneTitle =
            findEntity currentSceneId
                |> Maybe.map (getDisplay >> .name)
                |> Maybe.withDefault ""

        interactables =
            List.map
                (\({ id } as entity) ->
                    ( id, .name <| getDisplay entity )
                )
                (items ++ locations ++ characters)
                |> Dict.fromList
    in
        Theme.Layout.view currentSceneId currentSceneTitle <|
            List.map
                (Hypermedia.parseMultiLine Interact interactables)
                model.storyLine
