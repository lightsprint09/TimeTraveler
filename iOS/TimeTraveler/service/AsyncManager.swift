//
//  AsyncManager.swift
//  TrainScheduleModel
//
//  Created by Lukas Schmidt on 23.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

class AsyncManager<ResultType, ErrorType> {
    var results = Array<ResultType>()
    var errors = Array<ErrorType>()
    var executed = 0 {
        didSet {
            if executed == count {
                didFinishCallback(results, errors)
            }
        }
    }
    
    let count: Int
    let didFinishCallback:([ResultType], [ErrorType])->Void
    
    init(count: Int, didFinishCallback: ([ResultType], [ErrorType])->Void) {
        self.count = count
        self.didFinishCallback = didFinishCallback
    }
    
    func addResult(result: ResultType) {
        results.append(result)
        executed += 1
    }
    
    func addError(error: ErrorType) {
        errors.append(error)
        executed += 1
    }
    
}