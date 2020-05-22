//
//  OTMNetworkController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation


class OTMNetworkController {
    
    private enum Endpoint {
        static let base = "https://onthemap-api.udacity.com/v1/"
        static let studentLocation = "StudentLocation?"
        static let session = "session"
        
        //student location endpoints
        case locationForStudent(key: String)
        case studentLocations(limitedTo: Int, skipping: Int)
        
        //user session endpoint
        case userSession
        
        //computed URL
        var url: URL {
            return URL(string: stringURL)!
        }
        
        //computed stringURL
        var stringURL: String {

            switch self {
                
            //student location api urls
            case .studentLocations(let limit, let skip):
                return Endpoint.base + Endpoint.studentLocation + "limit=\(limit)&skip=\(skip)"
            
            case .locationForStudent(let key):
                return Endpoint.base + Endpoint.studentLocation + "uniqueKey=\(key)"
                
            //user session api urls
            case .userSession:
                return Endpoint.base + Endpoint.session
            }
            
        }
    }
    
    
    //MARK:- Session Management Methods
    class func createUserSession(using credentials: UserCredentials, completion: @escaping (Result <SessionResponse, OTMError>) -> Void) {
        
        var request = URLRequest(url: Endpoint.userSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //create POSTSession object
        let bodyData = PostSession(credentials: credentials)

        //Perform POST Request
        do {
            request.httpBody = try JSONEncoder().encode(bodyData)

        //handle object JSON encoding error
        } catch {
            print("POST Error! Encoding POSTSession object failed,")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //handle random network error
            if let error = error {
                completion(.failure(.unableToComplete))
                print("POST Error! Could not create user session. Reason: \(error.localizedDescription)")
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
                    completion(.failure(.invalidResponse))
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
                
            //handle bad data returned
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    //MARK:- Student Location Methods
    class func getStudentLocations(with limit: Int, skipItems: Int, completion: @escaping (Result <StudentLocations, OTMError>) -> Void) {
        
        let request = URLRequest(url: Endpoint.studentLocations(limitedTo: limit, skipping: skipItems).url)
        print("getStudentLocations Url: \(request)") //for debugging
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //handle random network error
            if let error = error {
                completion(.failure(.unableToComplete))
                print("GET Error! Could not fetch Student Locations. Reason: \(error.localizedDescription)")
            }
            
            //bad http response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
                completion(.failure(.invalidResponse))
                return
            }
            
            //bad data returned, or alternate message like api rate limit exceeded
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let locations = try decoder.decode(StudentLocations.self, from: data)
                completion(.success(locations))
                
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }

    
    class func postStudentLocation(object: StudentInformation) {
        
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
