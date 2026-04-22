module Layout exposing (seoHeaders, view)

import Head exposing (Tag)
import Head.Seo as Seo
import Html exposing (Html, img)
import Html.Attributes as Attrs exposing (src)
import Html.Events as Events
import LanguageTag.Language as Language
import LanguageTag.Region as Region
import Pages.Url
import Route exposing (Route)
import Settings
import Svg
import Svg.Attributes as SvgAttrs
import Tailwind as Tw exposing (classes, raw)
import Tailwind.Breakpoints exposing (dark, hover, md, sm, xl)
import Tailwind.Extra exposing (svgClasses)
import Tailwind.Theme
    exposing
        ( gray
        , primary
        , s0
        , s1
        , s10
        , s100
        , s11
        , s12
        , s16
        , s2
        , s20
        , s4
        , s400
        , s500
        , s6
        , s600
        , s8
        , s80
        , s900
        , s950
        , white
        )
import UrlPath


seoHeaders : List Tag
seoHeaders =
    let
        imageUrl =
            [ "media", "blog-image.png" ] |> UrlPath.join |> Pages.Url.fromPath
    in
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image =
            { url = imageUrl
            , alt = "logo"
            , dimensions = Just { width = 500, height = 333 }
            , mimeType = Nothing
            }
        , description = Settings.subtitle
        , locale = Just ( Language.en, Region.us )
        , title = Settings.title
        }
        |> Seo.website


menu : List { label : String, route : Route }
menu =
    [ { label = "Blog", route = Route.Blog }
    , { label = "Tags", route = Route.Tags }
    , { label = "About", route = Route.About }
    ]


logo : Html msg
logo =
    Html.div
        [ classes
            [ Tw.mr s1
            , Tw.text_color (primary s600)
            , dark [ Tw.text_color (primary s500) ]
            ]
        ]
        [ img
            [ src "/media/logo.svg"
            , classes [ Tw.h s10, Tw.w s10, Tw.rounded_xl ]
            ]
            []
        ]


viewMainMenuItem : { label : String, route : Route } -> Html msg
viewMainMenuItem { label, route } =
    Route.link
        [ classes
            [ Tw.hidden
            , sm [ Tw.block ]
            , Tw.font_medium
            , Tw.text_color (gray s900)
            , dark [ Tw.text_color (gray s100) ]
            , hover [ Tw.underline ]
            , raw "decoration-primary-500"
            ]
        ]
        [ Html.text label ]
        route


viewSideMainMenuItem : msg -> { label : String, route : Route } -> Html msg
viewSideMainMenuItem onMenuToggle { label, route } =
    Html.div
        [ classes [ Tw.px s12, Tw.py s4 ] ]
        [ Route.link
            [ classes
                [ Tw.text_2xl
                , Tw.font_bold
                , Tw.tracking_widest
                , Tw.text_color (gray s900)
                , dark [ Tw.text_color (gray s100) ]
                ]
            , Events.onClick onMenuToggle
            ]
            [ Html.text label ]
            route
        ]


viewMenu : Bool -> msg -> Html msg
viewMenu showMenu onMenuToggle =
    let
        mainMenuItems =
            List.map viewMainMenuItem menu

        sideMenuItems =
            { label = "Home", route = Route.Index }
                :: menu
                |> List.map (viewSideMainMenuItem onMenuToggle)
    in
    Html.nav
        [ classes
            [ Tw.flex
            , Tw.items_center
            , raw "leading-5"
            , raw "space-x-4"
            , sm [ raw "space-x-6" ]
            ]
        ]
        (mainMenuItems
            ++ [ Html.button
                    [ Attrs.attribute "aria-label" "Toggle Menu"
                    , classes [ sm [ Tw.hidden ] ]
                    , Events.onClick onMenuToggle
                    ]
                    [ Svg.svg
                        [ SvgAttrs.viewBox "0 0 20 20"
                        , SvgAttrs.fill "currentColor"
                        , svgClasses
                            [ Tw.text_color (gray s900)
                            , dark [ Tw.text_color (gray s100) ]
                            , Tw.h s8
                            , Tw.w s8
                            ]
                        ]
                        [ Svg.path
                            [ SvgAttrs.fillRule "evenodd"
                            , SvgAttrs.d "M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
                            , SvgAttrs.clipRule "evenodd"
                            ]
                            []
                        ]
                    ]
               , Html.div
                    [ classes
                        [ Tw.fixed
                        , raw "left-0"
                        , raw "top-0"
                        , Tw.z_0
                        , Tw.h_full
                        , Tw.w_full
                        , Tw.transform
                        , Tw.opacity_95
                        , dark [ raw "opacity-[0.98]", Tw.bg_color (gray s950) ]
                        , Tw.bg_simple white
                        , Tw.duration_300
                        , Tw.ease_in_out
                        , if showMenu then
                            raw "translate-x-0"

                          else
                            Tw.translate_x_full
                        ]
                    ]
                    [ Html.div
                        [ classes [ Tw.flex, Tw.justify_end ] ]
                        [ Html.button
                            [ classes [ Tw.mr s8, Tw.mt s11, Tw.w s8, Tw.h s8 ]
                            , Attrs.attribute "aria-label" "Toggle Menu"
                            , Events.onClick onMenuToggle
                            ]
                            [ Svg.svg
                                [ SvgAttrs.viewBox "0 0 20 20"
                                , SvgAttrs.fill "currentColor"
                                , svgClasses
                                    [ Tw.text_color (gray s900)
                                    , dark [ Tw.text_color (gray s100) ]
                                    ]
                                ]
                                [ Svg.path
                                    [ SvgAttrs.fillRule "evenodd"
                                    , SvgAttrs.d "M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                    , SvgAttrs.clipRule "evenodd"
                                    ]
                                    []
                                ]
                            ]
                        ]
                    , Html.div
                        [ classes [ Tw.fixed, Tw.mt s8, Tw.h_full ] ]
                        sideMenuItems
                    ]
               ]
        )


view : Bool -> msg -> List (Html msg) -> List (Html msg)
view showMenu onMenuToggle body =
    [ Html.div
        [ classes
            [ Tw.mx_auto
            , raw "max-w-3xl"
            , Tw.px s4
            , sm [ Tw.px s6 ]
            , xl [ raw "max-w-5xl", Tw.px s0 ]
            ]
        ]
        [ Html.div
            [ classes
                [ Tw.flex
                , Tw.h_screen
                , Tw.flex_col
                , Tw.justify_between
                , Tw.font_sans
                ]
            ]
            [ Html.header
                [ classes
                    [ Tw.flex
                    , Tw.items_center
                    , Tw.justify_between
                    , Tw.py s10
                    ]
                ]
                [ Html.div []
                    [ Html.a
                        [ Attrs.attribute "aria-label" Settings.title
                        , Attrs.href "/"
                        ]
                        [ Html.div
                            [ classes
                                [ Tw.flex
                                , Tw.items_center
                                , Tw.justify_between
                                ]
                            ]
                            [ logo
                            , Html.div
                                [ classes
                                    [ Tw.min_h s6
                                    , Tw.text_2xl
                                    , Tw.font_semibold
                                    , dark [ Tw.text_simple white ]
                                    ]
                                ]
                                [ Html.text Settings.title ]
                            ]
                        ]
                    ]
                , viewMenu showMenu onMenuToggle
                ]
            , Html.main_ [ classes [ Tw.w_full, Tw.mb_auto ] ] body
            , Html.footer
                [ classes
                    [ Tw.mt s16
                    , Tw.flex
                    , Tw.flex_col
                    , Tw.items_center
                    ]
                ]
                [ Html.div
                    [ classes
                        [ Tw.mb s2
                        , Tw.flex
                        , raw "space-x-2"
                        , Tw.text_sm
                        , Tw.text_color (gray s500)
                        , dark [ Tw.text_color (gray s400) ]
                        ]
                    ]
                    [ Html.div []
                        [ Html.text Settings.author ]
                    , Html.div []
                        [ Html.text "•" ]
                    , Html.div []
                        [ Html.text "© 2026" ]
                    , Html.div []
                        [ Html.text "•" ]
                    , Html.a
                        [ Attrs.href "/"
                        , classes [ hover [ Tw.underline ] ]
                        ]
                        [ Html.text Settings.title ]
                    ]
                ]
            ]
        ]
    ]
