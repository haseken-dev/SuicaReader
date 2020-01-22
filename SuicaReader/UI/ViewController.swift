//
//  ViewController.swift
//  SuicaReader
//
//  Created by haseken-dev on 2020/01/13.
//  Copyright © 2020 haseken-dev. All rights reserved.
//

import UIKit
import LocalAuthentication

import SuicaReaderFramework

import NFCReader

final class ViewController: UIViewController {
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var historyButton: UIButton!
    
    private let suicaReader = Reader<Suica>()
    private var histories: [Suica.BoardingHistory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticate()
    }
}

private extension ViewController {
    func authenticate() {
        let description: String = "認証"
        LocalAuthenticationUtility.authenticate(localizedReason: description, complication: { (result, error) in
            switch result {
            case .success(true), .failure(.failAuthenticate), .success(false): break
            case .failure(.cannotEvaluatePolicy):
                if error != nil {
                    let errorDescription = error?.localizedDescription ?? "Face ID / Touch IDが利用できません"
                    let alertController = UIAlertController(title: "", message: errorDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertController, animated: true)
                }
            }
        })
    }
    
    func read() {
        suicaReader.read(didDetect: { [unowned self]  reader, result in
            switch result {
            case .success(let suica):
                let balance = suica.cardInformation.balance
                self.moneyLabel.text = "￥\(balance)"
                reader.setMessage("読み取りに成功しました！")
                self.histories = suica.boardingHistories
            case .failure(let error):
                reader.invalidate(errorMessage: error.localizedDescription)
            }
        })
    }
    
    func convertToHistory(from boardingHistory: Suica.BoardingHistory) -> History {
        let kind: History.Kind
        
        switch boardingHistory.kind {
        case .jr:   kind = .jr
        case .bus:  kind = .bus
        case .publicOrPrivate: kind = .publicOrPrivate
        case .shopping: kind = .shopping
        }
        
        return History(year: boardingHistory.year, month: boardingHistory.month, day: boardingHistory.day, kind: kind)
    }
    
    @IBAction func didTapSuicaReaderButton(_ sender: UIButton) {
        read()
    }
    
    @IBAction func didTapShowHistoryButton(_ sender: UIButton) {
        guard let histories = histories else {
            let alertController = UIAlertController(title: "エラー", message: "ICカードを読み込んだ後、表示が可能です。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "読み取りを開始する", style: .default, handler: { [unowned self] _ in
                self.read()
            }))
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
            self.present(alertController, animated: true)
            return
        }
        
        guard histories.count > 0 else {
            let alertController = UIAlertController(title: "エラー", message: "履歴が1件もありません。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alertController, animated: true)
            return
        }
        
        let viewController = IcCardHistoryViewController.instantiateFromStoryboard(withIdentifier: "IcCardHistoryViewController")
        let icCardHistories: [History] = histories.map { [unowned self] in
            return self.convertToHistory(from: $0)
        }
        
        viewController.histories = icCardHistories
        let naviController = UINavigationController(rootViewController: viewController)
        self.present(naviController, animated: true)
    }
}
