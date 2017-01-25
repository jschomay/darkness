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
                , moveItemToInventory "photograph"
                , moveItemToInventory "lighter"
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
        ++ ( "stumble through the dark"
           , { interaction = withLocation "darkness1"
             , conditions = [ beenThereDoneThat "lighter" ]
             , changes = [ loadScene "wheezy" ]
             }
           , [ "I must find a way out.  If I can't see my way, I'll feel my way.\n\nSlowly... I don't want to run into anything or fall.  Here is a wall.  It is rough and jagged, but I can follow it.  Where does it go?  Is there a way out?  What if I--\n\nWait.  I hear something.  A low, raspy breathing.  [Someone or something] is in here with me.\n\nIt's coming closer.  What do I do?  Maybe I can [hide]." ]
           )
        :: []


wheezy : List ( Id, Engine.Rule, Narration )
wheezy =
    []



{-
    [someone]"\"Who's there?\"\n\nThe breathing stops for a minute.  Then a pinched, wheezy voice answers back.\n\n\"You startled me.  I'm just trying to get [out].  But I'm down to my last [candle] and I'm all out of matches.  Please, just let me be.\""

    [out]"\"You know how to get out?  Take me!\"\n\nThe man stays silent.  I can hear him trying to inch past."

    [out(again)]"\"Come back here!  I need to get out too.  Don't leave...\"\n\nBut his breathing fades away and before long I have no idea which direction he went.\n\nI am alone again.  Surrounded in [darkness]."(end scene)

    [candle]"\"You have a candle?  Then we can help each other.\"\n\nI take out my lighter and flick it on.  The wheezy man holds out his candle and soon a small, glowing sphere of warm light envelopes us.\n\nMy eyes adjust to the light flickering off the glistening cave-like walls, and I get my first glimpse of my new companion.\n\n[\"Wheezy\"] is surprisingly short, scarred and disfigured.  But his eyes are friendly, and he seems happy to see me.  Maybe he is just happy to be able to see anything again."

    -- how to get photograph back in? is it listed somewhere, or do I need to reference it, like Wheezy asks who is in the photograph and you look and don't rmember

   -- after candle talk to wheezy (how long have you been down here?) to bring up photograph or [out] to start walking, but going in circles, argue, wind, candle goes out.  Look for shelter, but get separated.

-}
