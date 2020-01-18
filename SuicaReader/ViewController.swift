//
//  ViewController.swift
//  SuicaReader
//
//  Created by haseken-dev on 2020/01/13.
//  Copyright © 2020 haseken-dev. All rights reserved.
//

import UIKit
import LocalAuthentication

import NFCReader

class ViewController: UIViewController {
    @IBOutlet private weak var moneyLabel: UILabel!
    
    private let suicaReader = Reader<Suica>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticate()
    }
}

private extension ViewController {
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        let description: String = "認証"
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            let errorDescription = error?.description ?? "Face ID / Touch IDが利用できません"
            let alertController = UIAlertController(title: "", message: errorDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alertController, animated: true)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { [unowned self] (success, error) in
            guard error == nil else {
                return
            }
            
            let alertController = UIAlertController(title: "",
            message: success ? "認証に成功しました" : "認証に失敗しました",
            preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "閉じる", style: .cancel))
            DispatchQueue.main.sync {
                self.present(alertController, animated: true)
            }
        }
    }
    
    func read() {
        suicaReader.read(didDetect: { [unowned self]  reader, result in
            switch result {
            case .success(let suica):
                let balance = suica.cardInformation.balance
                self.moneyLabel.text = "￥\(balance)"
                reader.setMessage("読み取りに成功しました！")
            case .failure(let error):
                reader.invalidate(errorMessage: error.localizedDescription)
            }
        })
    }
    
    @IBAction private func didTapSuicaReaderButton(_ sender: UIButton) {
        read()
    }
}

