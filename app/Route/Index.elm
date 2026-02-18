module Route.Index exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.Blogpost exposing (Metadata)
import FatalError exposing (FatalError)
import Head
import Html
import Layout
import Layout.Blogpost
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Settings
import Shared
import Tailwind as Tw exposing (classes, raw)
import Tailwind.Breakpoints exposing (dark, md, sm)
import Tailwind.Theme exposing (gray, s100, s400, s500, s6, s8, s900)
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    { blogpostMetadata : List Metadata
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    Content.Blogpost.allBlogposts
        |> BackendTask.map (\allBlogposts -> List.map .metadata allBlogposts |> (\allMetadata -> { blogpostMetadata = allMetadata }))


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head _ =
    Layout.seoHeaders


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = Settings.title
    , body =
        --TODO move to layout part
        [ View.freeze <|
            Html.div []
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
                            [ Tw.text_n3xl
                            , Tw.font_extrabold
                            , raw "leading-9"
                            , raw "tracking-tight"
                            , Tw.text_color (gray s900)
                            , dark [ Tw.text_color (gray s100) ]
                            , sm [ Tw.text_n4xl, raw "leading-10" ]
                            , md [ Tw.text_n6xl, raw "leading-14" ]
                            ]
                        ]
                        [ Html.text "Latest" ]
                    , Html.p
                        [ classes [ Tw.text_lg, raw "leading-7", Tw.text_color (gray s500), dark [ Tw.text_color (gray s400) ] ] ]
                        [ Html.text Settings.subtitle ]
                    ]
                , Html.div [] <| List.map Layout.Blogpost.viewListItem app.data.blogpostMetadata
                ]
        ]
    }
