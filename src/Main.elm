port module Main exposing (..)

import Engine exposing (..)
import Story.Manifest exposing (..)
import Story.Rules exposing (..)
import Html exposing (..)
import Theme.Layout
import ClientTypes exposing (..)
import Components exposing (..)
import Dict exposing (Dict)
import AnimationFrame
import Animation exposing (Animation)
import Hypermedia exposing (parse)
import List.Zipper as Zipper exposing (Zipper)


type alias Model =
    { engineModel : Engine.Model
    , loaded : Bool
    , storyLine : List String
    , content : Dict String (Maybe (Zipper String))
    , animationTime : Float
    , animation : Animation
    , scroll : ( ScrollDirection, Int )
    }


type ScrollDirection
    = Up
    | Down


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


initialEngineModel : Engine.Model
initialEngineModel =
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
      , animationTime = 0
      , animation = Animation.static 0 |> Animation.duration 400
      , scroll = ( Up, 0 )
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
                        |> (\( newEngineModel, maybeMatchedRuleId ) ->
                                if maybeMatchedRuleId == Just "rule7" then
                                    ( initialEngineModel, maybeMatchedRuleId )
                                else
                                    ( newEngineModel, maybeMatchedRuleId )
                           )

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

                handleScrolling =
                    if isNewScene then
                        prepScroll ()
                    else
                        scrollPage 0
            in
                ( { model
                    | engineModel = newEngineModel
                    , storyLine = updateNarrative
                    , content = newContent
                  }
                , handleScrolling
                )

        Loaded ->
            ( { model | loaded = True }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )

        Scroll scroll ->
            let
                direction =
                    if Tuple.second model.scroll < scroll || scroll == 0 then
                        Up
                    else
                        Down
            in
                ( { model | scroll = ( direction, scroll ) }, Cmd.none )

        ReadyToScroll { offset, scrollTop } ->
            let
                startedAnimation =
                    Animation.retarget model.animationTime (offset - 100) model.animation |> Animation.from scrollTop
            in
                ( { model | animation = startedAnimation }, Cmd.none )

        Tick dt ->
            let
                scroll =
                    Animation.animate model.animationTime model.animation
            in
                ( { model | animationTime = model.animationTime + dt }, scrollPage scroll )


port prepScroll : () -> Cmd msg


port scrollPage : Float -> Cmd msg


port loaded : (Bool -> msg) -> Sub msg


port readyToScroll : ({ offset : Float, scrollTop : Float } -> msg) -> Sub msg


port onScroll : (Int -> msg) -> Sub msg


subscriptions : Model -> Sub ClientTypes.Msg
subscriptions model =
    Sub.batch
        [ loaded <| always Loaded
        , readyToScroll ReadyToScroll
        , onScroll Scroll
        , if not <| Animation.isDone model.animationTime model.animation then
            AnimationFrame.diffs Tick
          else
            Sub.none
        ]


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


view : Model -> Html ClientTypes.Msg
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

        storyLine =
            List.map
                (Hypermedia.parseMultiLine Interact interactables)
                model.storyLine

        quickBarItems =
            List.foldr
                ((Hypermedia.extractInteractables Interact interactables) >> (++))
                []
                model.storyLine

        hideQuickBar =
            case Tuple.first model.scroll of
                Up ->
                    True

                Down ->
                    False
    in
        Theme.Layout.view hideQuickBar currentSceneId currentSceneTitle quickBarItems storyLine
