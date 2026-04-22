module Tailwind.Extra exposing (..)

import Svg
import Svg.Attributes as SvgAttrs
import Tailwind exposing (batch, toClass)


svgClasses : List Tailwind.Tailwind -> Svg.Attribute msg
svgClasses twClasses =
    batch twClasses
        |> toClass
        |> SvgAttrs.class
