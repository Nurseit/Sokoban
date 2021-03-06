//
//  Model.swift
//  Sokaban
//
//  Created by Nurseit Akysh on 10/19/20.
//

import Foundation

internal class Model {
    private let viewer: ViewController
    
    private var desktop: [[Int]]
    private var indexRow: Int
    private var indexColumn: Int
    private var desktopTargetArray: [[Int]]
    private let levels: Level
    
    
    init(viewer:ViewController) {
        self.viewer = viewer
        levels = Level()
        
        desktop = levels.getCurrentLevel()
        
        desktopTargetArray = desktop
        indexRow = 0
        indexColumn = 0
        
        setPositionPlayer()
        setPositionTarger()
        printDesktop()
        levels.delegate = self
    }
    
    // MARK: Calls the player's direction method
    
    internal func move(direction: Direction) {
        
        switch direction {
        
        case .left:
            
            moveLeft()
        case .right:
            
            moveRight()
        case .up:
            
            moveUp()
        case .down:
            
            moveDown()
        }
        
        checkAndPutTarget()
        
        viewer.update()
        checkForWinnings()
        printDesktop()
    }
    
    // MARK: Show desktop 2D array on the console method
    
    private func printDesktop() {
        print("\n Current desktop \n")
        for rowDesktop in desktop {
            
            print(rowDesktop)
            
        }
    }
    
    // MARK: Get desktop in 2D array mehtod
    
    internal func getDesktop() -> [[Int]] {
        
        return desktop
    }
    
    internal func getAllLevelsName() -> [String] {
        
        return levels.getListLevelsName()
    }
    
    // MARK: Change level on the pick level method

    internal func changeLevel(levelName: String) {
        
        do {
            
            try levels.pickLevel(levelName: levelName)
            
            desktop = levels.getCurrentLevel()
            desktopTargetArray = desktop
            
        } catch ErrorLevels.notFoundLevel {
            
            print("Not found level")
            
        } catch {
            
            print("Error")
        }
        
        setPositionPlayer()
        setPositionTarger()
        
        viewer.update()
        
        printDesktop()
    }
    
    // MARK: Player movement to the left method
    
    private func moveLeft() {
        
        let nextCell = desktop[indexRow][indexColumn - 1]
        
        if nextCell == Actors.WALL.rawValue {
            
            return
        } else if desktop[indexRow][indexColumn - 2] == Actors.WALL.rawValue && nextCell == Actors.BOX.rawValue {
            
            return
        } else if desktop[indexRow][indexColumn - 2] == Actors.BOX.rawValue && nextCell == Actors.BOX.rawValue {
            
            return
        } else if nextCell == Actors.BOX.rawValue {
            
            desktop[indexRow][indexColumn - 1] = Actors.FLOOR.rawValue
            desktop[indexRow][indexColumn - 2] = Actors.BOX.rawValue
            desktop[indexRow][indexColumn] = Actors.FLOOR.rawValue
            indexColumn = indexColumn - 1
            desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        } else {
            
            desktop[indexRow][indexColumn] = Actors.FLOOR.rawValue
            indexColumn = indexColumn - 1
            desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        }
    }
    
    // MARK: Player movement to the right method
    
    private func moveRight() {

        let nextCell = desktop[indexRow][indexColumn + 1]
        
        if nextCell == Actors.WALL.rawValue {
            
            return
        } else if desktop[indexRow][indexColumn + 2] == Actors.WALL.rawValue && nextCell == Actors.BOX.rawValue {
            
            return
        } else if desktop[indexRow][indexColumn + 2] == Actors.BOX.rawValue && nextCell == Actors.BOX.rawValue {
            
            return
        } else if nextCell == Actors.BOX.rawValue {
            
            desktop[indexRow][indexColumn + 1] = Actors.FLOOR.rawValue
            desktop[indexRow][indexColumn + 2] = Actors.BOX.rawValue
            desktop[indexRow][indexColumn] = Actors.FLOOR.rawValue
            indexColumn = indexColumn + 1
            desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        } else {
            
            desktop[indexRow][indexColumn] = Actors.FLOOR.rawValue
            indexColumn = indexColumn + 1
            desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        }
    }
    
    // MARK: Move the player up method
    
    private func moveUp() {
        
        let nextCell = desktop[indexRow - 1][indexColumn]
        
        if nextCell == Actors.WALL.rawValue {
            
            return
        } else if desktop[indexRow - 2][indexColumn] == Actors.WALL.rawValue && nextCell == Actors.BOX.rawValue{
            
            return
        } else if desktop[indexRow - 2][indexColumn] == Actors.BOX.rawValue && nextCell == Actors.BOX.rawValue {
            
            return
        } else if nextCell == Actors.BOX.rawValue {
            
            desktop[indexRow - 1][indexColumn] = Actors.FLOOR.rawValue
            desktop[indexRow - 2][indexColumn] = Actors.BOX.rawValue
            desktop[indexRow][indexColumn] = Actors.FLOOR.rawValue
            indexRow = indexRow - 1
            desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        } else if desktop[indexRow - 2][indexColumn] == Actors.TARGET.rawValue && nextCell == Actors.BOX.rawValue {
            
                desktop[indexRow - 1][indexColumn] = Actors.TARGET.rawValue
                desktop[indexRow - 2][indexColumn] = Actors.BOX.rawValue
                desktop[indexRow][indexColumn] = Actors.TARGET.rawValue
                indexRow = indexRow - 1
                desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        } else {
            
            desktop[indexRow][indexColumn] = Actors.FLOOR.rawValue
            indexRow = indexRow - 1
            desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        }
    }
    
    // MARK: Move the player down method
    
    private func moveDown() {
        
        let nextCell = desktop[indexRow + 1][indexColumn]
        
        if nextCell == Actors.WALL.rawValue {
            
            return
        } else if desktop[indexRow + 2][indexColumn] == Actors.WALL.rawValue && nextCell == Actors.BOX.rawValue {
            
            return
        } else if desktop[indexRow + 2][indexColumn] == Actors.BOX.rawValue && nextCell == Actors.BOX.rawValue {
            
            return
        } else if nextCell == Actors.BOX.rawValue {
            
            desktop[indexRow + 1][indexColumn] = Actors.FLOOR.rawValue
            desktop[indexRow + 2][indexColumn] = Actors.BOX.rawValue
            desktop[indexRow][indexColumn] = Actors.FLOOR.rawValue
            indexRow = indexRow + 1
            desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        } else {
            
            desktop[indexRow][indexColumn] = Actors.FLOOR.rawValue
            indexRow = indexRow + 1
            desktop[indexRow][indexColumn] = Actors.PLAYER.rawValue
            
        }
    }
    
    // MARK: Assigning properties indexRow indexColumn to the values of indices from the array where the player is located method
    
    private func setPositionPlayer() {
        
        for (indexRow, valueRow) in desktop.enumerated() {
            
            for (indexColumn, valueColumn) in valueRow.enumerated() {
                
                if valueColumn == Actors.PLAYER.rawValue {
                    
                    self.indexRow = indexRow
                    self.indexColumn = indexColumn
                    
                }
            }
            
        }
        
    }
    
    // MARK: Assigning to a 2D target array, a 2D array with target locations method
    
    private func setPositionTarger() {
        
        for (indexRow, valueRow) in desktop.enumerated() {
            
            for (indexColumn, valueColumn) in valueRow.enumerated() {
                
                if valueColumn == Actors.TARGET.rawValue {
                    
                    desktopTargetArray[indexRow][indexColumn] = Actors.TARGET.rawValue
                } else {
                    
                    desktopTargetArray[indexRow][indexColumn] = Actors.FLOOR.rawValue
                }
                
            }
        }
    }
    
    // MARK: Сheck for the absence of a target in the cells where there should be a target instead of zero method
    
    private func checkAndPutTarget() {
        
        for (indexRow, valueRow) in desktop.enumerated() {
            
            for (indexColumn, valueColumn) in valueRow.enumerated() {
                
                if desktopTargetArray[indexRow][indexColumn] == Actors.TARGET.rawValue && valueColumn == Actors.FLOOR.rawValue {
                    
                    desktop[indexRow][indexColumn] = Actors.TARGET.rawValue
                }
                
            }
            
        }
    }
    
    // MARK: Checking for a win in the current level
    
    private func checkForWinnings() {
        var countTarget = 0
        var countBoxOnTarget = 0
        
        for (indexRow, valueRow) in desktopTargetArray.enumerated() {

            for (indexColumn, valueColumn) in valueRow.enumerated() where valueColumn == Actors.TARGET.rawValue {
                
                countTarget += 1
                
                if desktop[indexRow][indexColumn] == Actors.BOX.rawValue {
                    countBoxOnTarget += 1

                }
                
            }
        }
        
        if countTarget == countBoxOnTarget {

            viewer.alertWinLevel()
        }
        
    }
    
    // MARK: Restart current level
    
    internal func updateCurrentLevel() {
        
        desktop = levels.getCurrentLevel()
        desktopTargetArray = desktop
        
        setPositionPlayer()
        setPositionTarger()
        
        viewer.update()
        
        printDesktop()
    }
    
    // MARK: Next level
    
    internal func getNextLevel() {
        
        levels.changeNextLevel()
    }
    
}
extension Model : LevelDelegate {
    
    internal func didGetError(error: SocketErrors) {
        self.viewer.didGetListOfLevelsName(levelsName: (self.getAllLevelsName()))
        viewer.alertErrorMessage(errorMessage: error)
    }
    
    internal func didGetLevel() {
        updateCurrentLevel()
    }
    
    internal func didGetListOfLevelNames() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.viewer.didGetListOfLevelsName(levelsName: (self?.getAllLevelsName()) ?? [])
        }
    }
}
