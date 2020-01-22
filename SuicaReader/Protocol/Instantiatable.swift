//
//  Instantiatable.swift
//  SuicaReader
//
//  Created by haseken-dev on 2020/01/20.
//  Copyright © 2020 haseken-dev. All rights reserved.
//

import Foundation
import UIKit

/// reference: https://fromatom.hatenablog.com/entry/2018/11/08/171915
protocol Instantiatable {
    static var storyboardName: String { get }
}

extension Instantiatable where Self: UIViewController {
    static var storyboardName: String {
        return ""
    }

    static func instantiateFromStoryboard() -> Self {
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Can no instantiate \(Self.className) from \(storyboardName).storyboard")
        }
        return vc
    }

    static func instantiateFromStoryboard(withIdentifier id: String) -> Self {
        guard let vc = storyboard.instantiateViewController(withIdentifier: id) as? Self else {
            fatalError("Can no instantiate \(Self.className) from \(storyboardName).storyboard with id: \(id)")
        }
        return vc
    }
}

private extension Instantiatable {
    static var _storyboardName: String {
        if storyboardName.isEmpty {
            return className
        } else {
            return storyboardName
        }
    }

    static var storyboard: UIStoryboard {
        return UIStoryboard.init(name: _storyboardName, bundle: nil)
    }

    static var className: String {
        return String(describing: Self.self)
    }
}
