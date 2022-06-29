//
//  SocketIOManager.swift
//  ExpressAssist
//
//  Created by Apple on 28/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SocketIO

class SocketHelper {
    static let shared = SocketHelper()
    var socket: SocketIOClient!

    let manager = SocketManager(socketURL: URL(string:"http://192.168.1.121:3000")!, config: [.log(true), .compress])

    private init() {
        socket = manager.defaultSocket
    }

    func connectSocket(completion: @escaping(Bool) -> () ) {
        disconnectSocket()
        socket.on(clientEvent: .connect) {[weak self] (data, ack) in
            print("socket connected")
            self?.socket.removeAllHandlers()
            completion(true)
        }
        socket.connect()
    }

    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }

    func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
            return true
        }
        return false

    }

    enum Events {

        case search

        var emitterName: String {
            switch self {
            case .search:
                return "emt_search_tags"
            }
        }

        var listnerName: String {
            switch self {
            case .search:
                return "filtered_tags"
            }
        }

        func emit(params: [String : Any]) {
            SocketHelper.shared.socket.emit(emitterName, params)
        }

        func listen(completion: @escaping (Any) -> Void) {
            SocketHelper.shared.socket.on(listnerName) { (response, emitter) in
                completion(response)
            }
        }

        func off() {
            SocketHelper.shared.socket.off(listnerName)
        }
    }
}
