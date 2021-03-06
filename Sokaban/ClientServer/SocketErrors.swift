//
//  ErrorNetwork.swift
//  Sokaban
//
//  Created by Nurseit Akysh on 11/18/20.
//

import Foundation

enum SocketErrors: Error {
    
    case errorWithRecievingMessage
    case serverIsOffline
    case serverDisconnected
}

