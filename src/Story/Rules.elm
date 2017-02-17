module Story.Rules exposing (rulesData)

import Engine exposing (..)
import ClientTypes exposing (..)


rulesData : List (RuleData Engine.Rule)
rulesData =
    List.concat [ intro, alone, wheezy ]


intro : List (RuleData Engine.Rule)
intro =
    []
        ++ { summary = "start"
           , interaction = withLocation "darkness"
           , conditions = [ currentSceneIs "intro" ]
           , changes =
                [ loadScene "alone"
                , moveItemToInventory "worn photograph"
                , moveItemToInventory "lighter"
                ]
           , narrative = [ """I am alone.

Alone in this overwhelming [darkness].  I wave my hand in front of my eyes, but I see nothing.

I have some things with me.  A [worn photograph].  I don't even remember what of.  A [lighter].
           """ ]
           }
        :: []


alone : List (RuleData Engine.Rule)
alone =
    []
        ++ { summary = "stumble through the dark"
           , interaction = withLocation "darkness"
           , conditions =
                [ beenThereDoneThat "lighter"
                , currentSceneIs "alone"
                ]
           , changes =
                [ loadScene "Wheezy"
                , moveCharacterToLocation "Wheezy" "darkness"
                ]
           , narrative = [ "I must find a way out.  If I can't see my way, I'll feel my way.\n\nHere is a wall, rough and jagged, but I can follow it.  The air is still and dry.\n\nWait.  I hear something.  A low, raspy breathing.  [Wheezy|Someone or something] is in here with me.\n\nIt's coming closer.  What do I do?  Maybe I can [hiding spot|hide]." ]
           }
        :: []


wheezy : List (RuleData Engine.Rule)
wheezy =
    []
        ++ { summary = "hide from noise"
           , interaction = withLocation "hiding spot"
           , conditions =
                [ characterIsInLocation "Wheezy" "darkness"
                , currentSceneIs "Wheezy"
                ]
           , changes = [ moveTo "hiding spot" ]
           , narrative = [ "I feel a crack in the wall here, maybe I can squeeze my body into it.  Hopefully what ever it is won't detect me.\n\nIt's getting closer.  It stopped just in front of me.\n\nA deep, raspy voice calls out, \"Hello?  Is someone there? I don't want any trouble.\"" ]
           }
        :: { summary = "wheezy attacks you"
           , interaction = withLocation "hiding spot"
           , conditions =
                [ currentLocationIs "hiding spot"
                , currentSceneIs "Wheezy"
                ]
           , changes =
                [ moveTo "darkness"
                , moveCharacterOffScreen "Wheezy"
                , loadScene "intro"
                ]
           , narrative = [ "I hold my breath.  Maybe he will pass.  I hear a scuffle and he calls out again, \"I don't trust someone I can't see.\"\n\nSuddenly I feel a sharp blow graze my cheek.  I jerk back, slamming my head into the hard wall behind me.\n\nA dazzling shower of stars dance across my vision, giving a glorious moment of respite from the ever-present [darkness], even as I slip into unconsciousness." ]
           }
        :: []



{-
    [someone]"\"Who's there?\"\n\nThe breathing stops for a minute.  Then a pinched, wheezy voice answers back.\n\n\"You startled me.  I'm just trying to get [out].  But I'm down to my last [candle] and I'm all out of matches.  Please, just let me be.\""

    [out]"\"You know how to get out?  Take me!\"\n\nThe man stays silent.  I can hear him trying to inch past."

    [out(again)]"\"Come back here!  I need to get out too.  Don't leave...\"\n\nBut his breathing fades away and before long I have no idea which direction he went.\n\nI am alone again.  Surrounded in [darkness]."(end scene)

    [candle]"\"You have a candle?  Then we can help each other.\"\n\nI take out my lighter and flick it on.  The wheezy man holds out his candle and soon a small, glowing sphere of warm light envelopes us.\n\nMy eyes adjust to the light flickering off the glistening cave-like walls, and I get my first glimpse of my new companion.\n\n[\"Wheezy\"] is surprisingly short, scarred and disfigured.  But his eyes are friendly, and he seems happy to see me.  Maybe he is just happy to be able to see anything again."

    -- how to get photograph back in? is it listed somewhere, or do I need to reference it, like Wheezy asks who is in the photograph and you look and don't rmember

   -- after candle talk to wheezy (how long have you been down here?) to bring up photograph or [out] to start walking, but going in circles, argue, wind, candle goes out.  Look for shelter, but get separated.

-}
