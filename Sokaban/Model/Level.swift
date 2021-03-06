//
//  Levels.swift
//  Sokaban
//
//  Created by Nurseit Akysh on 11/11/20.
//

import Foundation

internal protocol LevelDelegate: class {
    
    func didGetListOfLevelNames()
    func didGetLevel()
    func didGetError(error:SocketErrors)
}

internal class Level {
    private var currentLevel: [[Int]]
    private var currentLevelName: String
    private let clientServer: ClientServer
    private var listOfLevelsServer: [String]
    
    internal weak var delegate: LevelDelegate?
    
    init() {
        
        clientServer = ClientServer(host: "194.152.37.7", port: 5432, messageEncoding: .isoLatin1)
        
        currentLevel = []
        currentLevelName = ""
        currentLevelName = "Level 1"
        listOfLevelsServer = [String]()
        currentLevel = getListLevels()["Level 1"]!
        
        // MARK: Recieve list of levels name or level map from ClientServer
        
        clientServer.didRecieveMessage = { message in
            let endOfMessageIndex       = message.index(of: ServerResponse.endOfFile.responseString)
                        
            var cleanMessage            = message[..<(endOfMessageIndex ?? message.endIndex)]
            cleanMessage.append("\n")

            if message.contains(ServerResponse.gotListOfLevels.responseString) {
                self.didGetListOfLevel(listOfLevel: cleanMessage)
            }
            
            else if message.contains(ServerResponse.gotLevel.responseString) {
                self.didGetLevel(levelMessage: cleanMessage)
            }
            
        }
        
        // MARK: Recieve level error from ClientServer
        
        clientServer.didRecieveError = { error in
            self.listOfLevelsServer.removeAll()
            
            if error as? SocketErrors == SocketErrors.serverDisconnected || error as? SocketErrors == SocketErrors.serverIsOffline {

                self.delegate?.didGetError(error: error as! SocketErrors)
            }

        }
        
        // MARK: Observe connect completed from ClientServer
        
        clientServer.connectionCompleted = { [weak self] in

            DispatchQueue.global(qos: .userInitiated).async {
                
                self?.getListOfLevelsNameFromServer()
            }
        }
        
        
        
    }
    
    internal func getCurrentLevel() -> [[Int]]{
        
        return currentLevel
    }
    
    internal func getCurrentLevelName() -> String {
        return currentLevelName
    }
    
    private func didGetListOfLevel(listOfLevel: Substring) {
        
        var cleanMessage = listOfLevel
        let startOfMessage = cleanMessage.index(of: ServerResponse.gotListOfLevels.responseString)
        
        cleanMessage = cleanMessage[startOfMessage!..<cleanMessage.endIndex]
        
        var listOfLevelsOnOneLine = cleanMessage.replacingOccurrences(of: ServerResponse.gotListOfLevels.responseString, with: "")
        
        listOfLevelsOnOneLine = listOfLevelsOnOneLine.replacingOccurrences(of: "[", with: "")
        
        var row: String = ""
        
        for character in listOfLevelsOnOneLine {
            if character.isNewline {
                if row != "" {
                    let clearRow = row.replacingOccurrences(of: ".sok", with: "", options: NSString.CompareOptions.literal, range: nil)
                    listOfLevelsServer.append(clearRow)
                    
                    row = ""
                }
            }
                    
                else {
                    
                    row.append(character)
                }
        }
                
        listOfLevelsServer.sort { $0 < $1 }

        delegate?.didGetListOfLevelNames()
    }
    
    private func didGetLevel(levelMessage: Substring) {
        
        var cleanMessage = levelMessage
        let startOfMessage = cleanMessage.index(of: ServerResponse.gotLevel.responseString)
        cleanMessage = cleanMessage[startOfMessage!..<cleanMessage.endIndex]
        
        let levelString = cleanMessage.replacingOccurrences(of: ServerResponse.gotLevel.responseString, with: "")
        
        currentLevel = Helpers.parserTextFrom(content: levelString)
        
        delegate?.didGetLevel()
    }
    
    // MARK: Get all list levels name from local, files and server files
    
    internal func getListLevelsName() -> [String]{
        let localLevel =  getListLevels().keys
        let nameLevelsLocal = getListFilesNameLevel()
        var resultLevelsName = [String]()
        
        resultLevelsName = resultLevelsName + localLevel + nameLevelsLocal + listOfLevelsServer
        
        return resultLevelsName.sorted()
    }
    
    // MARK: Сhange the current level to the selected level
    
    internal func pickLevel(levelName: String) throws {
        currentLevel = []
        currentLevelName = levelName
        
        if let levelLocal = getListLevels()[levelName] {
            
            currentLevel += levelLocal
            
        } else if let contentLevelFileLocal = try readTextFile(fileName: levelName) {
            
            let levelFileLocal = Helpers.parserTextFrom(content: contentLevelFileLocal)
            
            currentLevel += levelFileLocal
            
        } else {
            
            getLevelFromServer(levelName: levelName)
        }
        
    }
    
    // MARK: Get list local levels map
    
    private func getListLevels() -> [String: [[Int]]] {
        
        let listLevels: [String: [[Int]]] =
            ["Level 1": [
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                    [2, 0, 0, 0, 0, 0, 0, 2, 2, 2],
                    [2, 0, 0, 0, 0, 0, 0, 2, 2, 2],
                    [2, 0, 0, 2, 1, 0, 0, 0, 2, 2],
                    [2, 0, 0, 2, 4, 2, 0, 0, 0, 2],
                    [2, 2, 0, 2, 2, 2, 2, 0, 2, 2],
                    [2, 0, 0, 0, 0, 2, 2, 0, 0, 2],
                    [2, 0, 0, 3, 0, 2, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                ],
            "Level 2": [
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                    [2, 2, 2, 0, 0, 0, 0, 0, 4, 2],
                    [2, 2, 2, 0, 0, 0, 2, 0, 2, 2],
                    [2, 0, 0, 0, 0, 0, 2, 2, 0, 2],
                    [2, 0, 3, 0, 1, 2, 0, 0, 0, 2],
                    [2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 2, 0, 3, 0, 0, 0, 2],
                    [2, 0, 2, 0, 0, 0, 0, 0, 0, 2],
                    [2, 4, 0, 2, 0, 0, 0, 0, 0, 2],
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                ],
            "Level 3": [
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                    [2, 2, 2, 2, 2, 0, 0, 0, 0, 2],
                    [2, 0, 2, 2, 0, 0, 0, 3, 0, 2],
                    [2, 0, 0, 0, 1, 0, 2, 2, 2, 2],
                    [2, 0, 0, 2, 0, 0, 0, 0, 0, 2],
                    [2, 0, 3, 2, 0, 0, 0, 0, 0, 2],
                    [2, 0, 0, 2, 2, 2, 2, 0, 2, 2],
                    [2, 2, 2, 2, 0, 0, 0, 0, 0, 2],
                    [2, 4, 4, 0, 0, 0, 0, 0, 0, 2],
                    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                ],
            ]
        
        return listLevels
    }
    
    // MARK: Reading from file content
    
    private func readTextFile(fileName: String) throws -> String? {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "sok")
        var content = String()
        
        guard filePath != nil else { return nil }
        
        do {
            content = try String(contentsOf: URL(fileURLWithPath: filePath!), encoding: .utf8)
           
        } catch ErrorFiles.NotFoundFile {
            
            print("Not find to select file")
        }
        
        return content
    }
    
    // MARK: Get list levels name from file
    
    private func getListFilesNameLevel() -> [String] {
        
        return Bundle.main.paths(forResourcesOfType: "sok", inDirectory: nil).map { (file) -> String in
            
            return URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        }
    }
    
    // MARK: Сhange the current level to the next level in turn
    
    internal func changeNextLevel() {
        let listLevelsName = getListLevelsName()
        
        for (index, valueLevel) in listLevelsName.enumerated() where valueLevel == currentLevelName  {
             
            do {
                
                try pickLevel(levelName: listLevelsName[index + 1])
                
            } catch ErrorLevels.notFoundLevel {
                
                print("Not found next level")
            } catch {
                
                print(error)
            }
        }
        
    }
    
    // MARK: Get list levels name from server
    
    private func getListOfLevelsNameFromServer() {
        
        clientServer.sendMessage(message: ServerRequests.getListOfLevels.requestString)
    }
    
    // MARK: Get level map with selected level from server
    
    private func getLevelFromServer(levelName: String) {
        
        clientServer.sendMessage(message: ServerRequests.getLevel(levelName: levelName + ".sok").requestString)
    }
}

fileprivate enum ServerRequests {
    
    case getListOfLevels
    case getLevel(levelName: String)
    
    var requestString: String {
        
        switch self {
            
            case .getListOfLevels           : return "GET_LIST_OF_LEVELS"
            case .getLevel(let levelName)   : return "GET_LEVEL: " + levelName
        }
    }
}

fileprivate enum ServerResponse {
    
    case gotListOfLevels
    case gotLevel
    case endOfFile
    
    var responseString: String {
        
        switch self {
            
            case .gotListOfLevels: return "GOT_LIST_OF_LEVELS: "
            case .gotLevel: return "GOT_LEVEL: "
            case .endOfFile: return "END_OF_MESSAGE"
        }
    }
}
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
}
