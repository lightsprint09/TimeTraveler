//
//  JSONFetcher.swift
//  DBFahrplanAPI
//
//  Created by Lukas Schmidt on 01.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

public enum JSONFetcherErrorType: ErrorType {
    case Parse(String)
    case Network(String, NSError?)
}

public protocol JSONParsable {
    init(JSON: Dictionary<String, AnyObject>)
}

protocol JSONFetching {
    /**
     Fetches data from an url conatining a list of JSON objects and parses it in a array of objects conforming JSONParsable
     
     - parameter url:         url to fetch the data from
     - parameter JSONKeyPath: keypath to optionally query into JSON object
     - parameter onSucess:    sucess callback
     - parameter onError:     error callback which passes JSONFetcherErrorType
     
     - returns: <#return value description#>
     */
    func loadArray<T: JSONParsable>(url: NSURL, onSucess: (Array<T>)->(), onError: (JSONFetcherErrorType)->())
    
    
    func loadList<T: JSONParsable>(url: NSURL, JSONKeyPath: String, onSucess: (Array<T>)->(), onError: (JSONFetcherErrorType)->())
    
    func loadObject<T: JSONParsable>(url: NSURL, JSONKeyPath: String, onSucess: (T)->(), onError: (JSONFetcherErrorType)->())
}

protocol JSONParsering {
    /**
     Parses NSData conatining a list of JSON objects in a array of objects conforming JSONParsable
     
     - parameter data:        data wich contains json. Toplevel JSON must be an object not an array
     - parameter JSONKeyPath: search path into JSON object for extracting result
     
     - throws: throws if JSON parsing failed
     
     - returns: a list of objects parsed from JSON
     */
    func parseList<T: JSONParsable>(data: NSData, JSONKeyPath: String) throws -> Array<T>
    
    /**
     Parses NSData conatining a JSON object in an object conforming JSONParsable
     
     - parameter data:        data wich contains json. Toplevel JSON must be an object not an array
     - parameter JSONKeyPath: search path into JSON object for extracting result
     
     - throws: throws if JSON parsing failed
     
     - returns: a object parsed from JSON
     */
    func parseObject<T: JSONParsable>(data: NSData, JSONKeyPath: String) throws -> T
    
    /**
     Parses NSData conatining a JSON object to an object of a Foundation Collection
     
     - parameter data:        data wich contains json. Toplevel JSON must be an object not an array
     - parameter JSONKeyPath: search path into JSON object for extracting result
     
     - throws: throws if JSON parsing failed
     
     - returns: a colection object parsed from JSON
     */
    func parseRawObject<T: CollectionType>(data: NSData, JSONKeyPath: String ) throws -> T
}

public struct JSONParser: JSONParsering{
    
    internal func parseRawObject<T: CollectionType>(data: NSData, JSONKeyPath: String ) throws -> T {
        guard let rootJSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary,
        let tagetJSON = rootJSON.valueForKeyPath(JSONKeyPath) as? T else {
            throw NSError(domain: "Worng type", code: 0, userInfo: nil)
        }
        return tagetJSON
    }
    
    public func parseList<T: JSONParsable>(data: NSData, JSONKeyPath: String) throws -> Array<T> {
        let jsonObjects = try parseRawObject(data, JSONKeyPath: JSONKeyPath) as Array<Dictionary<String, AnyObject>>
        let objects = jsonObjects.map{ jsonObj in
            return T(JSON: jsonObj)
        }
        
        return objects
    }
    
    public func parseObject<T: JSONParsable>(data: NSData, JSONKeyPath: String) throws -> T {
        let jsonObject = try parseRawObject(data, JSONKeyPath: JSONKeyPath) as Dictionary<String, AnyObject>
        return T(JSON: jsonObject)
    }
    
    public func parseArray<T: JSONParsable>(data: NSData) throws -> Array<T> {
        guard let rootJSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Array<Dictionary<String, AnyObject>> else{
                throw NSError(domain: "Worng type", code: 0, userInfo: nil)
        }
        let objects = rootJSON.map{ jsonObj in
            return T(JSON: jsonObj)
        }
        
        return objects
    }
}

public struct JSONFetcher: JSONFetching {
    private let urlSession: NSURLSession
    private let jsonParser: JSONParser = JSONParser()
    
    public init(urlSession: NSURLSession = NSURLSession.sharedSession()) {
        self.urlSession = urlSession
    }
    
    public func loadArray<T : JSONParsable>(url: NSURL, onSucess: (Array<T>) -> (), onError: (JSONFetcherErrorType) -> ()) {
        func onSuccess(data: NSData) {
            do {
                let obj = try jsonParser.parseArray(data) as Array<T>
                onSucess(obj)
            }
            catch {
                onError(.Parse("Error Parsing Data"))
            }
        }
        
        loadJSONData(url, onSucess: onSuccess, onError: onError)
    }
    
    public func loadList<T: JSONParsable>(url: NSURL, JSONKeyPath: String = "", onSucess: (Array<T>)->(), onError: (JSONFetcherErrorType)->()) {
        func onSuccess(data: NSData) {
            do {
                let obj = try jsonParser.parseList(data, JSONKeyPath: JSONKeyPath) as Array<T>
                onSucess(obj)
            }
            catch {
                onError(.Parse("Error Parsing Data"))
            }
        }
        
        loadJSONData(url, onSucess: onSuccess, onError: onError)
    }
    
    public func loadObject<T: JSONParsable>(url: NSURL, JSONKeyPath: String = "", onSucess: (T)->(), onError: (JSONFetcherErrorType)->()) {
        func onSuccess(data: NSData) {
            do {
               let obj = try jsonParser.parseObject(data, JSONKeyPath: JSONKeyPath) as T
                onSucess(obj)
            }
            catch {
                onError(.Parse("Error Parsing Data"))
            }
        }
        
        loadJSONData(url, onSucess: onSuccess, onError: onError)
    }
    
    
    private func loadJSONData(url: NSURL, onSucess: (NSData)->(), onError: (JSONFetcherErrorType)->()) {
        let request = NSURLRequest(URL: url)
        
        let task = urlSession.dataTaskWithRequest(request) {data, response, error in
            if let error = error {
                return onError(.Network("Network error", error))
            }
            guard let data = data else {
                return onError(.Network("Empty data result", error))
            }
            onSucess(data)
        }
        
        task.resume()
    }
    
    
}