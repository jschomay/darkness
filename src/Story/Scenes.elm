module Story.Scenes exposing (scenes)

import Engine exposing (..)
import ClientTypes exposing (..)


scenes : List ( Id, List ( Id, Engine.Rule, Narration ) )
scenes =
    [ ( "learnOfMystery", learnOfMystery )
    ]


learnOfMystery : List ( Id, Engine.Rule, Narration )
learnOfMystery =
    []
        ++ ( "get note from harry"
           , { interaction = withCharacter "Harry"
             , conditions = [ currentLocationIs "Garden" ]
             , changes =
                [ moveCharacterToLocation "Harry" "Marsh"
                , moveItemToInventory "NoteFromHarry"
                ]
             }
           , [ "narration here" ]
           )
        :: []


