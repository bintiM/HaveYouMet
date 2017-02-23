//
//  MainViewController.swift
//  have you met
//
//  Created by Marc Bintinger on 12/27/16.
//  Copyright © 2016 Marc Bintinger. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI

class MainViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var store = CNContactStore()
    var contacts: [CNContact] = []
    
    let defaults = UserDefaults.standard
    
    var mailtext:String = ""
    var betreff:String = ""
    
    var user1 = CNContact()
    var user2 = CNContact()
    
    let standardUser1 = "User1"
    let standardUser2 = "User2"
    
    @IBOutlet weak var user1Label: UILabel!
    @IBOutlet weak var user2Label: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func reset1(_ sender: Any) {
        user1Label.text = standardUser1
        sendButton.isEnabled = false
    }
    @IBAction func reset2(_ sender: Any) {
        user2Label.text = standardUser2
        sendButton.isEnabled = false
    }
    
    @IBAction func sendButtenAction(_ sender: Any) {
        sendEmail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailtext = defaults.object(forKey: "message1") as! String
        betreff = defaults.object(forKey: "message1title") as! String
        
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            print(accessGranted)
        })
        getContacts()
    }
    
//MARK: - User Actions
    
    @IBAction func textFieldValueChanged(_ sender: AnyObject) {
        
        if let query = textField.text {
            findContactsWithName(name: query)
        }
    }
    
    
 //MARK: - contact helper functions
    
    func findContactsWithName(name: String) {
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
                        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
                        self.contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor])
                        self.tableView.reloadData()
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }
    
    func getContacts() {
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        // Get all the containers
                        var allContainers: [CNContainer] = []
                        do {
                            allContainers = try self.store.containers(matching: nil)
                            //allContainers = try contactStore.containersMatchingPredicate(nil)
                        } catch {
                            print("Error fetching containers")
                        }
                        for container in allContainers {
                            // let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: nil)
                            // let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
                            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
                            self.contacts.append(contentsOf: try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor]))
                        }
                        self.tableView.reloadData()
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }
    
    
    
    

    //MARK: - sendMail
    
    func sendEmail() {
        
        
        
        mailtext = (mailtext as NSString).replacingOccurrences(of: "[name1]", with: user1.familyName)
        mailtext = (mailtext as NSString).replacingOccurrences(of: "[name2]", with: user2.familyName)
        
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["marc.bintinger@yahoo.com"])
            mail.setSubject(betreff)
            mail.setMessageBody(mailtext, isHTML: false)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    

}
//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "MyCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        cell!.textLabel!.text = contacts[indexPath.row].givenName + " " + contacts[indexPath.row].familyName
        
        if let birthday = contacts[indexPath.row].birthday {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.long
            formatter.timeStyle = .none
            
            cell!.detailTextLabel?.text = formatter.string(from: (birthday.date)!)
        }
        return cell!
    }
}
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let controller = CNContactViewController(for: contacts[indexPath.row])
        
        if(user1Label.text == standardUser1) {
            user1 = contacts[indexPath.row]
            user1Label.text = CNContactFormatter.string(from: user1, style: .fullName)
            
            if(user2Label.text != standardUser2) {
                sendButton.isEnabled = true
            }
            
        }
        else {
            if(user2Label.text == standardUser2) {
                user2 = contacts[indexPath.row]
                user2Label.text = CNContactFormatter.string(from: user2, style: .fullName)
            
                if(user1Label.text != standardUser1) {
                    sendButton.isEnabled = true
                }
            }
        }
        // controller.contactStore = self.store
        // controller.allowsEditing = false
        // self.navigationController?.pushViewController(controller, animated: true)
    }
}
