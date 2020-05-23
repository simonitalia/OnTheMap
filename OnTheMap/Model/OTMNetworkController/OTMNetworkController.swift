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
        
        //student location endpoint parameters
        case locationForStudent(key: String)
        case studentLocations(limitedTo: Int, skipping: Int)
        
        //compute api enpoint URL
        var url: URL? {
            
            switch self {
                
            //student location endpoint + query items
            case .studentLocations(let limit, let skip):
                var components = self.getURLComponents(with: URLPath.studentLocation)
                components.queryItems = [
                    URLQueryItem(name: QueryItem.limit, value: "\(limit)"),
                    URLQueryItem(name: QueryItem.skip, value: "\(skip)"),
                    URLQueryItem(name: QueryItem.order, value: "-updatedAt")
                ]
                
                return components.url
  
            //unique student endpoint + query items
            case .locationForStudent(let key):
                var components = self.getURLComponents(with: URLPath.studentLocation)
                components.queryItems = [
                    URLQueryItem(name: QueryItem.uniqueKey, value: "\(key)")
                ]
                
                return components.url
                
            //user session api urls
            case .userSession:
                return self.getURLComponents(with: URLPath.session).url
            }
        }
        
        //construct base URL from url components
        func getURLComponents(with path: String) -> URLComponents {
            var components = URLComponents()
            components.scheme = URLComponent.scheme
            components.host = URLComponent.host
            components.path = path
            return components
        }
    }
    
    
    //MARK:- Session Management Methods
    class func createUserSession(using credentials: UserCredentials, completion: @escaping (Result <SessionResponse, OTMError>) -> Void) {
        
        //safely check url enpoint can be constructed
        guard let url = Endpoint.userSession.url else { return }
        
        var request = URLRequest(url: url)
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
        
        //safely check url enpoint can be constructed
        guard let url = Endpoint.studentLocations(limitedTo: limit, skipping: skipItems).url else { return }
        
        let request = URLRequest(url: url)
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
