module Story.Rules exposing (rulesData)

import Engine exposing (..)
import ClientTypes exposing (..)


rulesData : List (RuleData Engine.Rule)
rulesData =
    List.concat
        [ darkness
        , hidingSpot
        , wornPhotograph
        , lighter
        , wheezy
        ]


darkness : List (RuleData Engine.Rule)
darkness =
    []
        ++ { summary = "launch story"
           , interaction = withLocation "darkness"
           , conditions = [ currentSceneIs "intro" ]
           , changes =
                [ loadScene "aloneInTheDark"
                , moveItemToInventory "worn photograph"
                , moveItemToInventory "lighter"
                ]
           , narrative = [ "I am alone.\n\n Alone in this overwhelming [darkness].  I wave my hand in front of my eyes, but I see nothing.\n\n  I have something in my pocket.  A [worn photograph].  I don't remember what of.  And a [lighter].  " ]
           }
        :: { summary = "stumble through darkness to explore"
           , interaction = withLocation "darkness"
           , conditions =
                [ beenThereDoneThat "lighter"
                , currentSceneIs "aloneInTheDark"
                , characterIsNotInLocation "Wheezy" "darkness"
                ]
           , changes =
                [ moveCharacterToLocation "Wheezy" "darkness"
                ]
           , narrative = [ "I must find a way out.  If I can't see my way, I'll feel my way.\n\nHere is a wall, rough and jagged, but I can follow it.  The air is still and dry.\n\nWait.  I hear something.  A low, raspy breathing.  [Wheezy|Someone or something] is in here with me.\n\nIt's coming closer.  Do I confront it?  In the dark?  Maybe I can [hiding spot|hide]." ]
           }
        :: { summary = "while hiding"
           , interaction = withLocation "darkness"
           , conditions =
                [ currentLocationIs "hiding spot"
                ]
           , changes = []
           , narrative = [ "Hopefully it is dark enough he won't see me." ]
           }
        :: []


wornPhotograph : List (RuleData Engine.Rule)
wornPhotograph =
    []
        ++ { summary = "can't see photo"
           , interaction = withItem "worn photograph"
           , conditions = [ currentSceneIs "aloneInTheDark" ]
           , changes = []
           , narrative =
                [ "It is too dark, I can't see it.  It feels creased and torn around the edges.  I wonder what it is of."
                , "What could it be?"
                , "I wonder how long I've had this with me."
                , "I can't see it."
                ]
           }
        :: []


lighter : List (RuleData Engine.Rule)
lighter =
    []
        ++ { summary = "lighter is almost empty"
           , interaction = withItem "lighter"
           , conditions = [ currentSceneIs "aloneInTheDark" ]
           , changes = []
           , narrative =
                [ "It feels almost empty.\n\n I give it a flick and the short burst of sparks almost blind me for a second, but the tiny weak flame barely penetrates the darkness."
                , "I am afraid to waste it."
                ]
           }
        :: { summary = "light Wheezy's candle"
           , interaction = withItem "lighter"
           , conditions =
                [ currentSceneIs "aloneInTheDark"
                , characterIsInLocation "Wheezy" "darkness"
                , beenThereDoneThat "Wheezy"
                ]
           , changes =
                [ moveItemToInventory "candle"
                , loadScene "firstLight"
                ]
           , narrative = [ "\"Hold on!  You have a candle?  We can help each other.\"\n\nI flick my lighter and light his candle and small, glowing sphere of warm light envelopes us.\n\nMy eyes adjust to the light flickering off the glistening cave-like walls, and I get my first glimpse of \"[Wheezy].\"\n\nHe is short and disfigured, with some nasty scars on his face.  But his eyes are friendly, and he seems happy to see me.  Maybe he is just happy to be able to see anything again.  To be honest, so am I." ]
           }
        :: { summary = "not while hiding"
           , interaction = withItem "lighter"
           , conditions =
                [ currentSceneIs "aloneInTheDark"
                , currentLocationIs "hiding spot"
                ]
           , changes =
                []
           , narrative = [ "I don't want to give myself away!" ]
           }
        :: []


hidingSpot : List (RuleData Engine.Rule)
hidingSpot =
    []
        ++ { summary = "hide from noise"
           , interaction = withLocation "hiding spot"
           , conditions =
                [ characterIsInLocation "Wheezy" "darkness"
                , currentLocationIs "darkness"
                , notBeenThereDoneThat "Wheezy"
                , currentSceneIs "aloneInTheDark"
                ]
           , changes = [ moveTo "hiding spot" ]
           , narrative =
                [ "I feel a crack in the wall here, maybe I can squeeze my body into it.  Hopefully what ever it is won't detect me.\n\nIt's getting closer.  It stopped just in front of me.\n\nIt calls out, \"Hello?  Is someone there? I don't want any trouble.\""
                ]
           }
        :: { summary = "after giving yourself away"
           , interaction = withLocation "hiding spot"
           , conditions =
                [ beenThereDoneThat "Wheezy"
                , currentSceneIs "aloneInTheDark"
                ]
           , changes = []
           , narrative =
                [ "There's no point hiding again, he knows I'm right here."
                , "Really I'd rather not go in there again.  Who knows what might be growing in there."
                , "I'm not hiding again."
                ]
           }
        :: { summary = "wheezy attacks you when you continue to hide (start over)"
           , interaction = withLocation "hiding spot"
           , conditions =
                [ currentLocationIs "hiding spot"
                , currentSceneIs "aloneInTheDark"
                ]
           , changes =
                [ moveTo "darkness"
                , moveCharacterOffScreen "Wheezy"
                , loadScene "intro"
                ]
           , narrative = [ "I hold my breath.  Maybe he will pass.  I hear a scuffle and he calls out again, \"I don't trust someone I can't see.\"\n\nSuddenly I feel a sharp blow graze my cheek.  I jerk back, slamming my head into the hard wall behind me.\n\nA dazzling shower of stars dance across my vision, giving a glorious moment of respite from the ever-present [darkness], before I slip into unconsciousness." ]
           }
        :: []


wheezy : List (RuleData Engine.Rule)
wheezy =
    []
        ++ { summary = "confront wheezy"
           , interaction = withCharacter "Wheezy"
           , conditions =
                [ currentSceneIs "aloneInTheDark"
                , characterIsInLocation "Wheezy" "darkness"
                , notBeenThereDoneThat "Wheezy"
                ]
           , changes = [ moveTo "darkness" ]
           , narrative = [ "I summon my courage.  \"Who's there?\"  My words echo off the hard walls.  The breathing stops.\n\nThen a pinched, wheezy voice answers back.\n\n\"Please, leave me alone.  I have nothing to offer.  I am all out of matches.  All I have is a broken candle stump.  Just let me pass.\"" ]
           }
        :: { summary = "before seeing wheezy"
           , interaction = withCharacter "Wheezy"
           , conditions =
                [ currentSceneIs "aloneInTheDark"
                , characterIsInLocation "Wheezy" "darkness"
                , beenThereDoneThat "Wheezy"
                ]
           , changes = []
           , narrative =
                [ "\"Wait!  Do you know a way out?\"\n\nHe doesn't answer.  It sounds like he is trying to sneak past."
                , "Who is he?  How did he get down here with me?  I wonder where he found a candle and matches."
                , "I better find a way to get his attention before he is gone."
                ]
           }
        :: []



{-
   Scenes:
   - aloneInTheDark
   - firstLight
-}
{-

     NOTES

     What if I only change scenes at sequence ends?  The text stays on longer, but the transition is more noticeable.  I have to handle every case.  I lose scene granularity, which may be harder later.

     would be better to click lighter instead of making candle clickable, but it isn't on screen...

     -- how to get photograph back in? is it listed somewhere, or do I need to reference it, like Wheezy asks who is in the photograph and you look and don't remember

     -- after candle talk to wheezy (how long have you been down here?) to bring up photograph or [out] to start walking, but going in circles, argue, wind, candle goes out.  Look for shelter, but get separated.

   in general, is it too railroaded? does it lose the main properties of the engine?  does it matter?

-}
