//
//  GameViewController.swift
//  BubblePop
//
//  Created by Travis Chang on 25/4/2022.
//

import Foundation

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var remainingTime = 60;
    var currentScore = 0;
    var playerName:String?
    var timer = Timer()
    var highScore = 0;
    var maxBubbles = 15;
    var bubblePoint:Int?;
    var bubbleCount = 0;
    var bubblesArray: Array<Bubble> = Array();
    var bogeyBubble = Bubble()
    var prevBubbleColor:String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        remainingTimeLabel.text = String(remainingTime);
        currentScoreLabel.text = String(currentScore);
        bubblesArray.append(bogeyBubble);
        let VC = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
        highScore = VC.returnHighestScore();
        highScoreLabel.text = String(highScore);
        
        //      Active timer, generate bubbles each second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            timer in
            self.generateBubbles()
            self.count()
        }
    }
    
    @objc func count(){
        remainingTime -= 1;
        remainingTimeLabel.text = String(remainingTime);
        
        if remainingTime == 0{
            timer.invalidate();
            let VC = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            VC.writeRecentGame(playerName: playerName ?? "Anonymous Player", playerScore: currentScore);
            self.navigationController?.pushViewController(VC, animated: true)
            VC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    @objc func generateBubbles(){
        //Select a random number of bubbles to generate
        let bubblesToGenerate = Int.random(in:1...maxBubbles);
        
        if !bubblesArray.isEmpty{
            for i in 0...bubblesArray.count-1{
                bubblesArray[i].removeFromSuperview();
            }
        }
        
        
        bubblesArray.removeAll();
        bubbleCount = 0;
        
        while(bubbleCount < bubblesToGenerate){
            var canGenerate = true;
            let bubble = Bubble();
            
            for existingBubble in bubblesArray {
                let existingXPos = existingBubble.getPos().xPosition;
                let existingYPos = existingBubble.getPos().yPosition;
                
                let newXPos = bubble.getPos().xPosition;
                let newYPos = bubble.getPos().yPosition;
                
                let xDistance = (newXPos - existingXPos)*(newXPos - existingXPos);
                let yDistance = (newYPos - existingYPos)*(newYPos - existingYPos);
                let mDistance = sqrt(Double(xDistance + yDistance));
                
                if mDistance <= 50{
                    canGenerate = false;
                    break;
                }
                else{
                    continue;
                }
            }
            
            if(bubble.getPos().xPosition < 20 ||
               bubble.getPos().yPosition < 150 ||
               bubble.getPos().xPosition > Int(self.view.safeAreaLayoutGuide.layoutFrame.size.width-70) ||
               bubble.getPos().yPosition > Int(self.view.safeAreaLayoutGuide.layoutFrame.size.height-70)){
                canGenerate = false;
            }
            
            if canGenerate{
                bubblesArray.append(bubble);
                bubbleCount = bubbleCount + 1;
                bubble.animation();
                bubble.addTarget(self, action:#selector(bubblePressed), for: .touchUpInside);
                self.view.addSubview(bubble);
            }
        }
    }
    
    @IBAction func bubblePressed(bubble: Bubble){
        //Check color and add points:
        var bubblePoint = bubble.getPoints();
        
        if bubblePoint == 1{
            if prevBubbleColor == "red"{
                bubblePoint = Int(Double(bubblePoint)*1.5)
            }
            prevBubbleColor = "red";
        }
        if bubblePoint == 2{
            if prevBubbleColor == "pink"{
                bubblePoint = Int(Double(bubblePoint)*1.5)
            }
            prevBubbleColor = "pink";
        }
        if bubblePoint == 5{
            if prevBubbleColor == "green"{
                bubblePoint = Int(Double(bubblePoint)*1.5)
            }
            prevBubbleColor = "green";
        }
        if bubblePoint == 8{
            if prevBubbleColor == "blue"{
                bubblePoint = Int(Double(bubblePoint)*1.5)
            }
            prevBubbleColor = "blue";
        }
        if bubblePoint == 10{
            if prevBubbleColor == "black"{
                bubblePoint = Int(Double(bubblePoint)*1.5)
            }
            prevBubbleColor = "black";
        }
        
        currentScore += bubblePoint;
        
        currentScoreLabel.text = String(currentScore);
        
        if currentScore >= highScore{
            highScoreLabel.text = String(currentScore);
        }
        
        if let index = bubblesArray.firstIndex(of: bubble){
            bubblesArray.remove(at: index);
        }
        //remove pressed buble from view
        bubble.removeFromSuperview()
        
        
    }
    
    func returnMaxSafeSpace()->(maxX: Int, maxY: Int){
        return(Int(self.view.safeAreaLayoutGuide.layoutFrame.size.width-50), Int(self.view.safeAreaLayoutGuide.layoutFrame.size.height-50));
    }
    
}
