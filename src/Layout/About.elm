module Layout.About exposing (seoHeaders, view)

import Content.About exposing (Author)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Extra
import Layout.Markdown as Markdown
import Pages.Url
import Phosphor
import Settings
import Tailwind as Tw exposing (classes, raw)
import Tailwind.Breakpoints exposing (dark, hover, md, sm, xl)
import Tailwind.Theme
    exposing
        ( gray
        , primary
        , s100
        , s2
        , s200
        , s4
        , s400
        , s48
        , s500
        , s6
        , s8
        , s900
        )
import UrlPath


seoHeaders : Author -> List Head.Tag
seoHeaders author =
    let
        imageUrl =
            author.avatar
                |> Maybe.map (\authorAvatar -> Pages.Url.fromPath <| UrlPath.fromString authorAvatar)
                |> Maybe.withDefault
                    ([ "media", "blog-image.png" ] |> UrlPath.join |> Pages.Url.fromPath)
    in
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image =
            { url = imageUrl
            , alt = author.name
            , dimensions = Just { width = 300, height = 300 }
            , mimeType = Nothing
            }
        , description = author.name ++ " - " ++ (author.occupation |> Maybe.withDefault ("Author of blogposts on " ++ Settings.title))
        , locale = Settings.locale
        , title = author.name
        }
        |> Seo.website


socialsView : List ( String, String ) -> Html msg
socialsView socials =
    let
        icon socialName =
            case socialName of
                "email" ->
                    Phosphor.envelopeSimple

                "facebook" ->
                    Phosphor.facebookLogo

                "github" ->
                    Phosphor.githubLogo

                "twitter" ->
                    Phosphor.twitterLogo

                "linkedin" ->
                    Phosphor.linkedinLogo

                "youtube" ->
                    Phosphor.youtubeLogo

                "tiktok" ->
                    Phosphor.tiktokLogo

                _ ->
                    Phosphor.link

        socialLink name link =
            if name == "email" then
                "mailto:" ++ link

            else
                link

        socialView ( name, link ) =
            Html.a
                [ Attrs.target "_blank"
                , Attrs.rel "noopener noreferrer"
                , Attrs.href <| socialLink name link
                ]
                [ Html.span
                    [ classes [ Tw.sr_only ] ]
                    [ Html.text name ]
                , icon name Phosphor.Regular
                    |> Phosphor.withClass
                        ([ raw "fill-current"
                         , Tw.text_color (gray s500)
                         , hover [ Tw.text_color (primary s500) ]
                         , dark
                            [ Tw.text_color (gray s200)
                            , hover [ Tw.text_color (primary s400) ]
                            ]
                         , Tw.h s8
                         , Tw.w s8
                         ]
                            |> Tw.batch
                            |> Tw.toClass
                        )
                    |> Phosphor.toHtml []
                ]
    in
    List.map socialView socials
        |> Html.div [ classes [ Tw.flex, raw "space-x-3", Tw.pt s6 ] ]


view : Author -> Html msg
view author =
    Html.div
        [ classes [ Tw.divide_y, raw "divide-gray-200 dark:divide-gray-700" ] ]
        [ Html.div
            [ classes
                [ raw "space-y-2"
                , Tw.pb s8
                , Tw.pt s6
                , md [ raw "space-y-5" ]
                ]
            ]
            [ Html.h1
                [ classes
                    [ Tw.text_3xl
                    , Tw.font_extrabold
                    , Tw.tracking_tight
                    , Tw.text_color (gray s900)
                    , dark [ Tw.text_color (gray s100) ]
                    , sm [ Tw.text_n4xl, raw "leading-10" ]
                    , md [ Tw.text_n6xl, raw "leading-14" ]
                    ]
                ]
                [ Html.text "About" ]
            ]
        , Html.div
            [ classes
                [ Tw.items_start
                , raw "space-y-2"
                , xl [ Tw.grid, Tw.grid_cols_3, Tw.gap_x s8, raw "space-y-0" ]
                ]
            ]
            [ Html.div
                [ classes
                    [ Tw.flex
                    , Tw.flex_col
                    , Tw.items_center
                    , raw "space-x-2"
                    , Tw.pt s8
                    ]
                ]
                [ Html.img
                    [ Attrs.alt "avatar"
                    , Attrs.attribute "loading" "lazy"
                    , Attrs.width 192
                    , Attrs.height 192
                    , Attrs.attribute "decoding" "async"
                    , Attrs.attribute "data-nimg" "1"
                    , classes [ Tw.h s48, Tw.w s48, Tw.rounded_full ]
                    , Attrs.src (author.avatar |> Maybe.withDefault "/images/authors/default.png")
                    , Attrs.style "color" "transparent"
                    ]
                    []
                , Html.h3
                    [ classes
                        [ Tw.pb s2
                        , Tw.pt s4
                        , Tw.text_2xl
                        , Tw.font_bold
                        , raw "leading-8"
                        , raw "tracking-tight"
                        ]
                    ]
                    [ Html.text author.name ]
                , Html.Extra.viewMaybe
                    (\occupation ->
                        Html.div
                            [ classes
                                [ Tw.text_color (gray s500)
                                , dark [ Tw.text_color (gray s400) ]
                                ]
                            ]
                            [ Html.text occupation ]
                    )
                    author.occupation
                , Html.Extra.viewMaybe
                    (\company ->
                        Html.div
                            [ classes
                                [ Tw.text_color (gray s500)
                                , dark [ Tw.text_color (gray s400) ]
                                ]
                            ]
                            [ Html.text company ]
                    )
                    author.company
                , socialsView author.socials
                ]
            , Html.div
                [ classes
                    [ Tw.prose
                    , raw "max-w-none"
                    , Tw.pb s8
                    , Tw.pt s8
                    , dark [ Tw.prose_invert ]
                    , xl [ Tw.col_span_2 ]
                    ]
                ]
              <|
                Markdown.toHtmlBlocks author.body
            ]
        ]
