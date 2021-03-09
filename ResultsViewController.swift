//
//  ResultsViewController.swift
//  GuessFlag
//
//  Created by Derek Wang on 2020-12-05.
//

import UIKit
import CoreData

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var questionCountriesLeft : [String]?
    var score : Int?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        tableView.dataSource = self
        tableView.layer.borderWidth = 7
        
        if let score = score{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score : \(score)", style: .plain, target: nil, action: nil)
        }
        
        //adjust the color below until it looks good... then, start on the view controller that lets the user choose how many questions they want.
        tableView.layer.borderColor = CGColor(red: 0.8588, green: 0.3725, blue: 0, alpha: 1.0)
        
        if let questionsCount = questionCountriesLeft?.count{
            if questionsCount == 0{
                //the user have answered all the questions
                textField.isHidden = false
                doneButton.isHidden = false
            }
        }
        loadUsers()
        print("user count : \(users.count)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        textField.isHidden = true
        doneButton.isHidden = true
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if let usableScore = score{
            if textField.text != ""{
                let user = User(context: context)
                user.name = textField.text
                user.score = Int16(usableScore)
                users.append(user)
                print("usersaved")
                saveUser()
            }else{return}
        }
        doneButton.isHidden = true
        textField.text = ""
        textField.isHidden = true
    }
    
    
    
    //MARK: - Data Manipulation Methoods
    func saveUser(){
        users = users.sorted{ $0.score > $1.score }
        do{
            try context.save()
        }catch{
            print("Error saving groups, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadUsers(){
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do{
            users = try context.fetch(fetchRequest)
        }catch{
            print("Error fetching groups,\(error)")
        }
        users = users.sorted{ $0.score > $1.score }
        
        tableView.reloadData()
    }
}


//MARK: - Datasource Methods
extension ResultsViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreBoardCell", for : indexPath)
        if let name = user.name{
            cell.textLabel!.text = String(indexPath.row + 1) + "    " + name
        }
        cell.detailTextLabel?.text = String(user.score)
        return cell
    }
    
}
