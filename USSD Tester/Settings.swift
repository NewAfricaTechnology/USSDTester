//
//  Settings.swift
//  USSD Tester
//
//  Created by Djibril Bathily Coly on 06/08/2023.
//

import UIKit

class Settings: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var sessionIdField: UITextField!
    @IBOutlet weak var networkCodeField: UITextField!
    @IBOutlet weak var serviceCodeField: UITextField!
    @IBOutlet weak var simulateConEndSwitch: UISwitch!
    @IBOutlet weak var displayConEndSwitch: UISwitch!
    
    
    @IBAction func apply(_ sender: Any) {
        
        if let url = URL(string: urlField.text!) {
            userDefaults.set(url, forKey: "url")
        } else {
            Notifiers.fireNotification(title: "URL invalide", body: "Saisissez une URL valide avec un schéma", style: .warning)
        }
        
        userDefaults.set(phoneNumberField.text!, forKey: "phoneNumber")
        userDefaults.set(sessionIdField.text!, forKey: "sessionId")
        userDefaults.set(networkCodeField.text!, forKey: "networkCode")
        userDefaults.set(serviceCodeField.text!, forKey: "serviceCode")
        userDefaults.set(simulateConEndSwitch.isOn, forKey: "simulateConEnd")
        userDefaults.set(displayConEndSwitch.isOn, forKey: "displayConEnd")
        
        self.dismiss(animated: true) {
            Notifiers.fireNotification(title: "Paramètres appliqués", body: "Vos préférences ont été sauvegardées.", style: .success)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "restart"), object: nil)

    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        urlField.delegate = self
        phoneNumberField.delegate = self
        sessionIdField.delegate = self
        networkCodeField.delegate = self
        serviceCodeField.delegate = self
        
        phoneNumberField.addDoneButtonToKeyboard(buttonAction: #selector(self.phoneNumberField.resignFirstResponder))
        serviceCodeField.addDoneButtonToKeyboard(buttonAction: #selector(self.serviceCodeField.resignFirstResponder))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        
        if let url = userDefaults.url(forKey: "url") {
            urlField.text = url.absoluteString
        }
        
        if let phoneNumber = userDefaults.string(forKey: "phoneNumber") {
            phoneNumberField.text = phoneNumber
        }
        
        if let sessionId = userDefaults.string(forKey: "sessionId") {
            sessionIdField.text = sessionId
        }
        
        if let networkCode = userDefaults.string(forKey: "networkCode") {
            networkCodeField.text = networkCode
        }
        
        if let serviceCode = userDefaults.string(forKey: "serviceCode") {
            serviceCodeField.text = serviceCode
        }
        
        if let simulateConEnd = userDefaults.value(forKey: "simulateConEnd") as? Bool {
            simulateConEndSwitch.setOn(simulateConEnd, animated: true)
        } else {
            simulateConEndSwitch.setOn(false, animated: true)
        }
        
        if let displayConEnd = userDefaults.value(forKey: "displayConEnd") as? Bool {
            displayConEndSwitch.setOn(displayConEnd, animated: true)
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
