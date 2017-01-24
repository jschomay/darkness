module Story.Manifest exposing (items, locations, characters)

import ClientTypes exposing (..)


items : List ( Id, Attributes )
items =
    []
        ++ ( "photograph"
           , { name = "worn photograph"
             , description = "It is too dark, I can't tell what it is of.  But it feels creased and torn around the edges."
             }
           )
        :: ( "lighter"
           , { name = "lighter"
             , description = "It feels almost empty."
             }
           )
        :: []


characters : List ( Id, Attributes )
characters =
    []
        ++ ( "Harry"
           , { name = "Harry"
             , description = "Not the sharpest tool in the shed, but a good mate, always ready for a pint."
             }
           )
        :: []


locations : List ( Id, Attributes )
locations =
    []
        ++ ( "darkness1"
           , { name = "darkness"
             , description = "Will this darkness go on for ever?  How can I find my way without any light?"
             }
           )
        :: []



{-
   Darkness - is there a way out?  How can I move through it?)
   Hear wheezing, you can confront (I'm making my way out, but I only have 1 candle left an I'm out of matches/ I can help/ leading in circles?) or hide (Is someone there?/ Don't trust someone who doesn't speak up/ Hits you, seeing stars, loosing consciousness, but dancing stars give glorious respite from the everpresent darkness).
-}
