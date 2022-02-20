//
//  KeyChainService.swift
//  Vote
//
//  Created by 권은빈 on 2022/02/20.
//

import UIKit
import Security

class KeyChainService {
    
    class func createKeyChain(_ service: String, _ account: String, _ value: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: value.data(using: String.Encoding.utf8)!
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        assert(status == noErr, "Failed to Save Value")
    }
    
    class func readKeyChain(_ service: String, _ account: String) -> String? {
        
        // 중복되는 경우 하나만 가져오기
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        }
        else {
            return nil
        }
    }
}
