//
//  SettingsViewController.swift
//  BubblePop
//
//  Created by Travis Chang on 25/4/2022.
//

import Foundation

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var playerNameTf: UITextField!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var bubblesSlider: UISlider!
    
    @IBOutlet weak var bubblesLabel: UILabel!
    
    var highScore:Int?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timeLabel.text = String(Int(timeSlider.value))
        bubblesLabel.text = String(Int(bubblesSlider.value))
    }
    
    
    @IBAction func GameTimeValueChanged(_ sender: Any) {
        timeLabel.text = String(Int(timeSlider.value));
    }
    
    @IBAction func BubbleNumberValueChanged(_ sender: Any) {
        bubblesLabel.text = String(Int(bubblesSlider.value));
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame"{
            let VC = segue.destination as! GameViewController
            VC.remainingTime = Int(timeSlider.value);
            VC.playerName = playerNameTf.text!;
            VC.maxBubbles = Int(bubblesSlider.value);
            VC.highScore = highScore ?? 0;
            
        }
    }
    
    
    
}
