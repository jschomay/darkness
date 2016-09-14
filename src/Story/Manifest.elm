module Story.Manifest exposing (items, locations, characters)

import ClientTypes exposing (..)


items : List ( Id, Attributes )
items =
    [ ( "Umbrella", { cssSelector = "Umbrella", name = "Umbrella", description = "My trusty brolly -- I take it everywhere." } )
    ]


characters : List ( Id, Attributes )
characters =
    [ ( "Harry", { cssSelector =  "Harry", name = "Harry", description = "Not the sharpest tool in the shed, but a good mate, always ready for a pint." } ) ]


locations : List ( Id, Attributes )
locations =
    [ ( "darkness", { cssSelector =  "darkness", name = "darkness", description = "darkness" } )
    ]
