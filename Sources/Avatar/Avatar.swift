//
//  Avatar.swift
//  Yamb
//
//  Created by Kresimir Prcela on 26.12.2021..
//  Copyright © 2021 Rika Omega Rika. All rights reserved.
//

import Foundation
import UIKit

public class Avatar {
    
    enum Eyes: Int, CaseIterable, AvatarSymbol {
        // 5 bits
        case Closed = 0
        case Cry
        case Default
        case Roll
        case Happy
        case Side
        case Hearts
        case Squint
        case Surprised
        case Wink
        case WinkWacky
        case Dizzy
        case White
        case WhiteLine
        case BlackLine
        case Lower
        case White2
        case White3
        
        func image() -> UIImage? {
            switch self {
            case .Closed:
                return UIImage(named: "Closed", in: .module, compatibleWith: .current)
            case .Cry:
                return UIImage(named: "Cry", in: .module, compatibleWith: .current)
            case .Default:
                return UIImage(named: "Default Eyes", in: .module, compatibleWith: .current)
            case .Roll:
                return UIImage(named: "Eye Roll", in: .module, compatibleWith: .current)
            case .Happy:
                return UIImage(named: "Happy", in: .module, compatibleWith: .current)
            case .Side:
                return UIImage(named: "Side", in: .module, compatibleWith: .current)
            case .Hearts:
                return UIImage(named: "Hearts", in: .module, compatibleWith: .current)
            case .Squint:
                return UIImage(named: "Squint", in: .module, compatibleWith: .current)
            case .Surprised:
                return UIImage(named: "Surprised", in: .module, compatibleWith: .current)
            case .Wink:
                return UIImage(named: "Wink", in: .module, compatibleWith: .current)
            case .WinkWacky:
                return UIImage(named: "Wink Wacky", in: .module, compatibleWith: .current)
            case .Dizzy:
                return UIImage(named: "X Dizzy", in: .module, compatibleWith: .current)
            case .White:
                return UIImage(named: "WhiteEyes", in: .module, compatibleWith: .current)
            case .WhiteLine:
                return UIImage(named: "WhiteLine", in: .module, compatibleWith: .current)
            case .BlackLine:
                return UIImage(named: "BlackLine", in: .module, compatibleWith: .current)
            case .Lower:
                return UIImage(named: "<Eyes", in: .module, compatibleWith: .current)
            case .White2:
                return UIImage(named: "White2", in: .module, compatibleWith: .current)
            case .White3:
                return UIImage(named: "White3", in: .module, compatibleWith: .current)
            }
        }
    }
    enum Mouth: Int, CaseIterable, AvatarSymbol {
        // 5 bits
        case Concerned = 0
        case Default
        case Disbelief
        case Eating
        case Grimace
        case Sad
        case ScreamOpen
        case Serious
        case Smile
        case Tongue
        case Twinkle
        case Vomit
        case Lipstick
        case Lipstick2
        case Lipstick3
        case Kiss
        case Meh
        case Disbelief2
        case WhiteSmile
        
        func image() -> UIImage? {
            switch self {
            case .Concerned:
                return UIImage(named: "Concerned", in: .module, compatibleWith: .current)
            case .Default:
                return UIImage(named: "Default mouth", in: .module, compatibleWith: .current)
            case .Disbelief:
                return UIImage(named: "Disbelief", in: .module, compatibleWith: .current)
            case .Eating:
                return UIImage(named: "Eating", in: .module, compatibleWith: .current)
            case .Grimace:
                return UIImage(named: "Grimace", in: .module, compatibleWith: .current)
            case .Sad:
                return UIImage(named: "Sad", in: .module, compatibleWith: .current)
            case .ScreamOpen:
                return UIImage(named: "Scream Open", in: .module, compatibleWith: .current)
            case .Serious:
                return UIImage(named: "Serious", in: .module, compatibleWith: .current)
            case .Smile:
                return UIImage(named: "Smile", in: .module, compatibleWith: .current)
            case .Tongue:
                return UIImage(named: "Tongue", in: .module, compatibleWith: .current)
            case .Twinkle:
                return UIImage(named: "Twinkle", in: .module, compatibleWith: .current)
            case .Vomit:
                return UIImage(named: "Vomit", in: .module, compatibleWith: .current)
            case .Lipstick:
                return UIImage(named: "Lipstick", in: .module, compatibleWith: .current)
            case .Lipstick2:
                return UIImage(named: "Lipstick2", in: .module, compatibleWith: .current)
            case .Lipstick3:
                return UIImage(named: "Lipstick3", in: .module, compatibleWith: .current)
            case .Kiss:
                return UIImage(named: "Kiss", in: .module, compatibleWith: .current)
            case .Meh:
                return UIImage(named: "Meh", in: .module, compatibleWith: .current)
            case .Disbelief2:
                return UIImage(named: "Disbelief2", in: .module, compatibleWith: .current)
            case .WhiteSmile:
                return UIImage(named: "WhiteSmile", in: .module, compatibleWith: .current)
            }
        }
    }
    enum Eyebrow: Int, CaseIterable, AvatarSymbol {
        
        case None = 0
        case AngryNatural
        case Angry
        case DefaultNatural
        case Default
        case FlatNatural
        case FrownNatural
        case RaisedExcitedNatural
        case RaisedExcited
        case SadConcernedNatural
        case SadConcerned
        case UnibrowNatural
        case UpDownNatural
        case UpDown
        
        func image() -> UIImage? {
            switch self {
            case .None:
                return nil
            case .AngryNatural:
                return UIImage(named: "Angry Natural", in: .module, compatibleWith: .current)
            case .Angry:
                return UIImage(named: "Angry", in: .module, compatibleWith: .current)
            case .DefaultNatural:
                return UIImage(named: "Default Natural", in: .module, compatibleWith: .current)
            case .Default:
                return UIImage(named: "Default", in: .module, compatibleWith: .current)
            case .FlatNatural:
                return UIImage(named: "Flat Natural", in: .module, compatibleWith: .current)
            case .FrownNatural:
                return UIImage(named: "Frown Natural", in: .module, compatibleWith: .current)
            case .RaisedExcitedNatural:
                return UIImage(named: "Raised Excited Natural", in: .module, compatibleWith: .current)
            case .RaisedExcited:
                return UIImage(named: "Raised Excited", in: .module, compatibleWith: .current)
            case .SadConcernedNatural:
                return UIImage(named: "Sad Concerned Natural", in: .module, compatibleWith: .current)
            case .SadConcerned:
                return UIImage(named: "Sad Concerned", in: .module, compatibleWith: .current)
            case .UnibrowNatural:
                return UIImage(named: "Unibrow Natural", in: .module, compatibleWith: .current)
            case .UpDownNatural:
                return UIImage(named: "Up Down Natural", in: .module, compatibleWith: .current)
            case .UpDown:
                return UIImage(named: "Up Down", in: .module, compatibleWith: .current)
            }
        }
    }
    enum Glasses: Int, CaseIterable, AvatarSymbol {
        // 5 bits
        case None = 0
        case Kurt
        case Prescription1
        case Prescription2
        case Round
        case Sunglasses
        case Wayfarers
        case KurtRed
        case OliverBlack
        case OliverGreen
        case Lines
        case Prozirne
        case Bakine
        case Bakine2
        case StarsGlasses
        
        func image() -> UIImage? {
            switch self {
            case .None:
                return nil
            case .Kurt:
                return UIImage(named: "Kurt", in: .module, compatibleWith: .current)
            case .Prescription1:
                return UIImage(named: "Prescription 01", in: .module, compatibleWith: .current)
            case .Prescription2:
                return UIImage(named: "Prescription 02", in: .module, compatibleWith: .current)
            case .Round:
                return UIImage(named: "Round", in: .module, compatibleWith: .current)
            case .Sunglasses:
                return UIImage(named: "Sunglasses", in: .module, compatibleWith: .current)
            case .Wayfarers:
                return UIImage(named: "Wayfarers", in: .module, compatibleWith: .current)
            case .KurtRed:
                return UIImage(named: "KurtRed", in: .module, compatibleWith: .current)
            case .OliverBlack:
                return UIImage(named: "OliverBlack", in: .module, compatibleWith: .current)
            case .OliverGreen:
                return UIImage(named: "OliverGreen", in: .module, compatibleWith: .current)
            case .Lines:
                return UIImage(named: "GlassesLines", in: .module, compatibleWith: .current)
            case .Prozirne:
                return UIImage(named: "Prozirne", in: .module, compatibleWith: .current)
            case .Bakine:
                return UIImage(named: "BakineGlasses", in: .module, compatibleWith: .current)
            case .Bakine2:
                return UIImage(named: "Bakine2Glasses", in: .module, compatibleWith: .current)
            case .StarsGlasses:
                return UIImage(named: "StarsGlasses", in: .module, compatibleWith: .current)
            }
        }
    }
    enum Hair: Int, CaseIterable, AvatarSymbol {
        case None
        case Dreads1
        case Dreads2
        case Frizzle
        case ShaggyMullet
        case Shaggy
        case ShortCurly
        case ShortFlat
        case ShortRound
        case ShortWaved
        case Sides
        case CeasarSide
        case Ceasar
        case Bun
        case Curvy
        case Dreads
        case Frida
        case ShavedSides
        case Straight
        // top accessories
        case Eyepatch
        case Hat
        case Turban
        case Hijab
        case WinterHat1
        case WinterHat2
        case WinterHat3
        case WinterHat4
        case StraightStrand
        case LStraight
        case MiaWallace
        case LongButNotTooLong
        case Fro
        case Curly
        case Bob
        case Big
        case ShortRoundFriz
        case StraightLeft
        
        func image() -> UIImage? {
            switch self {
            case .None:
                return nil
            case .Dreads1:
                return UIImage(named: "Dreads 01", in: .module, compatibleWith: .current)
            case .Dreads2:
                return UIImage(named: "Dreads 02", in: .module, compatibleWith: .current)
            case .Frizzle:
                return UIImage(named: "Frizzle", in: .module, compatibleWith: .current)
            case .ShaggyMullet:
                return UIImage(named: "Shaggy Mullet", in: .module, compatibleWith: .current)
            case .Shaggy:
                return UIImage(named: "Shaggy", in: .module, compatibleWith: .current)
            case .ShortCurly:
                return UIImage(named: "Short Curly", in: .module, compatibleWith: .current)
            case .ShortFlat:
                return UIImage(named: "Short Flat", in: .module, compatibleWith: .current)
            case .ShortRound:
                return UIImage(named: "Short Round", in: .module, compatibleWith: .current)
            case .ShortWaved:
                return UIImage(named: "Short Waved", in: .module, compatibleWith: .current)
            case .Sides:
                return UIImage(named: "Sides", in: .module, compatibleWith: .current)
            case .CeasarSide:
                return UIImage(named: "The Caesar + Side Part", in: .module, compatibleWith: .current)
            case .Ceasar:
                return UIImage(named: "The Caesar", in: .module, compatibleWith: .current)
            case .Bun:
                return UIImage(named: "Bun", in: .module, compatibleWith: .current)
            case .Curvy:
                return UIImage(named: "Curvy", in: .module, compatibleWith: .current)
            case .Dreads:
                return UIImage(named: "Dreads", in: .module, compatibleWith: .current)
            case .Frida:
                return UIImage(named: "Frida", in: .module, compatibleWith: .current)
            case .ShavedSides:
                return UIImage(named: "Shaved Sides", in: .module, compatibleWith: .current)
            case .Straight:
                return UIImage(named: "Straight", in: .module, compatibleWith: .current)
            case .Eyepatch:
                return UIImage(named: "Eyepatch", in: .module, compatibleWith: .current)
            case .Hat:
                return UIImage(named: "Hat", in: .module, compatibleWith: .current)
            case .Turban:
                return UIImage(named: "Turban", in: .module, compatibleWith: .current)
            case .Hijab:
                return UIImage(named: "Hijab", in: .module, compatibleWith: .current)
            case .WinterHat1:
                return UIImage(named: "Winter Hat 1", in: .module, compatibleWith: .current)
            case .WinterHat2:
                return UIImage(named: "Winter Hat 2", in: .module, compatibleWith: .current)
            case .WinterHat3:
                return UIImage(named: "Winter Hat 3", in: .module, compatibleWith: .current)
            case .WinterHat4:
                return UIImage(named: "Winter Hat 4", in: .module, compatibleWith: .current)
            case .StraightStrand:
                return UIImage(named: "StraightStrand", in: .module, compatibleWith: .current)
            case .LStraight:
                return UIImage(named: "LStraight", in: .module, compatibleWith: .current)
            case .MiaWallace:
                return UIImage(named: "Mia Wallace", in: .module, compatibleWith: .current)
            case .LongButNotTooLong:
                return UIImage(named: "Long but not too long", in: .module, compatibleWith: .current)
            case .Fro:
                return UIImage(named: "Fro", in: .module, compatibleWith: .current)
            case .Curly:
                return UIImage(named: "Curly", in: .module, compatibleWith: .current)
            case .Bob:
                return UIImage(named: "Bob", in: .module, compatibleWith: .current)
            case .Big:
                return UIImage(named: "Big", in: .module, compatibleWith: .current)
            case .ShortRoundFriz:
                return UIImage(named: "Short Round Friz", in: .module, compatibleWith: .current)
            case .StraightLeft:
                return UIImage(named: "StraightLeft", in: .module, compatibleWith: .current)
            }
        }
        
    }
    enum Clothing: Int, CaseIterable, AvatarSymbol {
        case Shirt
        case Sweater
        case CollarSweater
        case Dress
        case Hoodie
        case Overall
        case ShirtCrewNeck
        case ShirtScoopNeck
        case ShirtVNeck
        case Dolce
        case Undershirt
        case UndershirtW
        case LeftSide
        
        func image() -> UIImage? {
            switch self {
            case .Shirt:
                return UIImage(named: "Shirt", in: .module, compatibleWith: .current)
            case .Sweater:
                return UIImage(named: "Sweater", in: .module, compatibleWith: .current)
            case .CollarSweater:
                return UIImage(named: "Collar + Sweater", in: .module, compatibleWith: .current)
            case .Dress:
                return UIImage(named: "Dress", in: .module, compatibleWith: .current)
            case .Hoodie:
                return UIImage(named: "Hoodie", in: .module, compatibleWith: .current)
            case .Overall:
                return UIImage(named: "Overall", in: .module, compatibleWith: .current)
            case .ShirtCrewNeck:
                return UIImage(named: "Shirt Crew Neck", in: .module, compatibleWith: .current)
            case .ShirtScoopNeck:
                return UIImage(named: "Shirt Scoop Neck", in: .module, compatibleWith: .current)
            case .ShirtVNeck:
                return UIImage(named: "Shirt V Neck", in: .module, compatibleWith: .current)
            case .Dolce:
                return UIImage(named: "Dolce", in: .module, compatibleWith: .current)
            case .Undershirt:
                return UIImage(named: "Undershirt", in: .module, compatibleWith: .current)
            case .UndershirtW:
                return UIImage(named: "UndershirtW", in: .module, compatibleWith: .current)
            case .LeftSide:
                return UIImage(named: "ShirtLeftSide", in: .module, compatibleWith: .current)
            }
        }
    }
    enum FacialHair: Int, CaseIterable, AvatarSymbol {
        case None
        case BeardLight
        case BeardMagestic
        case BeardMedium
        case MoustacheFancy
        case MoustacheMagnum
        case Bradica
        case Metal
        
        func image() -> UIImage? {
            switch self {
            case .None:
                return nil
            case .BeardLight:
                return UIImage(named: "Beard Light", in: .module, compatibleWith: .current)
            case .BeardMagestic:
                return UIImage(named: "Beard Magestic", in: .module, compatibleWith: .current)
            case .BeardMedium:
                return UIImage(named: "Beard Medium", in: .module, compatibleWith: .current)
            case .MoustacheFancy:
                return UIImage(named: "Moustache Fancy", in: .module, compatibleWith: .current)
            case .MoustacheMagnum:
                return UIImage(named: "Moustache Magnum", in: .module, compatibleWith: .current)
            case .Bradica:
                return UIImage(named: "Bradica", in: .module, compatibleWith: .current)
            case .Metal:
                return UIImage(named: "BeardMetal", in: .module, compatibleWith: .current)
            }
        }
        
    }
    enum Addition: Int, CaseIterable, AvatarSymbol {
        // 4 bits
        case None
        case Blazer
        case Freckles
        case Hairband
        case Old
        case Makeup
        case AddHearts
        
        func image() -> UIImage? {
            switch self {
            case .None:
                return nil
            case .Blazer:
                return UIImage(named: "Blazer", in: .module, compatibleWith: .current)
            case .Freckles:
                return UIImage(named: "Freckles", in: .module, compatibleWith: .current)
            case .Hairband:
                return UIImage(named: "Hairband", in: .module, compatibleWith: .current)
            case .Old:
                return UIImage(named: "OldMan", in: .module, compatibleWith: .current)
            case .Makeup:
                return UIImage(named: "Makeup", in: .module, compatibleWith: .current)
            case .AddHearts:
                return UIImage(named: "AddHearts", in: .module, compatibleWith: .current)
            }
        }
    }
    
    enum Skin: Int, CaseIterable, AvatarSymbol {
        // 1 bit
        case Normal
        case Bot
        func image() -> UIImage? {
            let imageName: String
            switch self {
            case .Normal:
                imageName = "Body"
            case .Bot:
                imageName = AvatarView.enableBots ? "Bot" : "Body"
            }
            return UIImage(named: imageName, in: .module, compatibleWith: .current)
        }
    }
    enum Nose: Int, CaseIterable, AvatarSymbol {
        case Normal
        case Mini
        case Big
        case Left
        case Round
        
        func image() -> UIImage? {
            switch self {
            case .Normal:
                return UIImage(named: "Default Nose", in: .module, compatibleWith: .current)
            case .Mini:
                return UIImage(named: "Mini Nose", in: .module, compatibleWith: .current)
            case .Big:
                return UIImage(named: "Big Nose", in: .module, compatibleWith: .current)
            case .Left:
                return UIImage(named: "Left Nose", in: .module, compatibleWith: .current)
            case .Round:
                return UIImage(named: "Round Nose", in: .module, compatibleWith: .current)
            }
        }
    }
    enum ClothLogo: Int, CaseIterable, AvatarSymbol {
        // 5 bits
        case None
        case Custom
        case Bat
        case Bear
        case Cumbia
        case Deer
        case Diamond
        case Hola
        case Pizza
        case Resist
        case Selena
        case SkullOutline
        case Skull
        case Apple
        case Sparkles
        case Heart
        case Fire
        case Flash
        case Piece
        case Sun
        case Beer
        case Ball
        case Lucky
        
        func image() -> UIImage? {
            switch self {
            case .None:
                return nil
            case .Custom:
                return UIImage(named: "Custom", in: .module, compatibleWith: .current)
            case .Bat:
                return UIImage(named: "Bat", in: .module, compatibleWith: .current)
            case .Bear:
                return UIImage(named: "Bear", in: .module, compatibleWith: .current)
            case .Cumbia:
                return UIImage(named: "Cumbia", in: .module, compatibleWith: .current)
            case .Deer:
                return UIImage(named: "Deer", in: .module, compatibleWith: .current)
            case .Diamond:
                return UIImage(named: "Diamond", in: .module, compatibleWith: .current)
            case .Hola:
                return UIImage(named: "Hola", in: .module, compatibleWith: .current)
            case .Pizza:
                return UIImage(named: "Pizza", in: .module, compatibleWith: .current)
            case .Resist:
                return UIImage(named: "Resist", in: .module, compatibleWith: .current)
            case .Selena:
                return UIImage(named: "Selena", in: .module, compatibleWith: .current)
            case .SkullOutline:
                return UIImage(named: "Skull Outline", in: .module, compatibleWith: .current)
            case .Skull:
                return UIImage(named: "Skull", in: .module, compatibleWith: .current)
            case .Apple:
                return UIImage(named: "AppleLogo", in: .module, compatibleWith: .current)
            case .Sparkles:
                return UIImage(named: "SparklesLogo", in: .module, compatibleWith: .current)
            case .Heart:
                return UIImage(named: "HeartLogo", in: .module, compatibleWith: .current)
            case .Fire:
                return UIImage(named: "FireLogo", in: .module, compatibleWith: .current)
            case .Flash:
                return UIImage(named: "FlashLogo", in: .module, compatibleWith: .current)
            case .Piece:
                return UIImage(named: "PieceLogo", in: .module, compatibleWith: .current)
            case .Sun:
                return UIImage(named: "SunLogo", in: .module, compatibleWith: .current)
            case .Beer:
                return UIImage(named: "BeerLogo", in: .module, compatibleWith: .current)
            case .Ball:
                return UIImage(named: "BallLogo", in: .module, compatibleWith: .current)
            case .Lucky:
                return UIImage(named: "LuckyLogo", in: .module, compatibleWith: .current)
            }
        }
    }
    
    enum Part: CaseIterable {
        case Eyes
        case Mouth
        case Eyebrow
        case Glasses
        case Hair
        case Clothing
        case FacialHair
        case Addition
        case Skin
        case Nose
        case ClothLogo
        
        func symbols() -> [AvatarSymbol] {
            switch self {
            case .Eyes:
                return Avatar.Eyes.allCases
            case .Mouth:
                return Avatar.Mouth.allCases
            case .Eyebrow:
                return Avatar.Eyebrow.allCases
            case .Glasses:
                return Avatar.Glasses.allCases
            case .Hair:
                return Avatar.Hair.allCases
            case .Clothing:
                return Avatar.Clothing.allCases
            case .FacialHair:
                return Avatar.FacialHair.allCases
            case .Addition:
                return Avatar.Addition.allCases
            case .Skin:
                return Avatar.Skin.allCases
            case .Nose:
                return Avatar.Nose.allCases
            case .ClothLogo:
                return Avatar.ClothLogo.allCases
            }
        }
        
        func colors() -> [UIColor] {
            switch self {
            case .Skin:
                return [
                    UIColor(netHex: 0xffFD9841),
                    UIColor(netHex: 0xffF8D25C),
                    UIColor(netHex: 0xffFFDBB4),
                    UIColor(netHex: 0xffEDB98A),
                    UIColor(netHex: 0xffD08B5B),
                    UIColor(netHex: 0xffAE5D29),
                    UIColor(netHex: 0xff614335),
                    UIColor(netHex: 0xff92c177),
                    UIColor(netHex: 0xff7da8d2)
                ]
            case .Hair, .FacialHair:
                return [
                    UIColor(netHex: 0xFFA55728),
                    UIColor(netHex: 0xff2C1B18),
                    UIColor(netHex: 0xffB58143),
                    UIColor(netHex: 0xffD6B370),
                    UIColor(netHex: 0xff724133),
                    UIColor(netHex: 0xff4A312C),
                    UIColor(netHex: 0xffF59797),
                    UIColor(netHex: 0xffECDCBF),
                    UIColor(netHex: 0xffC93305),
                    UIColor(netHex: 0xffE8E1E1),
                    UIColor(netHex: 0xff9d497b),
                    UIColor(netHex: 0xff377a81),
                    UIColor(netHex: 0xff213c85),
                    UIColor(netHex: 0xffcdb29b)
                ]
            case .Clothing:
                return [
                    UIColor(netHex: 0xff262E33),
                    UIColor(netHex: 0xff65C9FF),
                    UIColor(netHex: 0xff5199E4),
                    UIColor(netHex: 0xff25557C),
                    UIColor(netHex: 0xffE6E6E6),
                    UIColor(netHex: 0xff929598),
                    UIColor(netHex: 0xff3C4F5C),
                    UIColor(netHex: 0xffB1E2FF),
                    UIColor(netHex: 0xffA7FFC4),
                    UIColor(netHex: 0xffFFDEB5),
                    UIColor(netHex: 0xffFFAFB9),
                    UIColor(netHex: 0xffFFFFB1),
                    UIColor(netHex: 0xffFF488E),
                    UIColor(netHex: 0xffFF5C5C),
                    UIColor(netHex: 0xffFFFFFF),
                    UIColor(netHex: 0xffbad090),
                    UIColor(netHex: 0xff1b9ba8),
                    UIColor(netHex: 0xff11843a),
                    UIColor(netHex: 0xff192c18),
                    UIColor(netHex: 0xfffca530),
                    UIColor(netHex: 0xfffbd191),
                    UIColor(netHex: 0xff48346c),
                    UIColor(netHex: 0xff6f6dac),
                    UIColor(netHex: 0xfffb4322),
                    UIColor(netHex: 0xff7a0017),
                    UIColor(netHex: 0xffd6c1a6)
                ]
            default:
                return []
            }
        }
    }
    
    var skinColorIdx = 0
    var skin: Skin = .Normal
    var eyes: Eyes = .Default
    var mouth: Mouth = .Default
    var eyebrow: Eyebrow = .Default
    var glasses: Glasses = .None
    var hair: Hair = .None
    var hairColorIdx: Int = 0
    var clothing: Clothing = .Sweater
    var clothingColorIdx = 0
    var facialHair: FacialHair = .None
    var facialHairColorIdx = 0
    var addition: Addition = .None
    var nose: Nose = .Normal
    var clothLogo: ClothLogo = .None
    
    var hasCrown = false
    var hasBomb = false
    
    
    
    func set(part: Part, symbol: AvatarSymbol) {
        switch part {
        case .Eyes:
            eyes = Eyes(rawValue: symbol.rawValue)!
        case .Mouth:
            mouth = Mouth(rawValue: symbol.rawValue)!
        case .Eyebrow:
            eyebrow = Eyebrow(rawValue: symbol.rawValue)!
        case .Glasses:
            glasses = Glasses(rawValue: symbol.rawValue)!
        case .Hair:
            hair = Hair(rawValue: symbol.rawValue)!
        case .Clothing:
            clothing = Clothing(rawValue: symbol.rawValue)!
        case .FacialHair:
            facialHair = FacialHair(rawValue: symbol.rawValue)!
        case .Addition:
            addition = Addition(rawValue: symbol.rawValue)!
        case .Skin:
            break
        case .Nose:
            nose = Nose(rawValue: symbol.rawValue)!
        case .ClothLogo:
            clothLogo = ClothLogo(rawValue: symbol.rawValue)!
        }
    }
    
    func set(part: Part, colorIdx: Int) {
        switch part {
        case .Skin:
            skinColorIdx = colorIdx
        case .Hair:
            hairColorIdx = colorIdx
        case .FacialHair:
            facialHairColorIdx = colorIdx
        case .Clothing:
            clothingColorIdx = colorIdx
        default:
            break
        }
    }
    
    public func compress() -> Int64 {
        var result = Int64(0)
        func addBits(_ ctBits:Int, v: Int) {
            result <<= ctBits
            result |= Int64(v)
        }
        addBits(1, v: skin.rawValue)
        addBits(4, v: skinColorIdx)
        addBits(5, v: eyes.rawValue)
        addBits(5, v: mouth.rawValue)
        addBits(4, v: eyebrow.rawValue)
        addBits(5, v: glasses.rawValue)
        addBits(6, v: hair.rawValue)
        addBits(4, v: hairColorIdx)
        addBits(4, v: clothing.rawValue)
        addBits(5, v: clothingColorIdx)
        addBits(4, v: facialHair.rawValue)
        addBits(4, v: facialHairColorIdx)
        addBits(4, v: addition.rawValue)
        addBits(3, v: nose.rawValue)
        addBits(5, v: clothLogo.rawValue)
        
        return result
    }
    
    public class func decompress(value: Int64) -> Avatar {
        let avatar = Avatar()
        var v = value
        func read1bit() -> Int {
            let rv = v & 0b1
            v >>= 1
            return Int(rv)
        }
        func read2bits() -> Int {
            let rv = v & 0b11
            v >>= 2
            return Int(rv)
        }
        func read3bits() -> Int {
            let rv = v & 0b111
            v >>= 3
            return Int(rv)
        }
        func read4bits() -> Int {
            let rv = v & 0b1111
            v >>= 4
            return Int(rv)
        }
        func read5bits() -> Int {
            let rv = v & 0b11111
            v >>= 5
            return Int(rv)
        }
        func read6bits() -> Int {
            let rv = v & 0b111111
            v >>= 6
            return Int(rv)
        }
        avatar.clothLogo = ClothLogo(rawValue: read5bits()) ?? .None
        avatar.nose = Nose(rawValue: read3bits()) ?? .Normal
        avatar.addition = Addition(rawValue: read4bits()) ?? .None
        avatar.facialHairColorIdx = read4bits()
        avatar.facialHair = FacialHair(rawValue: read4bits()) ?? .None
        avatar.clothingColorIdx = read5bits()
        avatar.clothing = Clothing(rawValue: read4bits()) ?? .Shirt
        avatar.hairColorIdx = read4bits()
        avatar.hair = Hair(rawValue: read6bits()) ?? .None
        avatar.glasses = Glasses(rawValue: read5bits()) ?? .None
        avatar.eyebrow = Eyebrow(rawValue: read4bits()) ?? .Default
        avatar.mouth = Mouth(rawValue: read5bits()) ?? .Default
        avatar.eyes = Eyes(rawValue: read5bits()) ?? .Closed
        avatar.skinColorIdx = read4bits()
        avatar.skin = Skin(rawValue: read1bit()) ?? .Normal
        
        return avatar
    }
    
}


protocol AvatarSymbol: Any {
    func image() -> UIImage?
    var rawValue: Int { get }
}
