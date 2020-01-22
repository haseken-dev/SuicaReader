//
//  LocalAuthenticationUtility.swift
//  SuicaReaderFramework
//
//  Created by haseken-dev on 2020/01/22.
//  Copyright © 2020 haseken-dev. All rights reserved.
//

import Foundation
import LocalAuthentication

public struct LocalAuthenticationUtility {
    private static let context = LAContext()
    
    public static func canEvaluatePolicy() -> NSError? {
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return error
        }
        return nil
    }

    public static func authenticate(localizedReason description: String = "認証",
                                    complication: @escaping ((Bool) -> ()),
                                    fail: @escaping ((Error?) -> ())) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { (success, error) in
            guard error == nil else {
                fail(error)
                return
            }
            
            complication(success)
        }
    }
}
