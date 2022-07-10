//
//  Bubble.swift
//  BubblePop
//
//  Created by Travis Chang on 25/4/2022.
//

import UIKit

class Bubble: UIButton{
    var xPosition = Int.random(in:50...3000) //= Int.random(in:20...150) //20...150 max
    var yPosition = Int.random(in:150...3000) //= Int.random(in:150...800) //150...800 max
    var points = 0;
    
    override init(frame: CGRect){
        super.init(frame: frame);
        
        //Picking a color
        let colorProbability = Int.random(in:1...100);
        if 1...40 ~= colorProbability{
            self.backgroundColor = .red
            points = 1;
        }
        if 41...70 ~= colorProbability{
            self.backgroundColor = .systemPink
            points = 2;
        }
        if 71...85 ~= colorProbability{
            self.backgroundColor = .green
            points = 5;
        }
        if 86...95 ~= colorProbability{
            self.backgroundColor = .blue
            points = 8;
        }
        if 96...100 ~= colorProbability{
            self.backgroundColor = .black
            points = 10;
        }
        
        self.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented");
    }
    
    func animation(){
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func flash(){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    func getPoints() -> Int{
        return points;
    }
    
    func getPos() -> (xPosition: Int, yPosition: Int){
        return (xPosition, yPosition);
    }
}
