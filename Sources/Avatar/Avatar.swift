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
    public enum BodyType: Int, CaseIterable {
        case normal = 0, slim = 1, verySlim = 2, broad = 3, veryBroad = 4
        var scaleX: CGFloat {
            switch self {
            case .normal: return 1
            case .slim: return 0.85
            case .verySlim: return 0.70
            case .broad: return 1.15
            case .veryBroad: return 1.30
            }
        }
    }
    public var bodyType: BodyType = .normal {
        didSet { loadedHexID?.bodyType = bodyType.rawValue }
    }
    var additionColorIdx = 0 {
        didSet { loadedHexID?.additionColor = additionColorIdx }
    }
    var jerseyNumber = 0 {
        didSet { loadedHexID?.jerseyNumber = jerseyNumber }
    }
    private var loadedHexID: AvatarHexID?
    private var loadedValues = [Int]()

    
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
                return UIImage(resource: .closed)
            case .Cry:
                return UIImage(resource: .cry)
            case .Default:
                return UIImage(resource: .defaultEyes)
            case .Roll:
                return UIImage(resource: .eyeRoll)
            case .Happy:
                return UIImage(resource: .happy)
            case .Side:
                return UIImage(resource: .side)
            case .Hearts:
                return UIImage(resource: .hearts)
            case .Squint:
                return UIImage(resource: .squint)
            case .Surprised:
                return UIImage(resource: .surprised)
            case .Wink:
                return UIImage(resource: .wink)
            case .WinkWacky:
                return UIImage(resource: .winkWacky)
            case .Dizzy:
                return UIImage(resource: .xDizzy)
            case .White:
                return UIImage(resource: .whiteEyes)
            case .WhiteLine:
                return UIImage(resource: .whiteLine)
            case .BlackLine:
                return UIImage(resource: .blackLine)
            case .Lower:
                return UIImage(resource: .lEyes)
            case .White2:
                return UIImage(resource: .white2)
            case .White3:
                return UIImage(resource: .white3)
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
        case PinkLips
        case PinkSmile
        case RoseLips
        
        func image() -> UIImage? {
            switch self {
            case .Concerned:
                return UIImage(resource: .concerned)
            case .Default:
                return UIImage(resource: .defaultMouth)
            case .Disbelief:
                return UIImage(resource: .disbelief)
            case .Eating:
                return UIImage(resource: .eating)
            case .Grimace:
                return UIImage(resource: .grimace)
            case .Sad:
                return UIImage(resource: .sad)
            case .ScreamOpen:
                return UIImage(resource: .screamOpen)
            case .Serious:
                return UIImage(resource: .serious)
            case .Smile:
                return UIImage(resource: .smile)
            case .Tongue:
                return UIImage(resource: .tongue)
            case .Twinkle:
                return UIImage(resource: .twinkle)
            case .Vomit:
                return UIImage(resource: .vomit)
            case .Lipstick:
                return UIImage(resource: .lipstick)
            case .Lipstick2:
                return UIImage(resource: .lipstick2)
            case .Lipstick3:
                return UIImage(resource: .lipstick3)
            case .Kiss:
                return UIImage(resource: .kiss)
            case .Meh:
                return UIImage(resource: .meh)
            case .Disbelief2:
                return UIImage(resource: .disbelief2)
            case .WhiteSmile:
                return UIImage(resource: .whiteSmile)
            case .PinkLips:
                return UIImage(named: "Pink Lips", in: .module, compatibleWith: .current)
            case .PinkSmile:
                return UIImage(named: "Pink Smile", in: .module, compatibleWith: .current)
            case .RoseLips:
                return UIImage(named: "Rose Lips", in: .module, compatibleWith: .current)
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
        case SoftSquare
        case ThinSquare
        case BoldShades
        case SkiGoggles
        
        case Monocle
        case FutureVisor

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
            case .SoftSquare:
                return UIImage(named: "Soft Square", in: .module, compatibleWith: .current)
            case .ThinSquare:
                return UIImage(named: "Thin Square", in: .module, compatibleWith: .current)
            case .BoldShades:
                return UIImage(named: "Bold Shades", in: .module, compatibleWith: .current)
            case .SkiGoggles:
                return UIImage(named: "SkiGoggles", in: .module, compatibleWith: .current)
            case .Monocle:
                return UIImage(named: "Monocle", in: .module, compatibleWith: .current)
            case .FutureVisor:
                return UIImage(named: "FutureVisor", in: .module, compatibleWith: .current)
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
        case BuzzCut
        case Bieber
        case MessyFringe
        case SideFringe
        case LongWavy
        case GlamWaves
        case SleekBob
        case WavyBob
        case TexturedCrop
        case SideSweep
        case Spiky
        case CowboyHat
        case BaseballCap
        case ChefHat
        case VikingHelmet
        case Mohawk
        case Pompadour
        case CurtainPart
        case HighPonytail
        case SpaceBuns
        
        case BucketHat
        case Beret
        case BackwardCap
        case LowFade
        case FlatTop
        case TwinBraids

        var appearanceScale: CGFloat {
            switch self {
            case .BucketHat: return 1.08
            case .Beret, .LowFade: return 1.15
            case .BackwardCap: return 1.0925
            case .FlatTop: return 1.10
            default: return 1
            }
        }

        var scaleAnchorY: CGFloat {
            switch self {
            case .BucketHat: return 51.5
            case .Beret: return 45.5
            case .BackwardCap: return 51
            case .LowFade: return 75.5
            case .FlatTop: return 65.5
            default: return 140
            }
        }

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
            case .BuzzCut:
                return UIImage(named: "Buzz Cut", in: .module, compatibleWith: .current)
            case .Bieber:
                return UIImage(named: "Bieber", in: .module, compatibleWith: .current)
            case .MessyFringe:
                return UIImage(named: "Messy Fringe", in: .module, compatibleWith: .current)
            case .SideFringe:
                return UIImage(named: "Side Fringe", in: .module, compatibleWith: .current)
            case .LongWavy:
                return UIImage(named: "Long Wavy", in: .module, compatibleWith: .current)
            case .GlamWaves:
                return UIImage(named: "Glam Waves", in: .module, compatibleWith: .current)
            case .SleekBob:
                return UIImage(named: "Sleek Bob", in: .module, compatibleWith: .current)
            case .WavyBob:
                return UIImage(named: "Wavy Bob", in: .module, compatibleWith: .current)
            case .TexturedCrop:
                return UIImage(named: "Textured Crop", in: .module, compatibleWith: .current)
            case .SideSweep:
                return UIImage(named: "Side Sweep", in: .module, compatibleWith: .current)
            case .Spiky:
                return UIImage(named: "Spiky", in: .module, compatibleWith: .current)
            case .CowboyHat:
                return UIImage(named: "CowboyHat", in: .module, compatibleWith: .current)
            case .BaseballCap:
                return UIImage(named: "BaseballCap", in: .module, compatibleWith: .current)
            case .ChefHat:
                return UIImage(named: "ChefHat", in: .module, compatibleWith: .current)
            case .VikingHelmet:
                return UIImage(named: "VikingHelmet", in: .module, compatibleWith: .current)
            case .Mohawk:
                return UIImage(named: "Mohawk", in: .module, compatibleWith: .current)
            case .Pompadour:
                return UIImage(named: "Pompadour", in: .module, compatibleWith: .current)
            case .CurtainPart:
                return UIImage(named: "CurtainPart", in: .module, compatibleWith: .current)
            case .HighPonytail:
                return UIImage(named: "HighPonytail", in: .module, compatibleWith: .current)
            case .SpaceBuns:
                return UIImage(named: "SpaceBuns", in: .module, compatibleWith: .current)
            case .BucketHat:
                return UIImage(named: "BucketHat", in: .module, compatibleWith: .current)
            case .Beret:
                return UIImage(named: "Beret", in: .module, compatibleWith: .current)
            case .BackwardCap:
                return UIImage(named: "BackwardCap", in: .module, compatibleWith: .current)
            case .LowFade:
                return UIImage(named: "LowFade", in: .module, compatibleWith: .current)
            case .FlatTop:
                return UIImage(named: "FlatTop", in: .module, compatibleWith: .current)
            case .TwinBraids:
                return UIImage(named: "TwinBraids", in: .module, compatibleWith: .current)
            }
        }

        func image(color: UIColor) -> UIImage? {
            if [.BucketHat, .Beret, .BackwardCap, .LowFade, .FlatTop, .TwinBraids].contains(self) {
                return image()?.avatarTinted(color)
            }
            guard self == .CowboyHat || self == .BaseballCap, let image = image() else {
                return image()
            }

            let bounds = CGRect(origin: .zero, size: image.size)
            let format = UIGraphicsImageRendererFormat()
            format.scale = image.scale
            let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
            let shading = renderer.image { context in
                UIColor.white.setFill()
                context.cgContext.fill(bounds)
                image.draw(in: bounds, blendMode: .luminosity, alpha: 1)
                context.cgContext.setBlendMode(.plusLighter)
                UIColor(white: 0.55, alpha: 1).setFill()
                context.cgContext.fill(bounds)
            }

            return renderer.image { context in
                color.setFill()
                context.cgContext.fill(bounds)
                shading.draw(in: bounds, blendMode: .multiply, alpha: 1)
                image.draw(in: bounds, blendMode: .destinationIn, alpha: 1)

                if self == .CowboyHat {
                    // Preserve the original band in the 264 x 280 artwork coordinates.
                    let band = UIBezierPath()
                    band.move(to: CGPoint(x: 70.7, y: 58.5))
                    band.addQuadCurve(to: CGPoint(x: 193, y: 58.8), controlPoint: CGPoint(x: 132, y: 41.5))
                    band.addLine(to: CGPoint(x: 195.5, y: 68.3))
                    band.addQuadCurve(to: CGPoint(x: 68.5, y: 68.3), controlPoint: CGPoint(x: 132, y: 52.2))
                    band.close()
                    band.apply(CGAffineTransform(scaleX: bounds.width / 264, y: bounds.height / 280))
                    context.cgContext.saveGState()
                    band.addClip()
                    image.draw(in: bounds, blendMode: .normal, alpha: 1)
                    context.cgContext.restoreGState()
                }
            }.withRenderingMode(.alwaysOriginal)
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
        
        case DenimJacket
        case LeatherJacket
        case SportsJersey
        case CroatiaJersey
        case SerbiaJersey
        case ArgentinaJersey
        case PortugalJersey
        case FranceJersey
        case ButtonUpShirt
        case BasketballJersey
        case ElegantDress
        case OffShoulderBlouse

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
            case .DenimJacket:
                return UIImage(named: "DenimJacket", in: .module, compatibleWith: .current)?.withRenderingMode(.alwaysOriginal)
            case .LeatherJacket:
                return UIImage(named: "LeatherJacket", in: .module, compatibleWith: .current)?.withRenderingMode(.alwaysOriginal)
            case .SportsJersey:
                return UIImage(named: "SportsJersey", in: .module, compatibleWith: .current)
            case .CroatiaJersey:
                return UIImage(named: "CroatiaJersey", in: .module, compatibleWith: .current)?.withRenderingMode(.alwaysOriginal)
            case .SerbiaJersey:
                return UIImage(named: "SerbiaJersey", in: .module, compatibleWith: .current)?.withRenderingMode(.alwaysOriginal)
            case .ArgentinaJersey:
                return UIImage(named: "ArgentinaJersey", in: .module, compatibleWith: .current)?.withRenderingMode(.alwaysOriginal)
            case .PortugalJersey:
                return UIImage(named: "PortugalJersey", in: .module, compatibleWith: .current)?.withRenderingMode(.alwaysOriginal)
            case .FranceJersey:
                return UIImage(named: "FranceJersey", in: .module, compatibleWith: .current)?.withRenderingMode(.alwaysOriginal)
            case .ButtonUpShirt:
                return UIImage(named: "ButtonUpShirt", in: .module, compatibleWith: .current)
            case .BasketballJersey:
                return UIImage(named: "BasketballJersey", in: .module, compatibleWith: .current)
            case .ElegantDress:
                return UIImage(named: "ElegantDress", in: .module, compatibleWith: .current)
            case .OffShoulderBlouse:
                return UIImage(named: "OffShoulderBlouse", in: .module, compatibleWith: .current)
            }
        }

        func image(color: UIColor) -> UIImage? {
            guard let original = (self == .SportsJersey || self == .ButtonUpShirt || self == .BasketballJersey || self == .ElegantDress || self == .OffShoulderBlouse) ? image()?.avatarTinted(color) : image() else { return nil }
            guard verticalOffset != 0 else { return original }
            let format = UIGraphicsImageRendererFormat()
            format.scale = original.scale
            let bottomExtension = max(0, -verticalOffset)
            let drawable = bottomExtension > 0
                ? original.resizableImage(withCapInsets: UIEdgeInsets(top: original.size.height - 2, left: 0, bottom: 1, right: 0), resizingMode: .stretch)
                : original
            return UIGraphicsImageRenderer(size: original.size, format: format).image { _ in
                // Extend above the bottom edge when lifting clothing, keeping the chest covered.
                drawable.draw(in: CGRect(x: 0, y: verticalOffset, width: original.size.width, height: original.size.height + bottomExtension))
            }.withRenderingMode(.alwaysOriginal)
        }

        var verticalOffset: CGFloat {
            switch self {
            case .LeatherJacket: return 17.5
            case .SportsJersey: return 28
            case .BasketballJersey: return -4
            case .CroatiaJersey, .PortugalJersey, .FranceJersey, .ArgentinaJersey: return 22
            default: return self == .DenimJacket || self == .ButtonUpShirt || isJersey ? 12 : 0
            }
        }

        var isJersey: Bool {
            switch self {
            case .SportsJersey, .CroatiaJersey, .SerbiaJersey, .ArgentinaJersey, .PortugalJersey, .FranceJersey, .BasketballJersey:
                return true
            default:
                return false
            }
        }

        var defaultJerseyNumber: Int? {
            switch self {
            case .ArgentinaJersey, .FranceJersey: return 10
            case .PortugalJersey: return 7
            default: return nil
            }
        }

        var usesColor: Bool {
            self != .DenimJacket && self != .LeatherJacket && (!isJersey || self == .SportsJersey || self == .BasketballJersey)
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
        case MoustachePencil
        case MoustacheHorseshoe
        case BeardStubble
        // Raw value 11 is retired; start future additions at 12.
        
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
            case .MoustachePencil:
                return UIImage(named: "MoustachePencil", in: .module, compatibleWith: .current)
            case .MoustacheHorseshoe:
                return UIImage(named: "MoustacheHorseshoe", in: .module, compatibleWith: .current)
            case .BeardStubble:
                return UIImage(named: "BeardStubble", in: .module, compatibleWith: .current)
            }
        }
        
    }
    enum Addition: Int, CaseIterable, AvatarSymbol {
        // 4 legacy bits plus one extension bit in the hex ID.
        case None
        case Blazer
        case Freckles
        case Hairband
        case Old
        case Makeup
        case AddHearts
        case Crown
        case Bandana
        case Headphones
        case GoldChain
        case GoldEarring
        case DiamondEarrings
        case KungFuHeadband
        
        case BowTie
        case Tie
        case Scarf
        case CheekBandage
        case EyebrowScar
        case EyebrowPiercing
        case DiceChain
        case GoldMedal

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
            case .Crown:
                return UIImage(named: "Crown", in: .module, compatibleWith: .current)
            case .Bandana:
                return UIImage(named: "Bandana", in: .module, compatibleWith: .current)
            case .Headphones:
                return UIImage(named: "Headphones", in: .module, compatibleWith: .current)
            case .GoldChain:
                return UIImage(named: "GoldChain", in: .module, compatibleWith: .current)
            case .GoldEarring:
                return UIImage(named: "GoldEarring", in: .module, compatibleWith: .current)
            case .DiamondEarrings:
                return UIImage(named: "DiamondEarrings", in: .module, compatibleWith: .current)
            case .KungFuHeadband:
                return UIImage(named: "KungFuHeadband", in: .module, compatibleWith: .current)
            case .BowTie:
                return UIImage(named: "BowTie", in: .module, compatibleWith: .current)
            case .Tie:
                return UIImage(named: "Tie", in: .module, compatibleWith: .current)
            case .Scarf:
                return UIImage(named: "Scarf", in: .module, compatibleWith: .current)
            case .CheekBandage:
                return UIImage(named: "CheekBandage", in: .module, compatibleWith: .current)
            case .EyebrowScar:
                return UIImage(named: "EyebrowScar", in: .module, compatibleWith: .current)
            case .EyebrowPiercing:
                return UIImage(named: "EyebrowPiercing", in: .module, compatibleWith: .current)
            case .DiceChain:
                return UIImage(named: "DiceChain", in: .module, compatibleWith: .current)
            case .GoldMedal:
                return UIImage(named: "GoldMedal", in: .module, compatibleWith: .current)
            }
        }

        var usesColor: Bool { self == .BowTie || self == .Tie || self == .Scarf }

        func avatarImage(color: UIColor? = nil) -> UIImage? {
            let frames: [CGRect]
            switch self {
            case .Bandana:
                frames = [CGRect(x: 0, y: 6.2, width: 264, height: 280)]
            case .Headphones:
                frames = [CGRect(x: 26.4, y: 8, width: 211.2, height: 146)]
            case .GoldChain:
                frames = [CGRect(x: 90, y: 199, width: 84, height: 52)]
            case .GoldEarring:
                frames = [CGRect(x: 63, y: 126, width: 14, height: 22)]
            case .DiamondEarrings:
                frames = [
                    CGRect(x: 67, y: 125, width: 8, height: 8),
                    CGRect(x: 189, y: 125, width: 8, height: 8)
                ]
            case .KungFuHeadband:
                frames = [CGRect(x: 75, y: 61, width: 142, height: 32)]
            case .BowTie:
                frames = [CGRect(x: 96.9, y: 185.25, width: 70.2, height: 32.5)]
            case .Tie:
                frames = [CGRect(x: 116.4, y: 224, width: 31.2, height: 87.6)]
            case .Scarf:
                frames = [CGRect(x: 79.635, y: 181.4, width: 107.73, height: 119.7)]
            case .CheekBandage:
                frames = [CGRect(x: 81.5, y: 128.5, width: 36, height: 17)]
            case .EyebrowScar:
                frames = [CGRect(x: 98, y: 74, width: 16, height: 28)]
            case .EyebrowPiercing:
                frames = [CGRect(x: 103, y: 74.25, width: 12, height: 22.5)]
            case .DiceChain:
                frames = [CGRect(x: 94, y: 201, width: 76, height: 72)]
            case .GoldMedal:
                frames = [CGRect(x: 100, y: 190, width: 64, height: 81)]
            default:
                return image()
            }

            // Place accessories in the avatar's 264 x 280 artwork coordinates.
            guard let original = image() else { return nil }
            let image = usesColor ? color.map { original.avatarTinted($0) } ?? original : original
            let format = UIGraphicsImageRendererFormat()
            format.scale = image.scale
            return UIGraphicsImageRenderer(size: CGSize(width: 264, height: 280), format: format).image { _ in
                for frame in frames {
                    image.draw(in: frame)
                }
            }.withRenderingMode(.alwaysOriginal)
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
                imageName = UIAvatarView.enableBots ? "Bot" : "Body"
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
        case Coffee
        case Dice
        case Trophy
        case MiddleFinger
        
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
            case .Coffee:
                return UIImage(named: "CoffeeLogo", in: .module, compatibleWith: .current)
            case .Dice:
                return UIImage(named: "DiceLogo", in: .module, compatibleWith: .current)
            case .Trophy:
                return UIImage(named: "TrophyLogo", in: .module, compatibleWith: .current)
            case .MiddleFinger:
                return UIImage(named: "MiddleFingerLogo", in: .module, compatibleWith: .current)
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
            case .Addition:
                return Part.Clothing.colors()
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
        let fields: [Part: AvatarHexID.Field] = [.Eyes: .eyes, .Mouth: .mouth, .Eyebrow: .eyebrow,
            .Glasses: .glasses, .Hair: .hair, .Clothing: .clothing, .FacialHair: .facialHair,
            .Addition: .addition, .Skin: .skin, .Nose: .nose, .ClothLogo: .logo]
        if let field = fields[part] { loadedHexID?[field] = symbol.rawValue }
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
            let selected = Clothing(rawValue: symbol.rawValue)!
            if selected != clothing, let number = selected.defaultJerseyNumber {
                jerseyNumber = number + 1
            }
            clothing = selected
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
        let fields: [Part: AvatarHexID.Field] = [.Skin: .skinColor, .Hair: .hairColor,
            .Clothing: .clothingColor, .FacialHair: .facialHairColor]
        if let field = fields[part] { loadedHexID?[field] = colorIdx }
        switch part {
        case .Skin:
            skinColorIdx = colorIdx
        case .Hair:
            hairColorIdx = colorIdx
        case .FacialHair:
            facialHairColorIdx = colorIdx
        case .Addition:
            additionColorIdx = colorIdx
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
            result |= Int64(v) & ((1 << ctBits) - 1)
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
    
    public class func decompress(value: Int64, hexId: String = "") -> Avatar {
        if let hex = AvatarHexID(hexId) { return decompress(hex: hex) }
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
    
    private var fieldValues: [Int] {
        [skin.rawValue, skinColorIdx, eyes.rawValue, mouth.rawValue, eyebrow.rawValue, glasses.rawValue, hair.rawValue, hairColorIdx, clothing.rawValue, clothingColorIdx, facialHair.rawValue, facialHairColorIdx, addition.rawValue, nose.rawValue, clothLogo.rawValue]
    }

    public func compressHex() -> String {
        var result = loadedHexID ?? AvatarHexID(legacyID: 0)
        for (index, field) in AvatarHexID.Field.allCases.enumerated() {
            if loadedHexID == nil || fieldValues[index] != loadedValues[index] {
                result[field] = fieldValues[index]
            }
        }
        if loadedHexID == nil {
            result.bodyType = bodyType.rawValue
            result.additionColor = additionColorIdx
            result.jerseyNumber = jerseyNumber
        }
        return result.hex
    }

    public var legacyAvatarId: Int64 { AvatarHexID(compressHex())!.legacyID }

    func shirtMarkImage() -> UIImage? {
        guard clothing.isJersey, (1...100).contains(jerseyNumber) else { return clothLogo.image() }
        let text = String(jerseyNumber - 1) as NSString
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 32, weight: .heavy),
            .foregroundColor: UIColor.white, .strokeColor: UIColor(white: 0.12, alpha: 1), .strokeWidth: -3
        ]
        let size = text.size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: CGSize(width: 110, height: 44)).image { _ in
            text.draw(at: CGPoint(x: (110 - size.width) / 2, y: (44 - size.height) / 2), withAttributes: attributes)
        }.withRenderingMode(.alwaysOriginal)
    }

    private class func decompress(hex: AvatarHexID) -> Avatar {
        let avatar = decompress(value: hex.legacyID)
        avatar.skin = Skin(rawValue: hex[.skin]) ?? .Normal
        avatar.skinColorIdx = Part.Skin.colors().indices.contains(hex[.skinColor]) ? hex[.skinColor] : 0
        avatar.eyes = Eyes(rawValue: hex[.eyes]) ?? .Closed
        avatar.mouth = Mouth(rawValue: hex[.mouth]) ?? .Default
        avatar.eyebrow = Eyebrow(rawValue: hex[.eyebrow]) ?? .Default
        avatar.glasses = Glasses(rawValue: hex[.glasses]) ?? .None
        avatar.hair = Hair(rawValue: hex[.hair]) ?? .None
        avatar.hairColorIdx = Part.Hair.colors().indices.contains(hex[.hairColor]) ? hex[.hairColor] : 0
        avatar.clothing = Clothing(rawValue: hex[.clothing]) ?? .Shirt
        avatar.clothingColorIdx = Part.Clothing.colors().indices.contains(hex[.clothingColor]) ? hex[.clothingColor] : 0
        avatar.facialHair = FacialHair(rawValue: hex[.facialHair]) ?? .None
        avatar.facialHairColorIdx = Part.FacialHair.colors().indices.contains(hex[.facialHairColor]) ? hex[.facialHairColor] : 0
        avatar.addition = Addition(rawValue: hex[.addition]) ?? .None
        avatar.nose = Nose(rawValue: hex[.nose]) ?? .Normal
        avatar.clothLogo = ClothLogo(rawValue: hex[.logo]) ?? .None
        avatar.bodyType = BodyType(rawValue: hex.bodyType) ?? .normal
        avatar.additionColorIdx = Part.Addition.colors().indices.contains(hex.additionColor) ? hex.additionColor : 0
        avatar.jerseyNumber = (0...100).contains(hex.jerseyNumber) ? hex.jerseyNumber : 0
        // Keep unknown future values and reserved bits when editing another part.
        avatar.loadedValues = avatar.fieldValues
        avatar.loadedHexID = hex
        return avatar
    }

    func symbolIndex(for part: Part) -> Int? {
        switch part {
        case .Eyes:
            return Eyes.allCases.firstIndex(where: { $0.rawValue == eyes.rawValue })
        case .Mouth:
            return Mouth.allCases.firstIndex(where: { $0.rawValue == mouth.rawValue })
        case .Eyebrow:
            return Eyebrow.allCases.firstIndex(where: { $0.rawValue == eyebrow.rawValue })
        case .Glasses:
            return Glasses.allCases.firstIndex(where: { $0.rawValue == glasses.rawValue })
        case .Hair:
            return Hair.allCases.firstIndex(where: { $0.rawValue == hair.rawValue })
        case .Clothing:
            return Clothing.allCases.firstIndex(where: { $0.rawValue == clothing.rawValue })
        case .FacialHair:
            return FacialHair.allCases.firstIndex(where: { $0.rawValue == facialHair.rawValue })
        case .Addition:
            return Addition.allCases.firstIndex(where: { $0.rawValue == addition.rawValue })
        case .Skin:
            return Skin.allCases.firstIndex(where: { $0.rawValue == skin.rawValue })
        case .Nose:
            return Nose.allCases.firstIndex(where: { $0.rawValue == nose.rawValue })
        case .ClothLogo:
            return ClothLogo.allCases.firstIndex(where: { $0.rawValue == clothLogo.rawValue })
        }
    }

    func colorIndex(for part: Part) -> Int? {
        switch part {
        case .Skin:
            return skinColorIdx
        case .Hair:
            return hairColorIdx
        case .FacialHair:
            return facialHairColorIdx
        case .Addition:
            return additionColorIdx
        case .Clothing:
            return clothingColorIdx
        default:
            return nil
        }
    }
    
    public func makeAngry() {
        set(part: .Mouth, symbol: Mouth.Grimace)
        set(part: .Eyes, symbol: Eyes.Surprised)
        set(part: .Eyebrow, symbol: Eyebrow.Angry)
    }
    
}


protocol AvatarSymbol: Any {
    func image() -> UIImage?
    var rawValue: Int { get }
}

private extension UIImage {
    func avatarTinted(_ color: UIColor) -> UIImage {
        let bounds = CGRect(origin: .zero, size: size)
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            color.setFill()
            context.fill(bounds)
            draw(in: bounds, blendMode: .multiply, alpha: 1)
            draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        }.withRenderingMode(.alwaysOriginal)
    }
}
