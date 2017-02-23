//
//  MessageViewController.swift
//  have you met
//
//  Created by Marc Bintinger on 28.01.17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    var value: String = ""
    var message: Message? = nil
    

    @IBOutlet weak var messageTitleOutlet: UITextField!
    @IBOutlet weak var messageTextOutlet: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        let message1 = defaults.object(forKey: "message1") as! String
        let message1title = defaults.object(forKey: "message1title") as! String
        let message2 = defaults.object(forKey: "message2") as! String
        let message2title = defaults.object(forKey: "message2title") as! String
        let message3 = defaults.object(forKey: "message3") as! String
        let message3title = defaults.object(forKey: "message3title") as! String
        
        
        messageTitleOutlet.text = message1title
        messageTextOutlet.text = message1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
