//
//  AppSection.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 16/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

enum AppSection: Int {
    case About
    case Work
    case Gathered
    case FourSquares
    case Hobbies
    case Accessiblity

    static var allAppSections: [AppSection] = [
        .About,
        .Work,
        .Gathered,
        .FourSquares,
        .Hobbies,
        .Accessiblity
    ]

    var name: String {
        get {
            switch self {
            case .About:
                return "About Me"
            case .Work:
                return "Work and Education"
            case .Gathered:
                return "Gathered"
            case .FourSquares:
                return "Four Squares"
            case .Hobbies:
                return "Hobbies"
            case .Accessiblity:
                return "Accessiblity"
            }
        }
    }

    var mainColor: UIColor {
        switch self {
        case .About:
            return UIColor(red:0.922, green:0.486, blue:0.000, alpha: 1)
        case .Work:
            return UIColor(red:0.329, green:0.898, blue:0.835, alpha: 1)
        case .Gathered:
            return UIColor(red:251/255, green:78/255, blue:67/255, alpha: 1)
        case .FourSquares:
            return UIColor(red:0.922, green:0.408, blue:0.408, alpha: 1)
        case .Hobbies:
            return .whiteColor()
        case .Accessiblity:
            return .grayColor()
        }
    }

    var textColor: UIColor? {
        switch self {
        case .Accessiblity:
            return .whiteColor()
        default:
            return nil
        }
    }

    var barTintColor: UIColor? {
        switch self {
        case .Accessiblity:
            return .darkGrayColor()
        default:
            return nil
        }
    }

    var tintColor: UIColor? {
        switch self {
        case .Accessiblity:
            return UIColor(red: 0.42, green: 0.714, blue: 1, alpha: 1)
        default:
            return nil
        }
    }

    var homeIcon: (image: UIImage?, applyAppIconCurve: Bool) {
        get {
            var homeIcon: (image: UIImage?, applyAppIconCurve: Bool) = (nil, false)
            switch self {
            case .About:
                homeIcon.image = UIImage(named: "Photo of Me.jpg")
            case .Work:
                homeIcon.image = UIImage(named: "Work and Education Home Image")
            case .Gathered:
                homeIcon.image = UIImage(named: "Gathered Home Image")
                homeIcon.applyAppIconCurve = true
            case .FourSquares:
                homeIcon.image = UIImage(named: "Four Squares Home Image")
            case .Hobbies:
                homeIcon.image = UIImage(named: "Beethoven Symphony No.9 Cover.jpg")
            case .Accessiblity:
                homeIcon.image = UIImage(named: "Accessibility Home Icon")
            default:
                break
            }

            return homeIcon
        }
    }

    var roorViewControllerStoryboardId: String {
        get {
            switch self {
            case .About:
                return "AboutMeRootViewController"
            case .Work:
                return "WorkRootViewController"
            case .Gathered:
                return "GatheredRootViewController"
            case .FourSquares:
                return "FourSquaresRootViewController"
            case .Hobbies:
                return "HobbiesRootViewController"
            case .Accessiblity:
                return "AccessiblityRootViewController"
            }
        }
    }
}