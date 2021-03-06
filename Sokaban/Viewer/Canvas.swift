//
//  Canvas.swift
//  Sokaban
//
//  Created by Nurseit Akysh on 10/25/20.
//

import UIKit

internal class Canvas: UIView {
    private var contentView: UIView?
    private var model: Model?
    
    private var player: UIImage!
    private var wall: UIImage!
    private var floor: UIImage!
    private var target: UIImage!
    private var box: UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        player = UIImage(named: "Player")
        wall = UIImage(named: "Tree")
        floor = UIImage(named: "Sand")
        target = UIImage(named: "Soil")
        box = UIImage(named: "Coconut")
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(red: 0.77, green: 0.98, blue: 0.83, alpha: 1.00)
        frame = bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        frame.size.width = UIScreen.main.bounds.width
        frame.size.height = UIScreen.main.bounds.height * 0.95
        frame.origin.x = UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 2
        frame.origin.y = UIScreen.main.bounds.height / 2 - UIScreen.main.bounds.height * 0.90 / 2
        
    }
    
    internal func connectModel(model: Model) {
        
        self.model = model
    }
    
    internal func update() {
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        var coordinateX:Double = 0
        var coordinateY:Double = 140
        let width:Double = 41.5
        let height:Double = 41.5
        
        let desktop: [[Int]] = (model?.getDesktop())!
        
        for rowDesktop in desktop {
            for columnDesktop in rowDesktop {
                let pathRect = CGRect(x: coordinateX, y: coordinateY, width: width, height: height )
                
                if columnDesktop == Actors.PLAYER.rawValue {
                    
                    player.draw(in: pathRect)
                } else if columnDesktop == Actors.WALL.rawValue {
                    
                    wall.draw(in: pathRect)
                } else if columnDesktop == Actors.BOX.rawValue{
                    
                    box.draw(in: pathRect)
                } else if columnDesktop == Actors.TARGET.rawValue {
                    
                    target.draw(in: pathRect)
                } else {
                    
                    floor.draw(in: pathRect)
                }
                
                coordinateX = coordinateX + width
            }
            
            coordinateX = 0
            coordinateY = coordinateY + height
        }
    }
}
