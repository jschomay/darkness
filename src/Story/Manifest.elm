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
             , description = """I am alone.  Alone in this overwhelming [darkness1].  I wave my hand in front of my eyes, but I see nothing.

I have some things with me.  A [photograph].  I don't even remember what of.  A [lighter].
"""
             }
           )
        :: []
