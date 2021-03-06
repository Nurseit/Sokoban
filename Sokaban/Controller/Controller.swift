//
//  Controller.swift
//  Sokaban
//
//  Created by Nurseit Akysh on 10/19/20.
//

import UIKit

internal class Controller {
    
    private let model:Model
    
    init(viewer: ViewController) {
        model = Model(viewer: viewer)
    
    }
    
    @objc internal func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            
            switch sender.direction {
            
            case .right:
                
                model.move(direction: .right)
            case .left:
                
                model.move(direction: .left)
            case .down:
                
                model.move(direction: .down)
            case .up:
                
                model.move(direction: .up)
            default:
                
                return
            }
        }
    }

    internal func getModel() -> Model? {
        return model
    }
    
    internal func changeLevelModel(levelName: String) {
        model.changeLevel(levelName: levelName)
    }
    
    internal func restartCurrentLevelInModel() {
        model.updateCurrentLevel()
    }
    
    internal func goToNextLevelModal() {
        model.getNextLevel()
    }
    
}
