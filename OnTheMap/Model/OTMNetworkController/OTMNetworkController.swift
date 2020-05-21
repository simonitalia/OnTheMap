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
    class func createUserSession(using credentials: UserCredentials, completion: @escaping (Result <SessionResponse, OTMError>) -> Void) {
        
        var request = URLRequest(url: URL(string: Endpoint.session)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //create POSTSession object
        let bodyData = PostSession(credentials: credentials)

        //Perform POST Request
        do {
            request.httpBody = try JSONEncoder().encode(bodyData)

        //handle object JSON encoding error
        } catch {
            print("Error! Encoding POSTSession object failed,")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //handle random network error
            if let error = error {
                completion(.failure(.unableToComplete))
                print("Error! Could not create user session. Reason: \(error.localizedDescription)")
            }
           
            //handle failed http response
            if let httpResponse = response as? HTTPURLResponse  {
                
                //catch error response code
                switch httpResponse.statusCode {
                
                //client side error
                case 400, 403:
                    completion(.failure(.invalidCredentials))
                    return
                
                //server side error
                case 500:
                    completion(.failure(.invalidResposne))
                    return
                    
                default:
                    break
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
                let sessionObject = try decoder.decode(SessionResponse.self, from: newData)
                completion(.success(sessionObject))
                print("Success! UserSession created.")
                
            //handle bad data returned
            } catch {
                completion(.failure(.invalidData))
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
