module Story.Manifest exposing (items, locations, characters, scenes)

import ClientTypes exposing (..)
import Dict exposing (Dict)


display : String -> String -> Components
display name description =
    Dict.fromList [ ( "display", Display { name = name, description = description } ) ]


style : String -> Components -> Components
style selector components =
    Dict.insert "style" (Style selector) components


item : String -> String -> Entity
item name description =
    { id = name
    , components = display name description
    }


location : String -> String -> Entity
location name description =
    { id = name
    , components = display name description |> style name
    }


scene : String -> String -> Entity
scene id name =
    { id = id
    , components = display name "" |> style id
    }


character : String -> String -> Entity
character name description =
    { id = name
    , components = display name description
    }


items : List Entity
items =
    [ item "worn photograph" "I've had this for a very long time."
    , item "lighter" "It is almost empty.  I must use it wisely."
    , item "candle" "Funny how such a simple object can be a such a godsend."
    , item "candles" "Each candle is a promise of life."
    , item "breeze" "A fresh breeze can breath new life into a stale room."
    , item "light" "It does nothing more than stimulate receptors on the back of our eyes, but for us it creates the entire world."
    , item "exitDoor" "This is the barrier between light and dark."
    , item "hill" "I wonder if it is natural or man-made."
    , item "horizon" "The world is a big place."
    , item "gravestone" "Old and crumbled and very solemn."
    , item "offer" "A chance to get what I've been looking for."
    , item "secondOffer" "Their patience is running out."
    , item "finalOffer" "Do I stay, or do I go?"
    ]


characters : List Entity
characters =
    [ character "Wheezy" "Disfigured and scarred, saddened by years of hardship, but fortified by determination."
    , character "Limpy" "Full of tenacity, he's going to do what he needs to do."
    , character "raiders" "A group of bandits up to no good."
    ]


locations : List Entity
locations =
    [ location "darkness" "Will this darkness go on for ever?  How can I find my way without any light?"
    , location "hiding spot" "Who knows what's in there."
    , location "crack" "By definition, a crack is a place between a rock and a hard place."
    , location "windy hallway" "The wind rips through the hall."
    , location "main chamber" "At one time this must have been used for some purpose, I don't think anyone would want to come here any more."
    , location "tunnels" "Where do they all go?"
    , location "exit" "I've never been happier to find the exit."
    , location "field" "A simple landscape, but it is beautiful."
    , location "forest" "I would hate to be here at night."
    , location "cemetery" "This cemetery must be very old."
    , location "cliff" "A place where you can see clearly to the horizon, but have no way to go to what you see."
    , location "town" "The promise of a warm meal and a cozy fireplace."
    ]


scenes : List Entity
scenes =
    [ scene "aloneInTheDark" "Darkness"
    , scene "firstLight" "First Light"
    , scene "aloneAgain" "Alone Again"
    , scene "almostThere" "Almost There"
    , scene "darkestPart" "The darkest part of the night is just before dawn"
    , scene "onTheRun" "On the run"
    , scene "light" "Light"
    , scene "trials" "Light?"
    , scene "facingDarkness" "Facing the darkness"
    , scene "fadeToBlack" "Fade to black"
    , scene "lightsInTheDarkness" "Lights in the darkness"
    , scene "lightWithin" "Light within"
    ]
