module Story.Scenes exposing (scenes)

import Engine exposing (..)
import ClientTypes exposing (..)


scenes : List ( Id, List ( Id, Engine.Rule, Narration ) )
scenes =
    [ ( "intro", intro )
    , ( "alone", alone )
    ]


intro : List ( Id, Engine.Rule, Narration )
intro =
    []
        ++ ( "start"
           , { interaction = withLocation "darkness1"
             , conditions = []
             , changes =
                [ loadScene "alone"
                ]
             }
           , [ """I am alone.  Alone in this overwhelming [darkness1].  I wave my hand in front of my eyes, but I see nothing.

I have some things with me.  A [photograph].  I don't even remember what of.  A [lighter].
           """ ]
           )
        :: []


alone : List ( Id, Engine.Rule, Narration )
alone =
    []
        ++ ( "too dark"
           , { interaction = withLocation "darkness1"
             , conditions = [ itemIsInInventory "lighter" ]
             , changes = []
             }
           , [ "...still can't see..." ]
           )
        :: []
