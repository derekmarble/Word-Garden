//
//  ViewController.swift
//  Word Garden
//
//  Created by Derek Marble on 2/7/22.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    
    @IBOutlet weak var wordBeingRevealedLabel: UILabel!
    
    @IBOutlet weak var guessedLetterTextField: UITextField!
    @IBOutlet weak var guessedLetterButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
   
    @IBOutlet weak var gameStatusMessageLabel: UILabel!
    
    @IBOutlet weak var flowerImageView: UIImageView!
    
    var wordsToGuess = ["SWIFT","DOG","CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessedLetterTextField.text!
        guessedLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        updateGameStatusLabels()
       
    }

    func updateUIAfterGuess() {
        guessedLetterTextField.resignFirstResponder()
        guessedLetterTextField.text! = ""
        guessedLetterButton.isEnabled = false
    }
    
    func formatRevealedWord() {
        var revealedWord = ""
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord += "\(letter) "
            } else {
                revealedWord += "_ "
            }
        }
        revealedWord.removeLast()
        wordBeingRevealedLabel.text = revealedWord
    }
   
    func updateGameStatusLabels() {
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = "Words to Guess: \(wordsToGuess.count - (wordsGuessedCount + wordsMissedCount))"
        wordsInGameLabel.text = "Words in Game: \(wordsToGuess.count)"
    }
    
    func updateAfterWinOrLoose() {
//        what do we do if the game is over?
//        increment current word index by 1
//        disable guessALetter text field
//        disable guessALetterButton
//        set playAgainButton.isHidden equal to False
//        update all labels at top of the screen
        currentWordIndex += 1
        guessedLetterTextField.isEnabled = false
        guessedLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        
        updateGameStatusLabels()
        

    }
    
    func guessALetter() {
        // get current letter guessed and add it to all letters guessed
        let currentLetterGuessed = guessedLetterTextField.text!
        lettersGuessed += currentLetterGuessed
        formatRevealedWord()
        
        // update image if needed, and keep track of the wrong guesses
        if wordToGuess.contains(currentLetterGuessed) == false {
            wrongGuessesRemaining -= 1
            flowerImageView.image = UIImage(named: "flower\(wrongGuessesRemaining)")
            
    }
        // update gameStatusMessageLabel
        guessCount += 1
//        var guesses = "Guesses"
//        if guessCount == 1 {
//            guesses = "Guess"
        let guesses = (guessCount == 1 ? "Guess" : "Guesses")
        
        gameStatusMessageLabel.text = "You've Made \(guessCount) \(guesses)"
        
//        Check for win or loose:

        if wordBeingRevealedLabel.text!.contains("_") == false {
            gameStatusMessageLabel.text = "You've guessed it! It took you \(guessCount) guesses to guess the word."
            wordsGuessedCount += 1
            updateAfterWinOrLoose()
        } else if wrongGuessesRemaining == 0 {
            gameStatusMessageLabel.text = "So sorry! You're all out of guesses."
            wordsMissedCount += 1
            updateAfterWinOrLoose()
            
        }
        if currentWordIndex == wordsToGuess.count {
            gameStatusMessageLabel.text! += "\n\nYou've tried all of the words. Restart from the beginning?"
        }
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text! = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces)
        guessedLetterButton.isEnabled = !(sender.text!.isEmpty)
    }
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        if currentWordIndex == wordToGuess.count {
            currentWordIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0
        }
        
        playAgainButton.isHidden = true
        guessedLetterTextField.isEnabled = true
        guessedLetterButton.isEnabled = false // doesn't turn true until a character is in the test field
        wordToGuess = wordsToGuess[currentWordIndex]
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        guessCount = 0
        flowerImageView.image = UIImage(named: "flower\(maxNumberOfWrongGuesses)")
        lettersGuessed = ""
        updateGameStatusLabels()
        gameStatusMessageLabel.text = "You've Made Zero guesses"
    }



}
