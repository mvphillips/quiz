//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    //List of flags and vars to keep track of the game
    let questionsPerGame = 4 //How many questions asked per game
    var questionsAsked = 0 //How many have been asked in current game
    var correctQuestions = 0 //Current score of the game
    var randomQuestionList: Array <AnyObject> = [] //An array to store a random list of questions
    let questions = Questions() //Questions modal
    
    // IDs for the sounds of the game
    var gameSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 0
    var incorrectSound: SystemSoundID = 0
    
    // Vars and timer for the ligthning round
    var lightningTimer = NSTimer()
    let timePerRound = 15 //Time in seconds
    var timeLeft = 0
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var firstAnswer: UIButton!
    @IBOutlet weak var secondAnswer: UIButton!
    @IBOutlet weak var thirdAnswer: UIButton!
    @IBOutlet weak var fourthAnswer: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameSounds()
        startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sets everything up to start the game
    func startGame() {
        //Adds tag to buttons so we know which one has been pressed
        firstAnswer.tag = 0
        secondAnswer.tag = 1
        thirdAnswer.tag = 2
        fourthAnswer.tag = 3
        questionsAsked = 0
        correctQuestions = 0
        
        playGameStartSound()
        
        //Makes sure all the answers are visible
        showHideAnswers(false)
    
        //Randomise the question array so that questions do not repeat themselves
        let questionNumbers = [Int](0...questions.questionList.count-1)
        randomQuestionList = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(questionNumbers)
        
        //Start the game
        nextRound()
    }
    
    //Displays the questions and answers to the player
    func displayQuestion() {
        
        //Get the next question to ask from the random array
        let questionToAsk = randomQuestionList[questionsAsked] as! Int
        let question = questions.returnQuestion(questionToAsk)
        
        //Display the question
        questionField.text = question.question
        
        //Display the answers
        if question.answers.count > 3 {
            firstAnswer.setTitle(question.answers[0], forState: UIControlState.Normal)
            secondAnswer.setTitle(question.answers[1], forState: UIControlState.Normal)
            thirdAnswer.setTitle(question.answers[2], forState: UIControlState.Normal)
            fourthAnswer.setTitle(question.answers[3], forState: UIControlState.Normal)
            fourthAnswer.hidden = false
        } else {
            firstAnswer.setTitle(question.answers[0], forState: UIControlState.Normal)
            secondAnswer.setTitle(question.answers[1], forState: UIControlState.Normal)
            thirdAnswer.setTitle(question.answers[2], forState: UIControlState.Normal)
            fourthAnswer.hidden = true
        }
        
    }
    
    func displayScore() {
        // Hide the answer buttons
        showHideAnswers(true)
        lightningTimer.invalidate()
        
        // Display play again button
        playAgainButton.hidden = false
        if correctQuestions > 2 {
            questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerGame) correct!"
        } else {
            questionField.text = "Oh No!!! \nYou only got \(correctQuestions) out of \(questionsPerGame) correct!"
        }
        
        
    }
    
    func nextRound() {
        //Reset Text and enable buttons
        infoLabel.text = ""
        enableOrDisableButtons(true)
        
        if questionsAsked == questionsPerGame {
            // Game is over
            displayScore()
        } else {
            // Continue game
            //Start lightning round timer
            timeLeft = timePerRound
            lightningTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
            infoLabel.text = "\(timeLeft)s left"
            infoLabel.textColor = UIColor.greenColor()
            displayQuestion()
        }

    }
    
    func updateTimer() {
        
        //Reduce time
        timeLeft -= 1
        //Update Timer Label
        infoLabel.text = "\(timeLeft)s left"
        
        if timeLeft < 6 {
            //Gives indication that time is running out
            infoLabel.textColor = UIColor.orangeColor()
        }
        if timeLeft < 1 {
            //Time is up display text and reset for next question
            infoLabel.text = "Times Up"
            infoLabel.textColor = UIColor.redColor()
            enableOrDisableButtons(false)
            lightningTimer.invalidate()
            nextQuestion()
        }
    }
    
    //Function used to enable to disable the buttons so the player cannot answer twice per round
    func enableOrDisableButtons(enabled: Bool) {
        firstAnswer.enabled = enabled
        secondAnswer.enabled = enabled
        thirdAnswer.enabled = enabled
        fourthAnswer.enabled = enabled
        
        if !enabled {
            firstAnswer.setTitleColor(UIColor.grayColor(), forState: .Disabled)
            secondAnswer.setTitleColor(UIColor.grayColor(), forState: .Disabled)
            thirdAnswer.setTitleColor(UIColor.grayColor(), forState: .Disabled)
            fourthAnswer.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        }
    }
    
    //Function to show or hide the buttons
    func showHideAnswers(showOrHide: Bool) {
        firstAnswer.hidden = showOrHide
        secondAnswer.hidden = showOrHide
        thirdAnswer.hidden = showOrHide
        fourthAnswer.hidden = showOrHide
        infoLabel.hidden = showOrHide
        playAgainButton.hidden = !showOrHide
    }
    
    //move on to the next question
    func nextQuestion() {
        questionsAsked += 1
        loadNextRoundWithDelay(seconds: 2)
    }
    
    
    @IBAction func checkAnswer(sender: UIButton) {
        //Find out if answer is correct
        lightningTimer.invalidate()
        enableOrDisableButtons(false)
        let findAnswer = questions.checkAnswer(sender.tag, question: randomQuestionList[questionsAsked] as! Int)
        
        //Show result to player
        if findAnswer.isCorrect {
            correctQuestions += 1
            infoLabel.text = "Correct!"
            infoLabel.textColor = UIColor(red: 0/255.0, green: 147/255.0, blue: 135/255.0, alpha: 1/1.0)
            playCorrectSound()
            
        } else {
            infoLabel.text = "Incorrect!"
            infoLabel.textColor = UIColor(red: 255/255.0, green: 162/255.0, blue: 98/255.0, alpha: 1/1.0)
            playIncorrectSound()
            
        }
        
        //Show the correct Answer
        switch findAnswer.correctAnswer {
            case 0:
                firstAnswer.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
            case 1:
                secondAnswer.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
            case 2:
                thirdAnswer.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
            case 3:
                fourthAnswer.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
            default:
                break
        }
        
        //Increment the questions counter and start another question
        nextQuestion()
        
    }

    
    @IBAction func playAgain() {
        // Show the answer buttons
        startGame()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
    
    //Loading all game sounds
    func loadGameSounds() {
        
        let pathToGameFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToGameFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
        
        let pathToCorrectFile = NSBundle.mainBundle().pathForResource("correct", ofType: "wav")
        let correctSoundURL = NSURL(fileURLWithPath: pathToCorrectFile!)
        AudioServicesCreateSystemSoundID(correctSoundURL, &correctSound)
        
        let pathToIncorrectFile = NSBundle.mainBundle().pathForResource("incorrect", ofType: "wav")
        let incorrectSoundURL = NSURL(fileURLWithPath: pathToIncorrectFile!)
        AudioServicesCreateSystemSoundID(incorrectSoundURL, &incorrectSound)
        
    }
    
    //Play the start game sound
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    //Play the incorrect answer thump
    func playIncorrectSound() {
        AudioServicesPlaySystemSound(incorrectSound)
    }
    
    //Play the correct answer tone
    func playCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
}

