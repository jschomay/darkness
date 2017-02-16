module ClientTypes exposing (..)

import Dict exposing (Dict)


type Msg
    = Interact Id
    | Loaded
    | NoOp


type alias Id =
    String


type alias Components =
    Dict String Component


type Component
    = Display { name : String, description : String }
    | Style String


type alias Entity =
    { id : String
    , components : Components
    }


type alias Narrative =
    List String


type alias RuleData a =
    { a
        | summary : String
        , narrative : Narrative
    }
