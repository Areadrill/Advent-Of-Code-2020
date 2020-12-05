module Main exposing (..)

import Browser
import Html exposing (Html, Attribute, div, textarea, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Array
import Regex
import String


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

validEyeColors: List String
validEyeColors = [
    "amb",
    "blu",
    "brn",
    "gry",
    "grn",
    "hzl",
    "oth"]

validBirthYear: String -> Bool
validBirthYear byr = 
  let
    largerThanMinimum = (Maybe.withDefault 0 (String.toInt byr)) >= 1920 
    lesserThanMaximum = (Maybe.withDefault 9999 (String.toInt byr)) <= 2002
  in
    largerThanMinimum && lesserThanMaximum 

validIssueYear: String -> Bool
validIssueYear iyr = 
  let
    largerThanMinimum = (Maybe.withDefault 0 (String.toInt iyr)) >= 2010 
    lesserThanMaximum = (Maybe.withDefault 9999 (String.toInt iyr)) <= 2020
  in
    largerThanMinimum && lesserThanMaximum 

validExpirationYear: String -> Bool
validExpirationYear eyr = 
  let
    largerThanMinimum = (Maybe.withDefault 0 (String.toInt eyr)) >= 2020 
    lesserThanMaximum = (Maybe.withDefault 9999 (String.toInt eyr)) <= 2030
  in
    largerThanMinimum && lesserThanMaximum 


validEyeColor: String -> Bool
validEyeColor color = (List.member color validEyeColors)

heightRegex: String
heightRegex = "\\d\\d\\d?(cm|in)"

validHeight: String -> Bool
validHeight height= 
  let
      regex = (Maybe.withDefault Regex.never (Regex.fromString heightRegex))
  in
    if (Regex.contains regex height) then
      let
        number = (Maybe.withDefault 0 (String.toInt (String.dropRight 2 height)))
      
      in
        if (String.endsWith "cm" height) then
          number >= 150 && number <= 193
        else if (String.endsWith "in" height) then
          number >= 59 && number <= 76
        else False
    else  
      False

validPid: String -> Bool
validPid pid = 
  case String.toInt pid of
    Just _ -> (String.length pid) == 9
    Nothing -> False

hairColorRegex: String
hairColorRegex = "#[0-9|a-f]{6}"

validHairColor: String -> Bool
validHairColor color = (Regex.contains (Maybe.withDefault Regex.never (Regex.fromString hairColorRegex)) color)

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
  let
    validAttributes = (List.filter validate (String.split "\n\n" passports))
  in
  String.fromInt (List.length (List.filter validateData validAttributes))

validate: String -> Bool
validate passport = 
  let
    attributes = parseAttributes passport
  in
    (List.sort (List.filter notCid (attributeNames attributes))) == requiredFields

validateData: String -> Bool
validateData  passport = 
  let 
    attributes = Array.fromList (List.sort (List.filter notCidFull (parseAttributes passport)))
    
    birthYearVerdict = validBirthYear (getAttributeFromPassport attributes 0)

    eyeColorVerdict = validEyeColor (getAttributeFromPassport attributes 1)

    expirationYearVerdict = validExpirationYear (getAttributeFromPassport attributes 2)

    hairColorVerdict = validHairColor (getAttributeFromPassport attributes 3)

    heightVerdict = validHeight (getAttributeFromPassport attributes 4)

    issueYearVerdict = validIssueYear (getAttributeFromPassport attributes 5)

    pidVerdict = validPid (getAttributeFromPassport attributes 6)
  in
    birthYearVerdict && eyeColorVerdict && expirationYearVerdict && hairColorVerdict && heightVerdict && issueYearVerdict && pidVerdict

getAttributeFromPassport: Array.Array String-> Int -> String
getAttributeFromPassport attributes idx = (String.dropLeft 4 (Maybe.withDefault "???" (Array.get idx attributes)))

parseAttributes: String -> List String
parseAttributes passport = 
  (List.filter isEmpty (List.concat (List.map (String.split "\n") (String.split " " passport))))


attributeNames: List String -> List String
attributeNames attributes = 
  List.map (Maybe.withDefault "???") (List.map (Array.get 0) (List.map Array.fromList (List.map (String.split ":") attributes)))
  
isEmpty: String -> Bool
isEmpty attribute = (String.length attribute) > 0

notCid: String -> Bool
notCid attribute = 
  attribute /= "cid"

notCidFull: String -> Bool
notCidFull attribute =
  if Regex.contains (Maybe.withDefault Regex.never (Regex.fromString "(cid:.+)")) attribute then
    False
  else
    True
-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ textarea [ placeholder "Passports to analyze", value model.content, onInput Change ] []
    , div [] [ text (process model.content) ]
    ]