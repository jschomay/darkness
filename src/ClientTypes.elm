module ClientTypes exposing (..)


type Msg
    = Interact Id
    | Loaded
    | NoOp


type alias Id =
    String


type alias Attributes =
    { name : String
    , description : String
    }


type alias Narration =
    List String
