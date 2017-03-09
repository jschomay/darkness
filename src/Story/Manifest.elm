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
    , item "candle" "Funny how such a simple object can be a such a lifesaver."
    , item "light" "And God said, \"Let there be light,\" and there was light."
    ]


characters : List Entity
characters =
    [ character "Wheezy" "Disfigured and scarred, saddened by years of hardship, but fortified by determination."
    ]


locations : List Entity
locations =
    [ location "darkness" "Will this darkness go on for ever?  How can I find my way without any light?"
    , location "hiding spot" "Who knows what's in there."
    ]


scenes : List Entity
scenes =
    [ scene "aloneInTheDark" "Darkness"
    , scene "firstLight" "First Light"
    ]
