module Main exposing (..)

import Browser
import Html exposing (Html, Attribute, div, textarea, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Array
import Array


-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
  { content : String
  }


init : Model
init =
  { content = "" }

requiredFields : List String
requiredFields = [
  "byr",
  "ecl",
  "eyr",
  "hcl",
  "hgt",
  "iyr",
  "pid"]

-- UPDATE


type Msg
  = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { init | content = newContent}

process: String -> String
process passports =
  String.fromInt (List.foldl isValid 0 (List.map validate (String.split "\n\n" passports)))


validate: String -> Bool
validate passport = 
  let
    attributes = (List.filter isEmpty (List.concat (List.map (String.split "\n") (String.split " " passport))))
  in
    (List.sort (List.filter isCid (attributeNames attributes))) == requiredFields

attributeNames: List String -> List String
attributeNames attributes = 
  List.map (Maybe.withDefault "???") (List.map (Array.get 0) (List.map Array.fromList (List.map (String.split ":") attributes)))
  
isEmpty: String -> Bool
isEmpty attribute = (String.length attribute) > 0

isValid: Bool -> Int -> Int
isValid valid accum = 
    if valid then
      accum + 1
    else
      accum

isCid: String -> Bool
isCid attribute = attribute /= "cid"

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ textarea [ placeholder "Passports to analyze", value model.content, onInput Change ] []
    , div [] [ text (process model.content) ]
    ]