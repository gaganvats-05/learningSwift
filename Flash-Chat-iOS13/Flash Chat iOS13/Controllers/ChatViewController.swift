//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title = "⚡️FlashChat"
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
    }
    
    //MARK: - Load Messages
    func loadMessages(){
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { (QuerySnapshot, error) in
                
                
            // this is to empty out the messages array so that previous messages don't get repeatedly loaded
            self.messages = []
            
            if let e =  error{
                print("DEBUG: error in getting documents from firestore , \(e)")
            }else{
                if let snapshotDocuments =  QuerySnapshot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String , let messageBody = data[Constants.FStore.bodyField] as? String {
                            let newMessage =  Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    //MARK: - Actions
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody =  messageTextfield.text,let messageSender = Auth.auth().currentUser?.email{
            db.collection(Constants.FStore.collectionName).addDocument(data:[ Constants.FStore.senderField: messageSender,
                                                                              Constants.FStore.bodyField:messageBody,
                                                                              Constants.FStore.dateField:Date().timeIntervalSince1970
                                                                              
                ]) { (error) in
                    if let e =  error{
                        print("DEBUG: Can't store data in firestore, \(e)")
                    }else{
                        print("sucessfully saved data to the firestore")
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                    }
            }
        }
    }
    

}

//MARK: - TableView DataSource
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MesageCell
        cell.messageLabel.text = message.body
        
        // if the message is from the current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: Constants.BrandColors.purple)
        }else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.messageLabel.textColor = UIColor(named: Constants.BrandColors.lightPurple)


        }
        return cell
    }
    
    
}
