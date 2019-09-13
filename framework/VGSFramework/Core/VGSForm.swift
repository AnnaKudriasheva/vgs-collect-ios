//
//  VGSForm.swift
//  VGSFramework
//
//  Created by Vitalii Obertynskyi on 8/26/19.
//  Copyright © 2019 Vitalii Obertynskyi. All rights reserved.
//

import Foundation

/// The VGSForm class needed for collect all text filelds
public class VGSForm {
    private let apiClient: APIClient
    private let storage = Storage()
    
    /// Observing text fields separately
    public var observeTextField: ((_ textField: VGSTextField) -> Void)?
    
    /// Observing text fileds for all form
    public var observeForm: ((_ form:[VGSTextField]) -> Void)?
    
    /// set custom headers
    public var customHeaders: [String: String]? {
        didSet {
            if customHeaders != oldValue {
                apiClient.customHeader = customHeaders
            }
        }
    }
    
    // MARK: - Initialzation
    public init(tnt id: String, environment: Environment = .sandbox) {
        let strUrl = "https://" + id + "." + environment.rawValue + ".verygoodproxy.com"
        guard let url = URL(string: strUrl) else {
            fatalError("Upstream Host is broken. Can't to converting to URL!")
        }
        apiClient = APIClient(baseURL: url)
    }
    
    func registerTextFields(textField objects: [VGSTextField]) {
        objects.forEach { [weak self] tf in
            self?.storage.addElement(tf)
        }
    }
    
    func unregisterTextFields(textField objects: [VGSTextField]) {
        objects.forEach { [weak self] tf in
            self?.storage.removeElement(tf)
        }
    }
}

extension VGSForm {
    func updateStatus(for textField: VGSTextField) {
        // reset all focus status
        storage.elements.forEach { textField in
            textField.focusStatus = false
        }
        // set focus for textField
        textField.focusStatus = true
        // call observers
        observeForm?(storage.elements)
        observeTextField?(textField)
    }
}

// MARK: - sending data
extension VGSForm {
    public func sendData(data: [String: Any]? = nil, completion block:@escaping (_ data: JsonData?, _ error: Error?) -> Void) {
        
        var body = BodyData()
        
        let elements = storage.elements
        
        let allKeys = elements.compactMap( { $0.configuration?.alias } )
        allKeys.forEach { key in
            if let value = elements.filter( { $0.configuration?.alias == key } ).first {
                body[key] = value.text
            } else {
                fatalError("Wrong key: \(key)")
            }
        }
        
        if data?.count != 0 {
            body["data"] = data?.description
        }
        
        apiClient.sendRequest(value: body) { (json, error) in
            
            if let error = error {
                print("Error: \(String(describing: error.localizedDescription))")
                block(json, error)
                
            } else {
                let allKeys = json?.keys
                allKeys?.forEach({ key in
                    
                    if let element = elements.filter( { $0.configuration?.alias == key } ).first {
                        element.configuration?.token = json?[key] as? String
                    }
                })
            }
            block(json, nil)
        }
    }
}
