module Theme.TitlePage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : msg -> Bool -> Html msg
view msg loaded =
    div [ class "TitlePage" ]
        [ h1 [ class "TitlePage__Title" ] [ text "Darkness" ]
        , h3 [ class "TitlePage__Byline" ] [ text "Jeff Schomay" ]
        , p [ class "TitlePage__Prologue markdown-body" ] [ text "Darkness" ]
        , if loaded then
            span [ class "TitlePage__StartGame", onClick msg ] [ text "Play" ]
          else
            span [ class "TitlePage__Loading" ] [ text "Loading..." ]
        ]
