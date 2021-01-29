//
//  NetworkService.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 16.01.2021.
//

import Foundation
import Alamofire
import RealmSwift

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
    
    // Alamofire
    func requestWeather(for city:String, complition: @escaping ([Weather]) -> Void) {
        let host = "https://api.openweathermap.org"
        let path = "/data/2.5/forecast"
        let parameters: Parameters = [
            "q": city,
            "units": "metric",
            "appid": appID
        ]
        AF.request(host + path, method: .get, parameters: parameters).responseData{ (response) in
            switch response.result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: data).list
                    self.saveWeatherData(weather)
                    complition(weather)
                }
                catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //сохранение погодных данных в Realm
    func saveWeatherData(_ weathers: [Weather]) {
        // обработка исключений при работе с хранилищем
        do {
            // получаем доступ к хранилищу
            let realm = try Realm()
            // начинаем изменять хранилище
            realm.beginWrite()
            // кладем все объекты класса погоды в хранилище
            realm.add(weathers)
            // завершаем изменения хранилища
            try realm.commitWrite()
            print(realm.configuration.fileURL ?? "")
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
    
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
            let session = URLSession.shared.dataTask(with: request) { (data, _, _) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json)
                }
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
            let session = URLSession.shared.dataTask(with: request) { (data, _, _) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json)
                }
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
            let session = URLSession.shared.dataTask(with: request) { (data, _, _) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json)
                }
            }
            session.resume()
        }
    }
}
