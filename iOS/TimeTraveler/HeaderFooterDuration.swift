//
//  HeaderFooterDuration.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 06.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class HeaderFooterDuration: DurationPoint {
    var duration: NSTimeInterval = 0
    let name: String
    var subtitle: String?
    
    var targetDate: NSDate!
    var passed = false
    
    let image: UIImage
    
    let tabelCellID = "headerFooter"
    
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    func asyncResolve(onSucess: (NSTimeInterval) -> (), onError: (JSONFetcherErrorType) -> ()) {
        onSucess(duration)
    }
    
    
}
