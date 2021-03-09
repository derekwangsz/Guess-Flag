//
//  ViewController.swift
//  GuessFlag
//
//  Created by Derek Wang on 2020-12-02.
//

import UIKit
import CoreData

class PlayingViewController: UIViewController {

    @IBOutlet weak var flag1: UIButton!
    
    @IBOutlet weak var flag2: UIButton!
    
    @IBOutlet weak var flag3: UIButton!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let user = User()
    var flagCountries = [String:UIImage]()
    var questionCountries = [String]()
    var score = 0
    var answer = String()
    var answerFlag : UIButton?
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared")
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        flag1.layer.borderWidth = 1
        flag1.layer.cornerRadius = 20
        flag1.layer.masksToBounds = true
        flag2.layer.borderWidth = 1
        flag2.layer.cornerRadius = 20
        flag2.layer.masksToBounds = true
        flag3.layer.borderWidth = 1
        flag3.layer.cornerRadius = 20
        flag3.layer.masksToBounds = true
        
        reset()
        
        for country in questionCountries{
            flagCountries[country] = UIImage(named: country.lowercased())
        }
        
        askQuestion()
        
    }
    
    @IBAction func scoreBoardButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toResults", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultsViewController
        destinationVC.questionCountriesLeft = questionCountries
        destinationVC.newUser = user
    }
    

    
    @IBAction func flagSelected(_ sender: UIButton) {
        
        guard let correct = sender.currentImage?.isEqual(UIImage(named: answer)) else{return}
        
        if correct{
            score += 1
            user.score = Int16(score)
        }
        
        print(score)
        askQuestion()
    }
    
    
    //MARK: - Gameplay Functions
    
    func askQuestion(){
        
        questionCountries.shuffle()
        
        navigationItem.title = questionCountries[0]
        
        answer = questionCountries[0].lowercased()
        
        answerFlag = [flag1,flag2,flag3].randomElement()!
            
        answerFlag?.setImage(UIImage(named: answer), for: .normal)
        
        setImages()
        
        if questionCountries.count > 1{
            questionCountries.remove(at: 0)
        }else{
            playAgain()
            performSegue(withIdentifier: "toResults", sender: self)
        }
    }
    
    
    func setImages(){
        
        if let answerImage = answerFlag?.currentImage{
            var image1 = flagCountries.values.randomElement()!
            var image2 = flagCountries.values.randomElement()!
            
            while image1 == image2 || image1 == answerImage || image2 == answerImage{
                image1 = flagCountries.values.randomElement()!
                image2 = flagCountries.values.randomElement()!
            }
            
            var newImages = [image1,image2]
            var buttonIndex = 0
            
            for button in [flag1,flag2,flag3]{
                buttonIndex += 1
                if let usableButton = button{
                    if !usableButton.isEqual(answerFlag){
                        if buttonIndex == 1{
                            flag1.setImage(newImages[0], for: .normal)
                            newImages.remove(at: 0)
                            print("set image for flag1")
                        }else if buttonIndex == 2{
                            flag2.setImage(newImages[0], for: .normal)
                            newImages.remove(at: 0)
                            print("set image for flag2")
                        }else{
                            flag3.setImage(newImages[0], for: .normal)
                            print("set image for flag3")
                        }
                    }
                }
            }
        }
    }
    
    func playAgain(){
        //SET UP THE BUTTONS FOR PLAYING AGAIN, ALSO, DISABLE THE FLAGS SO THE USER CANT GET MORE POINTS.
        if questionCountries.count == 0 {
            
        }
    }
    
    
    func reset(){
        
        questionCountries += ["France","Spain","Germany","UK",
                      "US","Estonia","Nigeria","Monaco",
                      "Italy","Poland","Russia","Ireland"]
        score = 0
    }
    
}

