//
//  OTMNetworkController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation


enum Auth {
    case username(email: String)
    case password(String)
}

class OTMNetworkController {
    
    private enum Endpoint {
        static let base = "https://onthemap-api.udacity.com/v1/"
        static let studentLocation = base+"StudentLocation"
        static let session = base+"session"
        static let resultsLimit = 50
        
        
        //session
        
        
        
        //student location
        case limitResults(to: Int)
        case skip(items: Int)
        case uniqueKey(String)
        
        
        //computed URL
        var url: URL {
            return URL(string: stringURL)!
        }
        
        
        //computed stringURL
       var stringURL: String {
            var components = URLComponents()

            switch self {
            case .limitResults:
                let queryItem = URLQueryItem(name: "limit", value: "\(Endpoint.limitResults(to: Endpoint.resultsLimit))")
                components.queryItems?.append(queryItem)
                
                return Endpoint.studentLocation + components.query!
                
                
            case .skip(let items):
                let limitQueryItem = URLQueryItem(name: "limit", value: "\(Endpoint.limitResults(to: Endpoint.resultsLimit))")
                 components.queryItems?.append(limitQueryItem)
                
                 let skipQueryItem = URLQueryItem(name: "skip", value: "\(Endpoint.skip(items: items))")
                 components.queryItems?.append(skipQueryItem)
                
                 return Endpoint.studentLocation + components.query!
                
            case .uniqueKey(let key):
                let queryItem = URLQueryItem(name: "uniqueKey", value: "\(Endpoint.uniqueKey(key))")
                components.queryItems?.append(queryItem)
                return Endpoint.studentLocation + components.query!
            }
        }
    }
    
    
    //MARK:- Session Management Methods
    class func createUserSession(using credentials: UserCredentials, completion: @escaping (SessionResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: Endpoint.session)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //POST Request
        let data = PostSession(credentials: credentials)

        do {
            request.httpBody = try JSONEncoder().encode(data)

        //handle object JSOSN encoding error
        } catch {
            print("Error! Encoding user session object failed,")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
           
            //capture server response details for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("Remote server reponded with status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Error! Remote server did not pass back any JSON data.")
                    completion(nil, error)
                }
                return
            }
              
            //POST Request Response
            //decode JSON Response object
            let decoder = JSONDecoder()
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            do {
                let sessionObject = try decoder.decode(SessionResponse.self, from: newData)
                
                DispatchQueue.main.async {
                    print("Success! UserSession created.")
                    completion(sessionObject, nil)
                }
                
            //handle server response decoode erroor
            } catch {
                
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        print("Error! Could not create UserSession. Reason: \(errorResponse).")
                        completion(nil, errorResponse)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        print("Error! Could not create UserSession. Failed to decode Error Response. Reason: \(error).")
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
    //MARK:- Student Location Methods
    class func getStudentLocations() {
        
        let url = URL(string: "")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
              if error != nil { // Handle error...
                  return
              }
              print(String(data: data!, encoding: .utf8)!)
        }
        
        task.resume()
    }

    
    class func postStudentLocation(object: StudentLocation) {
        
        let url = URL(string: "")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
              if error != nil { // Handle error…
                  return
              }
              print(String(data: data!, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    
    
    
    
    
    
    
    
        
        
    
    
    
    
}
