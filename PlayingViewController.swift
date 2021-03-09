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
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var replayButton: UIBarButtonItem!
    
    var flagCountries = [String:UIImage]()
    var questionCountries = [String]()
    var score = 0
    var answer = String()
    var answerFlag : UIButton?
    var didFinishedPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        flag1.layer.borderWidth = 1
        flag1.layer.cornerRadius = 20
        flag1.layer.masksToBounds = true
        flag2.layer.borderWidth = 1
        flag2.layer.cornerRadius = 20
        flag2.layer.masksToBounds = true
        flag3.layer.borderWidth = 1
        flag3.layer.cornerRadius = 20
        flag3.layer.masksToBounds = true
        playAgainButton.layer.cornerRadius = 20
        playAgainButton.layer.masksToBounds = true
        
        reset()
        
        for country in questionCountries{
            flagCountries[country] = UIImage(named: country.lowercased())
        }
        
        askQuestion()
        
    }
    
    
    @IBAction func restartButtonPressed(_ sender: UIBarButtonItem) {
        if didFinishedPlaying{
            playAgain()
            didFinishedPlaying = false
        }else{
            reset()
            askQuestion()
        }
    }
    
    @IBAction func scoreBoardButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toResults", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultsViewController
        destinationVC.questionCountriesLeft = questionCountries
        destinationVC.score = score
    }
    

    
    @IBAction func flagSelected(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
        
        guard let correct = sender.currentImage?.isEqual(UIImage(named: answer)) else { return }
        
        if correct{
            score += 1
            scoreLabel.text = "Score : \(score)"
        }
        
        print("score is \(score)")
        askQuestion()
    }
    
    
    @IBAction func playAgainPressed(_ sender: UIButton) {
        playAgain()
    }
    
    
    //MARK: - Gameplay Functions
    
    func askQuestion(){
        
        questionCountries.shuffle()
        
        navigationItem.title = questionCountries[0]
        
        answer = questionCountries[0].lowercased()
        
        answerFlag = [flag1,flag2,flag3].randomElement()!
        
        answerFlag?.setImage(UIImage(named: answer), for: .normal)
        
        setImages()
        if questionCountries.count > 1 {
            questionCountries.remove(at: 0)
        }
        else{
            questionCountries.remove(at: 0)
            finishedPlaying()
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
    
    
    
    func finishedPlaying(){
        
        self.flag1.isHidden.toggle()
        self.flag2.isHidden.toggle()
        self.flag3.isHidden.toggle()
        self.imageView.isHidden.toggle()
        self.commentLabel.isHidden.toggle()
        self.playAgainButton.isHidden.toggle()
        self.didFinishedPlaying = true
        
        commentLabel.text = "Your score is \(score) - "
        
        if self.score <= 3{
            self.commentLabel.text! += "damn, that's the best you can do?"
            self.imageView.image = UIImage(named: "skull")
            title = "🐽"
        }else if self.score <= 5{
            self.commentLabel.text! += "ok, not bad for a six-year-old..."
            self.imageView.image = UIImage(named: "nobrain")
            title = "🙃"
        }else if self.score <= 7{
            self.commentLabel.text! += "we are talkin now..."
            self.imageView.image = UIImage(named: "ok")
            title = "😏"
        }else{
            self.commentLabel.text! += "wow, you see yourself on the scoreboard?"
            self.imageView.image = UIImage(named: "everest")
            title = "🥳"
        }
    }
    
    
    func reset(){
        
        questionCountries = ["France","Spain","Germany","UK",
                      "US","Estonia","Nigeria","Monaco",
                      "Italy","Poland","Russia","Ireland"]
        score = 0
        scoreLabel.text = "Score : \(score)"
    }
    
    func playAgain(){
        flag1.isHidden.toggle()
        flag2.isHidden.toggle()
        flag3.isHidden.toggle()
        imageView.isHidden.toggle()
        commentLabel.isHidden.toggle()
        playAgainButton.isHidden.toggle()
        reset()
        askQuestion()
    }
    
}

