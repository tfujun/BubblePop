//
//  HighScoreViewController.swift
//  BubblePop
//
//  Created by Travis Chang on 25/4/2022.
//

import Foundation

import UIKit

struct GameScore: Codable{
    var name: String
    var score: Int
}

let UD_KEY_HIGH_SCORE = "highScore";

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var highScoreTableView: UITableView!
    
    var highScores: [GameScore] = []
    var currentGameScore = 0
    var currentPlayerName = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.highScores = readHighScores();
        print("arrayFromUserDefaults ", highScores);
        
        //Sort highscores
        highScores.sort{
            $0.score > $1.score;
        }
        
    }
    
    //return to home page button
    @IBAction func returnHomePage(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //Save highscores to userDefaults - should happen at end of game;
    func writeHighScores(){
        let defaults = UserDefaults.standard;
        
        let updatedHighScores = highScores;
        
        defaults.set(try? PropertyListEncoder().encode(updatedHighScores), forKey: UD_KEY_HIGH_SCORE);
    }
    
    //Read highscores from userDefaults - should happen at start of app;
    func readHighScores() -> [GameScore]{
        
        let defaults = UserDefaults.standard;
        
        if let savedArrayData = defaults.value(forKey:UD_KEY_HIGH_SCORE) as? Data{
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData){
                return array
            }
            else{
                return []
            }
        }
        else{
            return []
        }
        
    }
    
    func writeRecentGame(playerName: String, playerScore: Int){
        highScores = readHighScores();
        let currentGame = GameScore(name: playerName, score: playerScore);
        highScores.append(currentGame);
        writeHighScores();
    }
    
    func returnHighestScore() -> Int{
        highScores = readHighScores();
        if highScores.count >= 1 {
            return highScores[0].score;
        }
        else{
            return 0;
        }
    }
    
}
//Tells table view what it should do when something happens
extension HighScoreViewController: UITableViewDelegate{
    
}

//Tells the table view how many cells to make and what they should display
extension HighScoreViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //How many cells table view displays
        return highScores.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //What should each cell display at each index
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath)
        
        //Update UI for cell
        let thisRowScore = highScores[indexPath.row];
        
        cell.textLabel?.text = thisRowScore.name;
        cell.detailTextLabel?.text = String(thisRowScore.score);
        
        //Return the updated cell
        return cell;
    }
}


