//
//  ViewController.swift
//  USSD Tester
//
//  Created by Djibril Bathily Coly on 05/08/2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    
    @IBAction func cancel(_ sender: Any) {
        restart()
    }
    
    @IBAction func openSettings(_ sender: Any) {
        goToSettings()
    }
    
    @IBAction func reply(_ sender: Any) {
        if let input = textField.text {
            if text.isEmpty {
                text = input
            } else {
                text += "*\(input)"
            }
            sendCall()
            textField.text = ""
        }
    }
        
    var text = "";
    var url : URL = URL(string: "https://twilight-viena-3znebkcm7hpn.vapor-farm-e1.com/ussd/start")!;
    let session = Session()
    let userDefaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.text = ""

        NotificationCenter.default.addObserver(self, selector: #selector(self.restart), name:NSNotification.Name(rawValue: "restart"), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendCall()
        textField.delegate = self
    }

    func sendCall() {
            
        loadingView.isHidden = false
        
        // Add shared params to request
        var params : [String:String] = [:]

        guard let sessionId = self.userDefaults.string(forKey: "sessionId") else {
            self.resetSessionId()
            self.sendCall()
            return
        }
        
        if let phoneNumber = userDefaults.string(forKey: "phoneNumber") {
            params["networkCode"] = userDefaults.string(forKey: "networkCode") ?? "NO_CARRIER"
            params["phoneNumber"] = phoneNumber
            params["serviceCode"] = userDefaults.string(forKey: "serviceCode") ?? "NO_SERVICE_CODE"
            params["sessionId"] = sessionId
            params["text"] = text
        } else {
            loadingView.isHidden = true
            Notifiers.fireNotification(title: "Paramètre requis", body: "Le paramètre phoneNumber est requis.", style: .warning)
            self.goToSettings()
            return
        }
        
        
               
        let headers : HTTPHeaders = [.accept("*/*")]
        let url : URL =  URL(string: self.userDefaults.string(forKey: "url") ?? "https://twilight-viena-3znebkcm7hpn.vapor-farm-e1.com/ussd/start")!;

        
        // Start the request
        session.request(url, method: .post, parameters: params, headers: headers).responseData { [self] response in
            
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
            }
            
            switch response.result {
            
                
            case .success(_):
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    
                    DispatchQueue.main.async {
                        self.textView.text = !self.userDefaults.bool(forKey: "displayConEnd") ? String(utf8Text.dropFirst(4)) : utf8Text
                    }
                    
                    if self.userDefaults.bool(forKey: "simulateConEnd") && utf8Text.prefix(3) == "END" {
                        self.resetSessionId()
                        self.text = ""
                        Notifiers.fireNotification(title: "Fin de session", body: "Une nouvelle session sera démarrée", style: .info)
                    }
                    
                    
                }
                break
            case .failure(let error):
                Notifiers.fireNotification(title: "Erreur de communication", body: error.localizedDescription, style: .danger)
                break
            }
            
        }
    }
    
    @objc func restart() {
        resetSessionId()
        text = ""
        textView.text = ""
        sendCall()
    }
    
    func resetSessionId() {
        userDefaults.set(Int.random(in: 0...999999), forKey: "sessionId")
    }
    
    func goToSettings() {
        let settings = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settings.view") as! Settings
        settings.modalPresentationStyle = .automatic
        self.present(settings, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

