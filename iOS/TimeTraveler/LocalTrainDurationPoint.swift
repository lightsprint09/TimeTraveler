//
//  LocalTrainDurationPoint.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 06.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

class LocalTrainDurationPoint: DurationPoint {
    var duration: NSTimeInterval {
        return rmvTrip.duration!
    }
    
    let name =  "Zugfahrt zum Flughafen"
    var subtitle: String?
    
    let tabelCellID = "standardtcell"
    let rmvTrip: RMVTrip
    
    
    init(rmvTrip: RMVTrip) {
        self.rmvTrip = rmvTrip
    }
    
    func asyncResolve(onSucess: (NSTimeInterval) -> (), onError: (JSONFetcherErrorType) -> ()) {
        onSucess(duration)
    }
}
