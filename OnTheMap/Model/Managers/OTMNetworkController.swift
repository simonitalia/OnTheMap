//
//  OTMNetworkController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

class OTMNetworkController {
    
    //accessible class properties
    static var shared = OTMNetworkController()
    
    enum httpMethod: String {
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }
    
    
    //private class propeeties
    private enum Endpoint {
        
        //url components
        enum URLComponent {
            static let scheme = "https"
            static let host = "onthemap-api.udacity.com"
        }
        
        //api endpoint paths
        enum URLPath {
            static let studentLocation = "/v1/StudentLocation"
            static let session = "/v1/session"
        }
        
        //api endpoint query items
        enum QueryItem {
            static let limit = "limit"
            static let skip = "skip"
            static let order = "order"
            static let uniqueKey = "uniqueKey"
        }
        
        //user session endpoint paramters
        case userSession
        
        //get student location endpoint parameters
        case locationForStudent(key: String)
        case studentLocations(limitedTo: Int, skipping: Int)
        
        //posting sudent location endpoint paramters
        case studentLocation //post new location
        case studentLocationUpdate(objectID: String) //update existing location
        
        
        //compute api enpoint URL
        var url: URL? {
            
            switch self {
                
            //user session api urls
            case .userSession:
                return self.getURLComponents(appendingWith: URLPath.session).url
            
            //student location endpoint + query items
            case .studentLocations(let limit, let skip):
                var components = self.getURLComponents(appendingWith: URLPath.studentLocation)
                components.queryItems = [
                    URLQueryItem(name: QueryItem.limit, value: "\(limit)"),
                    URLQueryItem(name: QueryItem.skip, value: "\(skip)"),
                    URLQueryItem(name: QueryItem.order, value: "-updatedAt") //desc, newest first order
                ]
                
                return components.url
  
            //unique student endpoint + query items
            case .locationForStudent(let key):
                var components = self.getURLComponents(appendingWith: URLPath.studentLocation)
                components.queryItems = [
                    URLQueryItem(name: QueryItem.uniqueKey, value: "\(key)")
                ]
                
                return components.url
                
            //post new student location endpoint
            case .studentLocation:
                return self.getURLComponents(appendingWith: URLPath.studentLocation).url
            
             
            //update existing student location enpoint
            case .studentLocationUpdate(let objectID):
                return self.getURLComponents(appendingWith: URLPath.studentLocation+"/\(objectID)").url
            }
            
        }
        
        //construct base URL from url components
        func getURLComponents(appendingWith path: String) -> URLComponents {
            var components = URLComponents()
            components.scheme = URLComponent.scheme
            components.host = URLComponent.host
            components.path = path
            return components
        }
    }
    
    
    //MARK:- Session Management Requests
    //GET Session
    func getUserSession(using credentials: UserCredentials, completion: @escaping (Result <UserSession, OTMErrorResponse>) -> Void) {
        
        //safely check url enpoint can be constructed
        guard let url = Endpoint.userSession.url else {
            print(OTMErrorResponse.inavlidAPIEndpointURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //create POSTSession object
        let bodyData = POSTSession(credentials: credentials)

        //Perform POST Request
        do {
            request.httpBody = try JSONEncoder().encode(bodyData)

        //handle object JSON encoding error
        } catch {
            completion(.failure(.unableToParseJSON))
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //handle general (eg: network) error
            if let error = error {
                completion(.failure(.unableToComplete))
                print("POST Error! Could not create user session. Reason: \(error.localizedDescription)")
                return
            }
           
            //handle failed http response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                
                //catch error response code
                switch httpResponse.statusCode {
                
                //wrong credentials error
                case 403:
                    completion(.failure(.invalidCredentials))
                    return
                
                //server side or other client error
                default:
                    completion(.failure(.invalidResponse))
                    return
                }
            }
            
            //process data Response
            //handle no data returned
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
              
            //decode JSON Data Response object
            let decoder = JSONDecoder()
            
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let userSession = try decoder.decode(UserSession.self, from: newData)
                completion(.success(userSession))
                
            //handle bad data returned
            } catch {
                completion(.failure(.unableToParseJSON))
            }
        }
        
        task.resume()
    }
    
    //DELETE User Session
    func deleteUserSession(completion: @escaping (Result<DELETESession, OTMErrorResponse>) -> Void) {
        
        //safely check url enpoint can be constructed
        guard let url = Endpoint.userSession.url else {
            print(OTMErrorResponse.inavlidAPIEndpointURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.delete.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = AppDelegate.userSession?.session //set body to userSession object
        
        //Perform POST Request
        do {
            request.httpBody = try JSONEncoder().encode(bodyData)

        //handle object JSON encoding error
        } catch {
            completion(.failure(.unableToParseJSON))
        }
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }

        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //handle general (eg: network) error
            if let error = error {
                completion(.failure(.unableToComplete))
                print("Error! Could not log user out Reason: \(error.localizedDescription)")
                return
            }

            //bad http response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            //handle no data returned
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
          
            //decode JSON Data Response object
            let decoder = JSONDecoder()
            
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let deleteSession = try decoder.decode(DELETESession.self, from: newData)
                completion(.success(deleteSession))
                
            } catch {
                completion(.failure(.unableToParseJSON))
            }
        }
        
        task.resume()
    }
    
    
    //MARK:- Student Location Requests
    //get student locations
    func getStudentLocations(with limit: Int, skipItems: Int, completion: @escaping (Result <StudentLocations, OTMErrorResponse>) -> Void) {
        
        //safely check url enpoint can be constructed
        guard let url = Endpoint.studentLocations(limitedTo: limit, skipping: skipItems).url else { print(OTMErrorResponse.inavlidAPIEndpointURL)
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //handle general (eg: network) error
            if let error = error {
                completion(.failure(.unableToComplete))
                print("GET Error! Could not fetch Student Locations. Reason: \(error.localizedDescription)")
                return
            }
            
            //bad http response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
                completion(.failure(.invalidResponse))
                return
            }
            
            //no data returned
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            //handle successful response
            do {
                let decoder = JSONDecoder()
                let locations = try decoder.decode(StudentLocations.self, from: data)
                completion(.success(locations))
                
            } catch {
                completion(.failure(.unableToParseJSON))
            }
        }
        
        task.resume()
    }

    
    //submit student locations
    func submitStudentLocation(as httpMethod: httpMethod, with studentLocation: POSTStudentLocation, objectID: String?, completion: @escaping (Result <StudentLocation, OTMErrorResponse>) -> Void) {
        
        var requestURL: URLRequest? {
        
            //generat url endpoint based on submit type
            switch httpMethod {
            case .post:
                
                //safely generate url endpoint
                if let url = Endpoint.studentLocation.url {
                     return URLRequest(url: url)
                }
        
            case .put:
                //make sure a student location object exists
                guard let objectId = objectID else { return nil }
                
                //safely generate url endpoint
                if let url = Endpoint.studentLocationUpdate(objectID: objectId).url {
                    return URLRequest(url: url)
                }
          
            default:
                print("Error! httpMethod for submitting Student Location is unknown")
            }
            
            return nil // in cases url cannot be generated
        }
        
        //ensure valid request url
        guard var request = requestURL else {
            print(OTMErrorResponse.inavlidAPIEndpointURL)
            return
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.rawValue
        
        let bodyData = studentLocation //set body to studentLocation
        
        //Perform POST Request
        do {
            request.httpBody = try JSONEncoder().encode(bodyData)

        //handle object JSON encoding error
        } catch {
            completion(.failure(.unableToParseJSON))
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
             
        //handle general (eg: network) error
            if let error = error {
                completion(.failure(.unableToComplete))
                print("Error! Could not log user out Reason: \(error.localizedDescription)")
                return
            }

            //bad http response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            //handle no data returned
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
          
            //decode JSON Data Response object
            let decoder = JSONDecoder()
            
            do {
                let studentLocation = try decoder.decode(StudentLocation.self, from: data)
                completion(.success(studentLocation))
                
            } catch {
                completion(.failure(.unableToParseJSON))
            }
        }
        
        task.resume()
    }
    
    
    //generic method for task object
    private func taskForRequest<Response: Decodable>(_ request: URLRequest, completion: @escaping (Result <Response, OTMErrorResponse>) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
             
        //handle general (eg: network) error
            if let error = error {
                completion(.failure(.unableToComplete))
                print("Error! Could not log user out Reason: \(error.localizedDescription)")
                return
            }

            //bad http response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            //handle no data returned
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
          
            //decode JSON Data Response object
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(Response.self, from: data)
                completion(.success(response))
                
            } catch {
                completion(.failure(.unableToParseJSON))
            }
        }
        
        task.resume()
        return task
    }
}
