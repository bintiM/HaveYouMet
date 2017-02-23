//
//  sendMailControllerViewController.swift
//  have you met
//
//  Created by Marc Bintinger on 28.01.17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import UIKit
import MessageUI

class sendMailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    let defaults = UserDefaults.standard
    
    var mailtext:String = ""
    var betreff:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailtext = defaults.object(forKey: "message1") as! String
        betreff = defaults.object(forKey: "message1title") as! String

        // Do any additional setup after loading the view.
    }

    @IBAction func sendMail(_ sender: Any) {
        sendEmail()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendEmail() {
        
        
        let replaced = (mailtext as NSString).replacingOccurrences(of: "[name1]", with: "Franz")
      
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["marc.bintinger@yahoo.com"])
            mail.setSubject(betreff)
            mail.setMessageBody(replaced, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
