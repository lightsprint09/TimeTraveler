//
//  FakeDurationPoint.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

class FakeDurationPoint: DurationPoint {
    var duration: NSTimeInterval
    let name: String
    var subtitle: String?
    
    init(name: String, duration: NSTimeInterval) {
        self.name = name
        self.duration = duration
    }
    
    func asyncResolve(onSucess: (NSTimeInterval) -> (), onError: (JSONFetcherErrorType) -> ()) {
        onSucess(duration)
    }
}