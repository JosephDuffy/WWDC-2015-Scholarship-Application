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
    case Accessibility

    static var allAppSections: [AppSection] = [
        .About,
        .Work,
        .Gathered,
        .FourSquares,
        .Hobbies,
        .Accessibility
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
            case .Accessibility:
                return "Accessibility"
            }
        }
    }

    var mainColor: UIColor {
        switch self {
        case .About:
            return UIColor(red: 237/255, green: 200/255, blue: 59/255, alpha: 1)
        case .Work:
            return UIColor(red: 45/255, green: 159/255, blue: 168/255, alpha: 1)
//            return UIColor(red: 72/255, green: 145/255, blue: 90/255, alpha: 1)
        case .Gathered:
            return UIColor(red: 178/255, green: 0/255, blue: 11/255, alpha: 1)
        case .FourSquares:
            return UIColor(red: 72/255, green: 145/255, blue: 90/255, alpha: 1)
//            return UIColor(red: 45/255, green: 159/255, blue: 168/255, alpha: 1)
        case .Hobbies:
            return UIColor(red: 68/255, green: 45/255, blue: 54/255, alpha: 1)
        case .Accessibility:
            return .darkGrayColor()
        }
    }

    var textColor: UIColor? {
        switch self {
        case .About:
            return UIColor(red: 41/255, green: 41/255, blue: 40/255, alpha: 1)
        case .Hobbies, .Gathered:
            return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        case .Work, .FourSquares, .Accessibility:
            return .whiteColor()
        default:
            return nil
        }
    }

    var navigationBarTextColor: UIColor? {
        switch self {
        case .About, .Hobbies, .Work, .Accessibility:
            return self.textColor
        default:
            return nil
        }
    }

    var barTintColor: UIColor? {
        switch self {
        case .About:
            return UIColor(red: 238/255, green: 205/255, blue: 78/255, alpha: 1)
        case .Work:
//            return UIColor(red: 90/255, green: 156/255, blue: 106/255, alpha: 1)
            return UIColor(red: 66/255, green: 168/255, blue: 176/255, alpha: 1)
//        case .FourSquares:
//            return UIColor(red: 90/255, green: 156/255, blue: 106/255, alpha: 1)
//            return UIColor(red: 66/255, green: 168/255, blue: 176/255, alpha: 1)
        case .Hobbies:
            return UIColor(red: 86/255, green: 66/255, blue: 83/255, alpha: 1)
        case .Accessibility:
            return .grayColor()
        default:
            return nil
        }
    }

    var tintColor: UIColor? {
        switch self {
        case .Accessibility:
            return UIColor(red: 0.42, green: 0.714, blue: 1, alpha: 1)
//        case .FourSquares:
//            return UIColor(red: 178/255, green: 0, blue: 11/255, alpha: 1)
//            return UIColor.blackColor()
        default:
            return nil
        }
    }

    typealias ImageViewCurveFunction = (UIImageView) -> Void
    typealias HomeIcon = (image: UIImage?, imageViewCurveFunction: ImageViewCurveFunction?)

    var homeIcon: HomeIcon {
        get {
            var homeIcon: HomeIcon = (nil, nil)
            switch self {
            case .About:
                homeIcon.image = UIImage(named: "Photo of Me.jpg")
                homeIcon.imageViewCurveFunction = { (imageView) -> Void in
                    imageView.setNeedsLayout()
                    imageView.layoutIfNeeded()
                    imageView.layer.cornerRadius = imageView.frame.size.width / 2
                    imageView.clipsToBounds = true
                }
            case .Work:
                homeIcon.image = UIImage(named: "Work and Education Home Image")
            case .Gathered:
                homeIcon.image = UIImage(named: "Gathered Home Image")
            case .FourSquares:
                homeIcon.image = UIImage(named: "Four Squares Home Image")
            case .Hobbies:
                homeIcon.image = UIImage(named: "Beethoven Symphony No.9 Cover.jpg")
            case .Accessibility:
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
            case .Accessibility:
                return "AccessibilityRootViewController"
            }
        }
    }
}