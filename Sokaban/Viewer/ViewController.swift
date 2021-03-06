//
//  ViewController.swift
//  Sokaban
//
//  Created by Nurseit Akysh on 10/19/20.
//

import UIKit

internal class ViewController: UIViewController {
    
    private var controller: Controller?
    private var canvas: Canvas?
    private var levelNames: [String]?
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        controller = Controller(viewer: self)
        canvas = Canvas()
        levelNames = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = controller?.getModel()
        
        let buttonMenu = UIButton(frame: CGRect(x: 10, y: 45, width: 100, height: 30))
        
        let rightSwipe = UISwipeGestureRecognizer(target: controller, action: #selector(controller?.handleSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: controller, action: #selector(controller?.handleSwipe(sender:)))
        let downSwipe = UISwipeGestureRecognizer(target: controller, action: #selector(controller?.handleSwipe(sender:)))
        let upSwipe = UISwipeGestureRecognizer(target: controller, action: #selector(controller?.handleSwipe(sender:)))
        
        canvas?.connectModel(model: model!)
        levelNames = model?.getAllLevelsName()
        leftSwipe.direction = .left
        downSwipe.direction = .down
        upSwipe.direction = .up
        
        buttonMenu.backgroundColor = .green
        buttonMenu.setTitle("Menu", for: .normal)
        buttonMenu.addTarget(self, action: #selector(menuModal), for: .touchUpInside)
        
        view.addSubview(canvas!)
        view.addSubview(buttonMenu)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(upSwipe)
        
    }
    
    internal func didGetListOfLevelsName(levelsName:[String]) {
        levelNames = levelsName
    }

    // MARK: Update canvas
    internal func update() {
        
        canvas?.update()
    }
    
    @objc private func menuModal() {
        let alertModal = UIAlertController(title: "Levels", message: "Choose level", preferredStyle: UIAlertController.Style.alert)
        
        if let levelNames = self.levelNames {
            for level in levelNames {
                alertModal.addAction(UIAlertAction(title: level, style: .default, handler: {_ in self.controller?.changeLevelModel(levelName: level)}))
            }
        }
        

        alertModal.addAction(UIAlertAction(title: "Restart current level", style: .destructive, handler: {_ in
            self.controller?.restartCurrentLevelInModel()
        }))
        alertModal.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertModal, animated: true, completion: nil)
        
    }
    
    internal func alertWinLevel() {
        let alertWin = UIAlertController(title: "You win", message: nil, preferredStyle: .alert)

        alertWin.addAction(UIAlertAction(title: "Restart current level", style: .destructive, handler: { _ in
            self.controller?.restartCurrentLevelInModel()
        }))
        alertWin.addAction(UIAlertAction(title: "Choose level", style: .default, handler: {_ in self.menuModal()}))
        
        
        self.present(alertWin, animated: true, completion: nil)
    }
    
    internal func alertErrorMessage(errorMessage: SocketErrors) {
        var message: String = ""
        
        switch errorMessage {
        case .errorWithRecievingMessage:
            message = "Failed to load map"
        case .serverDisconnected:
            message = "Server has stopped working"
        case .serverIsOffline:
            message = "The server does not work"
        }
        
        let alertErrorMessage = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alertErrorMessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertErrorMessage, animated: true, completion: nil)
    }

}


