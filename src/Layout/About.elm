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
import Tailwind as Tw exposing (classes)
import Tailwind.Breakpoints exposing (dark, hover, md, sm, xl)
import Tailwind.Theme
    exposing
        ( current
        , gray
        , primary
        , s0
        , s10
        , s100
        , s14
        , s2
        , s200
        , s3
        , s4
        , s400
        , s48
        , s5
        , s500
        , s6
        , s700
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
                        ([ Tw.fill_simple current
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
        |> Html.div [ classes [ Tw.flex, Tw.space_x s3, Tw.pt s6 ] ]


view : Author -> Html msg
view author =
    Html.div
        [ classes
            [ Tw.divide_y
            , Tw.divide_color (gray s200)
            , dark [ Tw.divide_color (gray s700) ]
            ]
        ]
        [ Html.div
            [ classes
                [ Tw.space_y s2
                , Tw.pb s8
                , Tw.pt s6
                , md [ Tw.space_y s5 ]
                ]
            ]
            [ Html.h1
                [ classes
                    [ Tw.text_3xl
                    , Tw.font_extrabold
                    , Tw.tracking_tight
                    , Tw.text_color (gray s900)
                    , dark [ Tw.text_color (gray s100) ]
                    , sm [ Tw.text_n4xl, Tw.leading s10 ]
                    , md [ Tw.text_n6xl, Tw.leading s14 ]
                    ]
                ]
                [ Html.text "About" ]
            ]
        , Html.div
            [ classes
                [ Tw.items_start
                , Tw.space_y s2
                , xl [ Tw.grid, Tw.grid_cols_3, Tw.gap_x s8, Tw.space_y s0 ]
                ]
            ]
            [ Html.div
                [ classes
                    [ Tw.flex
                    , Tw.flex_col
                    , Tw.items_center
                    , Tw.space_x s2
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
                    , Attrs.src "/images/authors/default.png"
                    , Attrs.style "color" "transparent"
                    ]
                    []
                , Html.h3
                    [ classes
                        [ Tw.pb s2
                        , Tw.pt s4
                        , Tw.text_2xl
                        , Tw.font_bold
                        , Tw.leading s8
                        , Tw.tracking_tight
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
                    , Tw.max_w_none
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
