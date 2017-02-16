module Story.Manifest exposing (items, locations, characters)

import ClientTypes exposing (..)
import Dict exposing (Dict)


display : String -> String -> Components
display name description =
    Dict.fromList [ ( "display", Display { name = name, description = description } ) ]


addStyle : String -> Components -> Components
addStyle selector components =
    Dict.insert "style" (Style selector) components


item : String -> String -> Entity
item name description =
    { id = name
    , components = display name description
    }


location : String -> String -> Entity
location name description =
    { id = name
    , components = display name description |> addStyle name
    }


character : String -> String -> Entity
character name description =
    { id = name
    , components = display name description
    }


items : List Entity
items =
    [ item "worn photograph"
        "It is too dark, I can't tell what it is of.  But it feels creased and torn around the edges."
    , item "lighter" "It feels almost empty.\n\n I give it a flick and the short burst of sparks almost blind me for a second, but the tiny weak flame barely penetrates the darkness."
    ]


characters : List Entity
characters =
    [ item "Wheezy" "Disfigured and scarred, saddened by years of hardship, but fortified by determination."
    ]


locations : List Entity
locations =
    [ item "darkness" "Will this darkness go on for ever?  How can I find my way without any light?"
    ]



{-
   Hear wheezing, you can confront (I'm making my way out, but I only have 1 candle left an I'm out of matches/ I can help/ leading in circles?) or hide (Is someone there?/ Don't trust someone who doesn't speak up/ Hits you, seeing stars, loosing consciousness, but dancing stars give glorious respite from the everpresent darkness).
-}
