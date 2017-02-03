module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type alias Model =
    { message : String
    , logo : String
    , navbar : Navbar
    }

type alias Navbar =
  { brandIcon: String
  , hamburgerMenuModel: HamburgerMenuModel
  }

type alias HamburgerMenuModel =
  {
    dropDownList: DropDownList
  , state: HamburgerMenuState
  }

init : String -> ( Model, Cmd Msg )
init path =
    let
      dropDownList = ["first menu item", "second menu item"]
      hamburgerMenuState = Closed
      hamburgerMenuModel = {state = hamburgerMenuState, dropDownList = dropDownList}
      navbar = {brandIcon = "Brand!", hamburgerMenuModel = hamburgerMenuModel}
    in
    ( {
        message = "Your Elm App is working!"
        , logo = path
        ,  navbar = navbar
      },
      Cmd.none
    )



type Msg
    = NoOp
    | ToggleHamburgerMenu



---Update
toggleHamburgerMenuState: HamburgerMenuModel -> HamburgerMenuModel
toggleHamburgerMenuState hamburgerMenuModel =
  case hamburgerMenuModel.state of
    Open -> {hamburgerMenuModel | state = Closed}
    Closed -> {hamburgerMenuModel | state = Open}


toggleNavHamburgerMenu: Navbar -> Navbar
toggleNavHamburgerMenu navbar =
  {navbar | hamburgerMenuModel = toggleHamburgerMenuState navbar.hamburgerMenuModel}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ToggleHamburgerMenu ->
      ({model | navbar = toggleNavHamburgerMenu model.navbar}, Cmd.none)
    NoOp ->
      ( model, Cmd.none )



---VIEWS
type alias DropDownList = List String
type HamburgerMenuState = Open | Closed
hamburgerMenuView: HamburgerMenuModel -> Html Msg
hamburgerMenuView hamburgerMenuModel =
  div [onClick ToggleHamburgerMenu]
    [
      case hamburgerMenuModel.state of
        Closed ->
          div [] [text "It is closed"]
        Open ->
          ul []
            (List.map (\dl ->  li [] [text dl]) hamburgerMenuModel.dropDownList)
    ]


navbarView: Navbar -> Html Msg
navbarView navbar =
  div [style
        [
          ("backgroundColor", "red"),
          ("position", "fixed"),
          ("top", "0"),
          ("left", "0"),
          ("width", "100vw"),
          ("display", "flex"),
          ("justify-content", "space-between")
        ]
      ]
    [ div [class "LeftNavItems"] [text navbar.brandIcon]
     ,div [class "RightNavItems"] [hamburgerMenuView navbar.hamburgerMenuModel]
    ]

view : Model -> Html Msg
view model =
    div []
        [ img [ src model.logo ] []
        , div [] [ text model.message ]
        , navbarView model.navbar
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
