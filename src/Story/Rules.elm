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
        , exit
        , limpy
        , exitDoor
        , light
        , hill
        , horizon
        , forest
        , cemetery
        , gravestone
        , raiders
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
        :: { summary = "remembering"
           , interaction = withItem "worn photograph"
           , conditions =
                [ currentSceneIs "light"
                , currentLocationIs "field"
                ]
           , changes = []
           , narrative =
                [ "She must be out there somewhere.  Maybe I can find her."
                , "I miss her."
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
        :: { summary = "give to Limpy"
           , interaction = withItem "candle"
           , conditions =
                [ currentSceneIs "almostThere"
                , itemIsInInventory "candle"
                , characterIsInLocation "Limpy" "main chamber"
                ]
           , changes =
                [ moveItemOffScreen "candle"
                , moveCharacterOffScreen "Limpy"
                , loadScene "darkestPart"
                ]
           , narrative =
                [ "I guess I'll give it to him.  Hopefully if I help him he'll help me.\n\nI hold the candle out.  He snatches it, then turns back down the way he came.  I watch the glow recede down the tunnel.  Everything returns to [darkness]."
                ]
           }
        :: { summary = "losing it down the chasm"
           , interaction = withItem "candle"
           , conditions =
                [ currentSceneIs "onTheRun"
                , itemIsInInventory "candle"
                , currentLocationIs "tunnels"
                ]
           , changes =
                [ moveItemOffScreen "candle"
                , loadScene "darkestPart"
                ]
           , narrative =
                [ "I lunge forward, grasping for the candle, but I miss, and it rolls right over the edge.\n\nI peer over the precipice and see the candle tumbling down, way down.  It bounces off a wall and extinguishes.\n\nThe [darkness] engulfs me once again, leaving me stranded, helpless."
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
                [ "I don't feel any breeze."
                , "I still don't feel a breeze."
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


exitDoor : List (RuleData Engine.Rule)
exitDoor =
    []
        ++ { summary = "into the light"
           , interaction = withItem "exitDoor"
           , conditions =
                [ currentSceneIs "darkestPart" ]
           , changes =
                [ moveTo "field"
                , loadScene "light"
                ]
           , narrative = [ "I unlatch the door and push it open a crack.\n\nBright, white [light] pours in.  I throw the door open, absolutely blinded by the radiance, but I love it.  I force my eyes open, burning my retinas.  I can literally feel the light on my skin.  I made it.  I made it out.  I found the light." ]
           }
        :: []


hill : List (RuleData Engine.Rule)
hill =
    []
        ++ { summary = "getting a better vantage point"
           , interaction = withItem "hill"
           , conditions =
                [ currentSceneIs "light"
                , currentLocationIs "field"
                , beenThereDoneThat "horizon"
                ]
           , changes =
                [ moveCharacterToLocation "raiders" "field" ]
           , narrative =
                [ "I climb the rocky hill to get a better vantage point.  I still don't see much.  It looks like a [forest] is in the distance that way.  I can see something else in the distance over here.  It looks like... [raiders|people] approaching."
                , "I can't stand here all day."
                ]
           }
        :: []


horizon : List (RuleData Engine.Rule)
horizon =
    []
        ++ { summary = "where to from here"
           , interaction = withItem "horizon"
           , conditions =
                [ currentSceneIs "light"
                , currentLocationIs "field"
                ]
           , changes = []
           , narrative =
                [ "Maybe I can see a city or village or something.  But all I see is grass in every direction."
                , "There has to be something out there, but which way do I go?"
                , "I wish I could see further."
                ]
           }
        :: { summary = "nothing more to see"
           , interaction = withItem "horizon"
           , conditions =
                [ currentSceneIs "light"
                , currentLocationIs "field"
                , characterIsInLocation "raiders" "field"
                ]
           , changes = []
           , narrative =
                [ "I don't see anything else."
                ]
           }
        :: []


light : List (RuleData Engine.Rule)
light =
    []
        ++ { summary = "the field"
           , interaction = withItem "light"
           , conditions =
                [ currentSceneIs "light"
                , currentLocationIs "field"
                , notBeenThereDoneThat "light"
                ]
           , changes = []
           , narrative = [ "As my eyes adjust, an entire world unfolds before me.  I am in the middle of a field.  The wild grass stretches in all directions to the [horizon].  The door behind me leading back down into the [darkness] is carved into a small rocky [hill].  As bright as it is, I realize it is actually an overcast morning, but I don't care, I'm relieved to be out of the dark.\n\nI turn my attention to the [worn photograph|photo].  I study the woman's face.  It is soft and kind.  I know I know her.  I can remember her looking at me with those caring eyes.  I can remember her smile.  And even her voice.  I can hear her saying, \"Don't be afraid honey.  Don't be afraid of the dark.\"\n\nMy mother.  It's my mother." ]
           }
        :: []


gravestone : List (RuleData Engine.Rule)
gravestone =
    []
        ++ { summary = "remember mother is dead"
           , interaction = withItem "gravestone"
           , conditions = []
           , changes = []
           , narrative =
                [ "I reach out and touch one of the gravestones.  It is hard and cold, and crumbling with age.\n\nAs I run my fingers over the embossed letters I get a strange feeling of déjà vu.  I remember being in a cemetery before.  I remember a grave.  I remember crying.  My mother.  It was my mother's grave.  I remember now.  My mother is gone.\n\nI look at the [worn photograph| photo] of her again and cry.  I can't believe she is gone."
                , "Who was it for?  Does anyone remember them?"
                ]
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
        :: { summary = "waiting for Limpy to return"
           , interaction = withLocation "darkness"
           , conditions =
                [ currentSceneIs "darkestPart"
                , itemIsNotInInventory "candle"
                , currentLocationIs "main chamber"
                , characterIsNotInLocation "Limpy" "main chamber"
                ]
           , changes =
                [ moveItemToInventory "candles"
                ]
           , narrative =
                [ "The darkness is so complete.  I would never know that I was in this large chamber.  If there was a big sign pointing \"Exit, this way\" I wouldn't even know.  I hope giving up my candle wasn't a big mistake."
                , "How long will he be gone?  I hope he comes back soon."
                , "What if he doesn't come back?  How long should I sit here?  I still have my lighter, maybe that is enough.  I give it a flick.  The flame is so tiny.  It can't even see the tunnels.  I have no choice, I have to wait."
                , "How long has it been?  Did he forget about me?  I bet he never intended to come back.  He just wanted my candle, and I let him have it.  I'm so stupid!"
                , "I'll never get out.  I'll never know who is in the photo.  I'll never see the light again.  What if I die here?"
                , "I have to do something.  One of those tunnels goes out, I know it.  I might wander around in circles, but it's better than staying here!  Were they this way?\n\nI think I can hear the wind.  No, it's water.  No, it's not that either, it's... footsteps!\n\nI see the faintest glow now.  Yes, it's getting brighter.  It's Limpy.  He came back!  He wasn't lying.  And he has some friends with him, about ten other people, each with a candle.  How many other people are down here?\n\nLimpy comes up to me.  His face is still hard, but I realize it is just from hardship.  \"For you.\"  He hands me his candle, plus three more from the others.  \"That way [exit|out].\"  Without another word he leads his group away through a different tunnel and silence returns, but now I can see my way."
                , "I can't wait to get out of this darkness."
                ]
           }
        :: { summary = "stranded until saved"
           , interaction = withLocation "darkness"
           , conditions =
                [ currentSceneIs "darkestPart"
                , currentLocationIs "tunnels"
                ]
           , changes =
                [ moveItemToInventory "candle"
                ]
           , narrative =
                [ "I feel my way away from the chasm and slump against the opposite wall.  My ankle hurts.  I'm afraid to move now that I know about the chasm.  What will I do?  Maybe that's why Limpy was shouting, he was trying to warn me."
                , "I'll never get out of here.  I'll never find the light.  I'll never know who is in the photograph."
                , "Crushed, defeated, I let a restless sleep overcome me.  I drift in and out, dreaming of light.  But every time I open my eyes, it looks the same as when they are closed."
                , "My mind plays tricks on me again.  This time I see a light at the end of the tunnel.  It comes towards me.  I hear a sound, like a low rumbling thunder as it gets closer.\n\nIt's not thunder.  It's footsteps.  I'm not imagining this, someone is coming.  It's Limpy.  He has a band of people following him, each with their own candle.\n\nHe sees me.  \"Limpy!  I... I'm sorry.  I'm sorry I ran.  That was foolish.  Please, help me.\"\n\n\"You not help me.  Why I help you?\"  He moves past me, shepherding his people carefully around the rim of the chasm.\n\n\"Please!  I'm sorry!  I need your help.  You have so many candles, let me have just one.\"\n\nHe ignores me.  One by one, his people file past.  I try to get up, but my ankle hurts too badly to stand on.\n\nA little girl follows at the back of the group.  She pauses as she steps around me, inspecting me with her curious eyes.  Then she reaches out, offering me her candle.\n\n\"Are you sure?  Thank you!\"\n\nShe smiles, then scampers to catch up with the others.  I watch them go until they are out of sight.  At least I have light now.  When my ankle feels better I'll look for the way [exit|out], more carefully this time."
                , "I'll just rest a little longer until I'm ready."
                ]
           }
        :: { summary = "not going back"
           , interaction = withLocation "darkness"
           , conditions =
                [ currentLocationIs "field"
                ]
           , changes = []
           , narrative =
                [ "I have no desire to return there." ]
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
           , narrative = [ "One of these must lead out.  But which one?  I wish Wheezy was here, he would know.  I guess I'll try this one--\n\nI hear something!  Footsteps.  Wheezy!  He found me.\n\nA man emerges from the second tunnel -- but he's not Wheezy.  He is tall and thin with a hardened face, creased with determination and... malice?  He comes right at me.  He walks with a limp.\n\n\"You!  I see your light.  You give to me.\"\n\nNo way I'm giving him my candle.  I could outrun him if I take this first tunnel.\n\nHe tries again, \"You give me your candle.  I find my friends.  They have many candles.  We come back and give you many candles.\"\n\nA deal?  Maybe I should take it.  My candle won't last long.  Maybe \"[Limpy]\" knows the way out.  I'm just not sure I trust him." ]
           }
        :: { summary = "running from Limpy"
           , interaction = withLocation "tunnels"
           , conditions =
                [ currentSceneIs "almostThere"
                , currentLocationIs "main chamber"
                , characterIsInLocation "Limpy" "main chamber"
                , itemIsInInventory "candle"
                ]
           , changes =
                [ moveTo "tunnels"
                , loadScene "onTheRun"
                ]
           , narrative = [ "I'm not going back into darkness.  I make a dash for the first tunnel.  I check over my shoulder and see Limpy try to run after me, but he won't be able to keep up.  He starts shouting at me at the top of his lungs as I round a corner.  I run until his shouting fades away.  I think I made it.  I don't see him behind me--\n\nWhoah!  My foot catches on something and I twist my ankle.  I come down hard, smacking the rocky ground.  The candle flies out of my hand and just for a second I see that half of the floor has caved away into a dangerous chasm.\n\nThe [candle] rolls towards it." ]
           }
        :: []


exit : List (RuleData Engine.Rule)
exit =
    []
        ++ { summary = "the way out (from Limpy)"
           , interaction = withLocation "exit"
           , conditions =
                [ currentSceneIs "darkestPart"
                , currentLocationIs "main chamber"
                ]
           , changes = []
           , narrative =
                [ "I take the tunnel Limpy indicated.  It twists around for a while, ending in a staircase that leads up to sealed [exitDoor|door]."
                , "What am I waiting for?"
                ]
           }
        :: { summary = "the way out (from tunnels)"
           , interaction = withLocation "exit"
           , conditions =
                [ currentSceneIs "darkestPart"
                , currentLocationIs "tunnels"
                ]
           , changes =
                []
           , narrative =
                [ "I gather my strength and follow the direction they went.  The tunnel branches out and twists around for a while, eventually ending in a staircase that leads up to sealed [exitDoor|door]."
                , "After all of this anticipation, I'm nervous now that I'm here."
                ]
           }
        :: []


forest : List (RuleData Engine.Rule)
forest =
    []
        ++ { summary = "make a break for it, get lost"
           , interaction = withLocation "forest"
           , conditions =
                [ currentLocationIs "field"
                , currentSceneIs "light"
                ]
           , changes =
                [ moveTo "forest"
                , loadScene "trials"
                ]
           , narrative =
                [ "The people approaching look like they are up to no good.  They look like raiders.  Have they seen me yet?  I'm not going to stick around to find out.  I'm making a break for the forest.\n\nIt's so much further than it looked, I'm completely out of breath.  But I made it.  The trees are so dense.  Everything is covered in green moss.  I didn't expect how dark it would be in here for being day time.  \n\nI walk through the trees and realize I'm [forest|lost] again."
                ]
           }
        :: { summary = "wandering around until finding the clearing"
           , interaction = withLocation "forest"
           , conditions =
                [ currentLocationIs "forest"
                , currentSceneIs "trials"
                ]
           , changes =
                []
           , narrative =
                [ "I've got to find a way out of here.  There must be a town or something not too far.  I think I came from over there, so I'll keep going in this direction..."
                , "The trees are getting thicker.  I think I need to go this way..."
                , "I'm completely turned around.  What side of the trees does the moss grow on?  The North?  This moss seems to be growing on all sides of the trees..."
                , "I've been wandering for ages.  What time is it?  I can't tell if the sun is going down or not.  There could be wild animals in here..."
                , "The trees seem to be opening up a little.  I'll go this way.\n\nI think I see a [cemetery|clearing].  Finally."
                , "I wouldn't want to be lost here at night."
                ]
           }
        :: { summary = "lost in many ways"
           , interaction = withLocation "forest"
           , conditions =
                [ currentLocationIs "cemetery"
                , currentSceneIs "trials"
                , beenThereDoneThat "gravestone"
                ]
           , changes =
                []
           , narrative =
                [ "I feel lost in more ways than one." ]
           }
        :: []


cemetery : List (RuleData Engine.Rule)
cemetery =
    []
        ++ { summary = "it's a cemetery"
           , interaction = withLocation "cemetery"
           , conditions =
                [ currentLocationIs "forest"
                , currentSceneIs "trials"
                , notBeenThereDoneThat "cemetery"
                ]
           , changes =
                [ moveTo "cemetery" ]
           , narrative =
                [ "This is a very symmetric clearing.  It looks man-made, but it is heavily overgrown.\n\nWhat's this?  It looks like... a [gravestone].  There's another.  It's a cemetery!  I must be near a town."
                ]
           }
        :: { summary = "wheezy and limpy are here too"
           , interaction = withLocation "cemetery"
           , conditions =
                [ currentLocationIs "cemetery"
                , currentSceneIs "trials"
                , beenThereDoneThat "gravestone"
                , characterIsNotInLocation "Wheezy" "cemetery"
                ]
           , changes =
                [ moveCharacterToLocation "Wheezy" "cemetery"
                , moveCharacterToLocation "Limpy" "cemetery"
                ]
           , narrative =
                [ "I look around the cemetery again.  There must be a hundred graves here, all overgrown and forgotten.\n\nAm I imagining, or do I hear something?  Like heavy breathing?  More of a wheeze actually...\n\nWheezy is here!  He must have made it out too.  I am about to call out to him when I realize he is standing over a grave.  Maybe he is mourning someone too.\n\nI thought I saw something else move.  I look around.  Someone else is behind that tree.  Or is it that other tree?  No, it's both.  Even more than that.  A whole group emerges from the forest -- Limpy's friends, and Limpy too.\n\nThey are all here mourning.  They have all lost someone. We all feel alone.  Alone together."
                ]
           }
        :: { summary = "raiders followed"
           , interaction = withLocation "cemetery"
           , conditions =
                [ currentLocationIs "cemetery"
                , currentSceneIs "trials"
                , characterIsInLocation "Wheezy" "cemetery"
                ]
           , changes =
                [ loadScene "facingDarkness"
                , moveTo "cliff"
                , moveCharacterToLocation "Wheezy" "cliff"
                , moveCharacterToLocation "raiders" "cliff"
                , moveCharacterOffScreen "Limpy"
                ]
           , narrative =
                [ "I hear more people coming.  More mourners?  No, it's the raiders!  They followed me!\n\nLimpy and his friends spot them too and scatter into the trees.  The raiders chase after them.  Wheezy and I run too.  We follow some of the others, out of the cemetery, jumping over fallen trees and thick roots.\n\nThe raiders are behind us.  We push forward, but I am losing my breath.  I can only imagine poor Wheezy.  We start to fall behind, and soon I can't see any of the others.  They must have gotten away.\n\nThe trees thin ahead.  We make it out of the forest onto a grassy plain.  It is already dusk.  The sky is not completely dark yet, but I can see a few early stars.\n\nSuddenly I realize we are on the top of a cliff.  I pause for a moment to see which way to go.  The raiders break out of the trees, and one of them throws something at Wheezy.  He stumbles.  I hesitate.  I can help him, but then they'll catch us both.  I can't leave [Wheezy].  Where can I go anyway?\n\nIt's too late.  The [raiders] reach him.  One of them smashes him across the face, opening up a fresh scar.\n\n\"Hey!  Leave him alone!\"  Wheezy looks up and tells me to run, but it is too late, the lead raider blocks my path.\n\nThe other raiders shout at Wheezy.  One of them kicks him, knocking him to the ground."
                ]
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
                , "\"So, what is this place? How did we get here? How do you know about it?\"\n\nWheezy doesn't answer.  He seems to be concentrating on the breeze.  He glances at the candle.  He seems concerned.  Is he lost?  Oh God, we're lost!  Why did I trust this guy?  Maybe I should--\n\n\"Who's the woman?\"\n\n\"What woman?\"\n\n\"The one in the [worn photograph|photograph]?\""
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
                [ "I call out for him again, but there is no answer.  Where is he, he should have been right behind me."
                , "Maybe I should try to go back and find him.\n\nWhere is the crack, it was here a moment ago! I can't find it!  The wind turned me around.  \"Wheezy!\""
                , "I've lost him."
                ]
           }
        :: { summary = "helping wheezy"
           , interaction = withCharacter "Wheezy"
           , conditions =
                [ currentSceneIs "facingDarkness" ]
           , changes = []
           , narrative =
                [ "I rush over to help him.\n\n\"Don't waste your time.  He is a disease.  A drain on society.  He uses up our resources and offers nothing in return.  And your other friend?  A thief.  We helped him once, and he stole from us.\n\nLeave them.  Come with us.  We have a city with shining walls and beautiful parks.  A place of safety and security.  You don't belong here.  We'll bring you to our city.\"\n\nI look over at Wheezy.  He is bleeding badly from the wound on his face.  What help can I be to him?  The city sounds amazing.  Should I go with them?"
                , "comforting wheezy, talk about mother..."
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
                [ "\"I won't give you my candle, but I'll make you another offer.  I'll come with you, help you find your friends.\"\n\n\"No!  I go alone!  You give candle to me.\""
                , "He glares at me.  I better make a choice fast."
                , "He's not much for negotiation.  He wants my candle."
                ]
           }
        :: []


raiders : List (RuleData Engine.Rule)
raiders =
    []
        ++ { summary = "go with raiders"
           , interaction = withCharacter "raiders"
           , conditions =
                [ currentSceneIs "facingDarkness" ]
           , changes = []
           , narrative =
                [ "to city..."
                ]
           }
        :: []



{-
   Next:
    - fix - if interacting with raiders before wheezy, should say something else, maybe same thing as interacting with wheezy?
    - add memories from mother for photo
    - go back and add paths from field:
      - hiding in darkness (restarts)
      - looking at raiders then forest, they catch you, throw in pit, wheezy rescues and brings to forest
      - raiders twice, ? (pit?, bribe you to bring wheezy/limpy to them?)
    - final challenge - raiders keep trying to convince you to come with them, you can keep talking to wheezy about his mother and your mother and what she taught you, eventually raiders will go away (like how to deal with bullies on bus example).  Before leaving, they stop bribing you and start attacking you.  Limpy and his friends come out of the wordwork and form a circle around you, protecting you and standing in solidarity, and they leave.  Fight darkness with light.  (at any time, if you interact with raiders, they take you to city, get that ending, unless you wait until they fight you, maybe interacting with them then makes them beat you up and leave you and wheezy dying in the cemetery, "never finding the light (dying seeing the lights of the town below the cliff, knowing you'll never get there)."
    - good ending, you see lights of fires in town, tell wheezy, but he is dying, epiphany




-}
