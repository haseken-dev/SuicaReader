//
//  IcCardHistoryViewController.swift
//  SuicaReader
//
//  Created by haseken-dev on 2020/01/20.
//  Copyright © 2020 haseken-dev. All rights reserved.
//

import UIKit
import Foundation

import NFCReader

struct History {
    let year: UInt8
    let month: UInt8
    let day: UInt8
    let kind: Kind
    
    enum Kind {
        /// JR
        case jr
        /// 公営・私鉄
        case publicOrPrivate
        /// バス
        case bus
        /// 物販
        case shopping
        
        var description: String {
            switch self {
            case .jr:               return "JR"
            case .publicOrPrivate:  return "公営・私鉄"
            case .bus:              return "バス"
            case .shopping:         return "物販"
            }
        }
    }
}

final class IcCardHistoryViewController: UIViewController, Instantiatable {
    @IBOutlet private weak var historyTableView: UITableView! {
        didSet {
            if histories != nil {
                historyTableView.reloadData()
            }
        }
    }
    
    var histories: [History]? {
        didSet {
            if let historyTableView = historyTableView {
                historyTableView.reloadData()
            }
        }
    }
}

extension IcCardHistoryViewController: UITableViewDelegate {
    
}

extension IcCardHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell")!
        if let history = histories?[indexPath.row] {
            cell.textLabel?.text = history.kind.description
            cell.detailTextLabel?.text = "\(history.year.description)/\(history.month.description)/\(history.day.description)"
        }
        
        return cell
    }
}
