//
//  Levels.swift
//  Sokaban
//
//  Created by Nurseit Akysh on 11/11/20.
//

import Foundation

internal class Level {
    private var currentLevel: [[Int]]
    private var currentLevelName: String
    
    init() {
        currentLevel = []
        currentLevel = getListLevels()["Level 1"]!
        
    }
    
    internal func getCurrentLevel() -> [[Int]]{
        return currentLevel
    }
    internal func getCurrentLevelName(levelName:String) {
        if levelName != "" {
            <#code#>
        }
    }
    
    internal func getListLevelsName() -> [String]{
        let localLevel =  getListLevels().keys
        var resultLevelsName = [String]()
        let nameLevelsLocal = getListFilesNameLevel()
        
        resultLevelsName = resultLevelsName + localLevel + nameLevelsLocal
        return resultLevelsName.sorted()
    }
    
    internal func pickLevel(levelName: String) throws {
        currentLevel = []
        
        if let levelLocal = getListLevels()[levelName] {
            currentLevel += levelLocal
        } else if let contentLevelFileLocal = try readTextFile(fileName: levelName) {
            let levelFileLocal = Helpers.parserTextFrom(content: contentLevelFileLocal)
            
            currentLevel += levelFileLocal
        } else {
            print("Not find file from selected")
        }
        
    }
    
    private func getListLevels() -> [String: [[Int]]] {
        let listLevels: [String: [[Int]]] =
            ["Level 1": [
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 1, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 3, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 4, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                ],
            "Level 2": [
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 1, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 3, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 4, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 4, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 3, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                ],
            "Level 3": [
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 1, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 3, 0, 0, 0, 0, 2],
                    [2, 0, 3, 4, 4, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                ],
            ]
        
        return listLevels
    }
    
    private func readTextFile(fileName: String) throws -> String? {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "sok")
        var content = String()
        
        //reading
        do {
            content = try String(contentsOf: URL(fileURLWithPath: filePath!), encoding: .utf8)
           
        } catch ErrorFiles.NotFoundFile {
            
            print("Not find to select file")
        }
        return content
    }
    
    func getListFilesNameLevel() -> [String] {
        
        return Bundle.main.paths(forResourcesOfType: "sok", inDirectory: nil).map { (file) -> String in
            return URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        }
    }

    
}
