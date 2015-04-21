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
    case Music
    case Gathered
    case FourSquares
    case OpenSource
    case Accessibility

    static var allAppSections: [AppSection] = [
        .About,
        .Music,
        .Gathered,
        .FourSquares,
        .OpenSource,
        .Accessibility
    ]

    var name: String {
        get {
            switch self {
            case .About:
                return "About"
            case .Music:
                return "Music"
            case .Gathered:
                return "Gathered"
            case .FourSquares:
                return "Four Squares"
            case .OpenSource:
                return "Open Source"
            case .Accessibility:
                return "Accessibility"
            }
        }
    }

    var mainColor: UIColor {
        switch self {
        case .About:
            return UIColor(red:0.922, green:0.486, blue:0.000, alpha: 1)
        case .Music:
            return UIColor(red:0.329, green:0.898, blue:0.835, alpha: 1)
        case .Gathered:
            return UIColor(red:0.075, green:0.384, blue:0.694, alpha: 1)
        case .FourSquares:
            return UIColor(red:0.922, green:0.408, blue:0.408, alpha: 1)
        case .OpenSource:
            return UIColor(red:0.592, green:0.043, blue:0.788, alpha: 1)
        case .Accessibility:
            return .whiteColor()
        }
    }

    var segueIdentifier: String {
        get {
            switch self {
            case .About:
                return "About"
            case .Music:
                return "Music"
            case .Gathered:
                return "Gathered"
            case .FourSquares:
                return "Four Squares"
            case .OpenSource:
                return "Open Source"
            case .Accessibility:
                return "Accessibility"
            }
        }
    }
}