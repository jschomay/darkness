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
        , breeze
        , candle
        , wheezy
        , crack
        , mainChamber
        , tunnels
        , limpy
        ]



-- Items


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
        :: { summary = "first glimpse"
           , interaction = withItem "worn photograph"
           , conditions = [ currentSceneIs "firstLight" ]
           , changes = []
           , narrative =
                [ "I forgot at the photo!  I can see it now.  It is of a woman.  But I don't recognizer her...  She seems familiar.  But I can't remember..."
                , "Who is she?  Why do I have it?"
                , "Why can't I remember her?"
                ]
           }
        :: []


candle : List (RuleData Engine.Rule)
candle =
    []
        ++ { summary = "burning out"
           , interaction = withItem "candle"
           , conditions =
                [ currentSceneIs "firstLight"
                , currentLocationIs "darkness"
                ]
           , changes = []
           , narrative =
                [ "The light is almost magical.  I have already forgot what it was like in absolute darkness.  I certainly don't want to go back to that."
                , "The wax is dripping down the side.  It is burning down fast."
                , "I don't know how much longer it will last.  I hope we get out soon."
                , "It will go out soon."
                ]
           }
        :: { summary = "trying to relight"
           , interaction = withItem "candle"
           , conditions =
                [ currentSceneIs "aloneAgain"
                , currentLocationIs "windy hallway"
                ]
           , changes = []
           , narrative =
                [ "I quickly light the candle again, but the wind blows it out a second later."
                , "I'll never light it in here.  I have to find someplace [main chamber|less windy]."
                , "I'll have to leave if I want to light it."
                ]
           }
        :: []


breeze : List (RuleData Engine.Rule)
breeze =
    []
        ++ { summary = "what breeze"
           , interaction = withItem "breeze"
           , conditions =
                [ currentSceneIs "firstLight"
                , currentLocationIs "darkness"
                ]
           , changes = []
           , narrative =
                [ "I don't feel any breeze." ]
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
                [ "It feels almost empty.\n\n I give it a flick and the short burst of sparks almost blind me for a second, but the tiny weak flame barely penetrates the darkness.  It shudders and goes out."
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
           , narrative = [ "\"Hold on!  You have a candle?  We can help each other.\"\n\nI flick my lighter and light his candle and a small, glowing sphere of warm light envelopes us.\n\nMy eyes adjust to the light flickering off the glistening cave-like walls, and I get my first glimpse of \"[Wheezy].\"\n\nHe is hunched over, his skin cracked and scarred.  In a way he is repulsive.  But his eyes are friendly, and he seems happy to see me.  Maybe he is just happy to be able to see anything again.  To be honest, so am I." ]
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



-- Locations


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
           , narrative = [ "I am alone.\n\n Alone in this overwhelming [darkness].  I wave my hand in front of my eyes, but I see nothing.  I have to find a way out.\n\n  I have something in my pocket.  It feels like a [worn photograph|photograph], but I don't remember why I have it.  And a [lighter].  " ]
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
                [ "I feel a crack in the wall here, maybe I can squeeze my body into it.  Hopefully what ever it is won't detect me.\n\nIt's getting closer.  It stopped just in front of me.\n\nIt calls out, \"Hello?  Is someone there? I don't want any trouble.\"\n\nIt's another person, like me. Maybe I should confront him.  Or if I keep hiding, maybe he will just go away."
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


crack : List (RuleData Engine.Rule)
crack =
    []
        ++ { summary = "entering the main chamber"
           , interaction = withLocation "crack"
           , conditions =
                [ currentLocationIs "darkness"
                , currentSceneIs "firstLight"
                ]
           , changes =
                [ moveTo "windy hallway"
                , loadScene "aloneAgain"
                ]
           , narrative =
                [ "I squeeze into the crack.  The walls are hard and slimy.  I have to twist my body around to get through, but I manage to crawl out into a larger hallway.  I turn around to light the way for [Wheezy], and a blast of wind shoots through the hall and blows out the [candle]!\n\nI am in total darkness again.  \n\n\"Wheezy!\"\n\nMy shout bounces off of the walls, but I get no answer, just the echoing howls of wind.  I'm alone.  Again."
                ]
           }
        :: []


mainChamber : List (RuleData Engine.Rule)
mainChamber =
    []
        ++ { summary = "relight candle"
           , interaction = withLocation "main chamber"
           , conditions =
                [ currentSceneIs "aloneAgain"
                , currentLocationIs "windy hallway"
                ]
           , changes =
                [ loadScene "almostThere"
                , moveTo "main chamber"
                ]
           , narrative = [ "I stumble down the hall, feeling my way, into the wind.  If Wheezy was right, maybe the way out is not far.\n\nThe hallway leads to an open chamber.  It is less windy here, and I manage to relight the [candle].  I'm so glad to have light again.\n\nThis chamber is larger than I thought.  The light from the candle barely reaches the ceiling.  I see three, no four, other [tunnels] leading out from here, besides the way I came in.  Which one do I take?" ]
           }
        :: []


tunnels : List (RuleData Engine.Rule)
tunnels =
    []
        ++ { summary = "limpy's proposition"
           , interaction = withLocation "tunnels"
           , conditions =
                [ currentSceneIs "almostThere"
                , currentLocationIs "main chamber"
                , characterIsNotInLocation "Limpy" "main chamber"
                , itemIsInInventory "candle"
                ]
           , changes =
                [ moveCharacterToLocation "Limpy" "main chamber"
                ]
           , narrative = [ "One of these must lead out.  But which one?  I wish Wheezy was here, he would know.  I guess I'll try this one--\n\nI hear something!  Footsteps.  Wheezy!  He found me.\n\nA man emerges from the second tunnel -- he's not Wheezy.  He is tall and thin with a hardened face, creased with determination and... malice?  He comes right at me.  He walks with a limp.\n\n\"You!  I see your light.  You give to me.\"\n\nNo way I'm giving him my candle.  I could outrun him if I take this first tunnel.\n\nHe tries again, \"You give me your candle.  I find my friends.  They have many candles.  We come back and give you many candles.\"\n\nA deal?  Maybe I should take it.  My candle won't last long.  Maybe \"[Limpy]\" knows the way out.  I'm just not sure I trust him." ]
           }
        :: []



-- Characters


wheezy : List (RuleData Engine.Rule)
wheezy =
    []
        ++ { summary = "before seeing wheezy"
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
        :: { summary = "confront wheezy"
           , interaction = withCharacter "Wheezy"
           , conditions =
                [ currentSceneIs "aloneInTheDark"
                , characterIsInLocation "Wheezy" "darkness"
                , notBeenThereDoneThat "Wheezy"
                ]
           , changes = [ moveTo "darkness" ]
           , narrative = [ "I summon my courage.  \"Who's there?\"  My words echo off the hard walls.  The breathing stops.\n\nThen a pinched, wheezy voice answers back.\n\n\"Please, leave me alone.  I have nothing to offer.  I am all out of matches.  All I have is a broken candle stump.  Just let me pass.\"" ]
           }
        :: { summary = "first contact"
           , interaction = withCharacter "Wheezy"
           , conditions =
                [ currentSceneIs "firstLight"
                , currentLocationIs "darkness"
                ]
           , changes = []
           , narrative =
                [ "\"Hi... What are you doing down here?  Can you get us out?\"\n\n\"I've been stuck down here for a long time.  Just like you.  But I do know a way out.  We have to hurry, the [candle] won't last long. Follow me.\""
                , "\"Where are we going?\"\n\n\"We have to find our way to the main chamber.  From there it's not far to the surface.\"\n\n\"How do you know which way goes the main chamber?\"\n\n\"A light [breeze] blows from there, we just go in that direction.  Can you feel it?  It's this way.  Come on.\""
                , "\"So, what is this place? How did we get here? How do you know about it?\"\n\nWheezy doesn't answer.  He seems to be concentrating on the breeze.  He glances at the candle.  He seems concerned.  Is he lost?  Oh God, we're lost!  Why did I trust this guy?  Maybe I should--\n\n\"Who's the woman in the [worn photograph|photograph]?\""
                , "\"Hey, we've been here before.  I recognize that rock.  We're going in circles.  We're lost!\"\n\nWheezy pauses and looks around.  He points at a wall.  \"Through there.\"  He hands me the candle.  \"You first.\"\n\n\"What... the [crack] in the wall?\""
                , "\"Go on.\""
                , "\"Squeeze through.\""
                , "\"Go.\""
                ]
           }
        :: { summary = "losing wheezy"
           , interaction = withCharacter "Wheezy"
           , conditions =
                [ currentSceneIs "aloneAgain"
                , characterIsInLocation "Wheezy" "darkness"
                , currentLocationIs "windy hallway"
                ]
           , changes = []
           , narrative =
                [ "I call out for him again, but there is no answer.  Where is he, he should have been right behind me?"
                , "Maybe I should try to go back and find him.  I can't find the crack, it was here a moment ago! The wind turned me around, I can't find it!"
                , "I've lost him."
                ]
           }
        :: []


limpy : List (RuleData Engine.Rule)
limpy =
    []
        ++ { summary = "evaluating deal"
           , interaction = withCharacter "Limpy"
           , conditions =
                [ currentSceneIs "almostThere"
                , characterIsInLocation "Limpy" "main chamber"
                , currentLocationIs "main chamber"
                , itemIsInInventory "candle"
                ]
           , changes = []
           , narrative =
                [ "He glares at me.  I better make a choice fast."
                , "He's not much for conversation.  He wants my candle."
                ]
           }
        :: []



{-
   Next:
    - after Limpy's deal, path for giving candle or running into tunnels

-}
