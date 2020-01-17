//
//  ViewController.swift
//  SuicaReader
//
//  Created by haseken-dev on 2020/01/13.
//  Copyright © 2020 haseken-dev. All rights reserved.
//

import UIKit
import NFCReader

class ViewController: UIViewController {
    @IBOutlet private weak var moneyLabel: UILabel!
    
    private let suicaReader = Reader<Suica>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
    @IBAction private func didTapSuicaReaderButton(_ sender: UIButton) {
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
}

