//
//  questionModal.swift
//  TrueFalseStarter
//
//  Created by Matthew Phillips on 08/05/2016.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameplayKit

struct QuestionModal {
    var question: String
    var correctAnswer: Int
    var allAnswers: [String]
}

struct Questions {
    let questionList = [
        QuestionModal(question: "Who was Frankie Edgars first UFC fight against?", correctAnswer: 0, allAnswers: ["Tyson Griffin", "Grey Maynard", "BJ Penn"]),
        QuestionModal(question: "Which fighter won \"Fight Of The Year\" honors in 2005?", correctAnswer: 2, allAnswers: ["Michael Bisping", "Chuck Liddell", "Forrest Griffin", "Dan Henderson "]),
        QuestionModal(question: "Chuck Liddell made his debut at which UFC event?", correctAnswer: 1, allAnswers: ["UFC 105", "UFC 17", "UFC: Fight Night 1", "UFC 200"]),
        QuestionModal(question: "What was NOT allowed in UFC 1?", correctAnswer: 3, allAnswers: ["Elbows", "Groin Strikes", "Takedowns", "Fish Hooking"]),
        QuestionModal(question: "Which of these fighters is known as \"The Sandman\"?", correctAnswer: 1, allAnswers: ["Conor McGregor", "James Irvin", "Randy Couture"]),
        QuestionModal(question: "At what UFC tournament did Marco Ruas win?", correctAnswer: 3, allAnswers: ["UFC 1", "UFC 3", "UFC 5", "UFC 7"]),
        QuestionModal(question: "The UFC mainly holds events in Las Vegas. What state was the first UFC held in?", correctAnswer: 0, allAnswers: ["Colorado", "Las Vegas", "New York"]),
        QuestionModal(question: "Which former Light Heavyweight UFC Champion is known as the 'Iceman'?", correctAnswer: 2, allAnswers: ["George St-Pierre", "Quinton Jackson", "Chuck Liddell", "Rich Franklin"]),
        QuestionModal(question: "Which of the following fighters was the first-ever UFC Middleweight Champion?", correctAnswer: 0, allAnswers: ["Dave Menne ", "Rickson Gracie", "Dan Severn", "Mark Coleman"]),
        QuestionModal(question: "What is Ronda Rousey's Nickname", correctAnswer: 3, allAnswers: ["Rough", "Rumble", "Rocky", "Rowdy"])
    ]
    
    func returnQuestion(questionIndex: Int) -> (question: String, answers: [String]) {
        return (questionList[questionIndex].question, questionList[questionIndex].allAnswers)
    }
    
    func checkAnswer(answer: Int, question: Int) -> (isCorrect: Bool, correctAnswer: Int) {
        let isCorrect: Bool
        
        if answer == questionList[question].correctAnswer {
            isCorrect = true
        } else {
            isCorrect = false
        }
       
        return (isCorrect, questionList[question].correctAnswer)
    }
    
}