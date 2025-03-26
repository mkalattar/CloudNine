//
//  NetworkPathManager.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import Network

struct NetworkPathManager {
    let monitor: NWPathMonitor
    let queue = DispatchQueue(label: "Monitor")
    
    var noConnectivityAction: () -> Void = {}
    
    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                self.noConnectivityAction()
            }
        }
        
        monitor.start(queue: queue)
    }
}
