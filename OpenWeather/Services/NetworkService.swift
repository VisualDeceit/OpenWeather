//
//  NetworkService.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 16.01.2021.
//

import Foundation

let appID = "4ca4dea9f4ea2a6b32316b43be21d3a9"

class NetworkService {

    var urlComponent: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.openweathermap.org"
        component.path = "/data/2.5/weather"
        component.queryItems = [URLQueryItem(name: "appid", value: appID),
                                URLQueryItem(name: "units", value: "metric"),]
        return component
    }()
  
    /*
    //через url
     func sendRequest(for city: String) {
        urlComponent.queryItems! += [URLQueryItem(name: "q", value: city)]
        if let url = urlComponent.url {
            let request = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json)
                }
                print("response - \n", response)
                print("error - \n", error)
            }
            request.resume()
        }
    }
*/
    
    //через request
    func sendRequest(for city: String) {
        urlComponent.queryItems! += [URLQueryItem(name: "q", value: city)]
        if let url = urlComponent.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json)
                }
               // print("response - \n", response)
                print("error - \n", error)
            }
            session.resume()
        }
    }
    
    //POST
    func sendPostRequest() {
        var postComponent = URLComponents()
        postComponent.scheme = "https"
        postComponent.host = "jsonplaceholder.typicode.com"
        postComponent.path = "/posts"
        postComponent.queryItems = [URLQueryItem(name: "title", value: "foo"),
                                    URLQueryItem(name: "body", value: "bar"),
                                    URLQueryItem(name: "userId", value: "1")]
        if let url = postComponent.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json)
                }
                print("response - \n", response)
                print("error - \n", error)
            }
            session.resume()
        }
    }
    
    //GET
    func sendGetRequest() {
        var postComponent = URLComponents()
        postComponent.scheme = "https"
        postComponent.host = "jsonplaceholder.typicode.com"
        postComponent.path = "/comments"
        postComponent.queryItems = [URLQueryItem(name: "postId", value: "10")]
        if let url = postComponent.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json)
                }
                print("response - \n", response)
                print("error - \n", error)
            }
            session.resume()
        }
    }
}
