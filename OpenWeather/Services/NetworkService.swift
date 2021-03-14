//
//  NetworkService.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 16.01.2021.
//

import Foundation
import Alamofire
import RealmSwift
import PromiseKit

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
 
    
    //promis
 /*
    func requestWeather(for city: String) -> Promise<[Weather]> {
        let host = "https://api.openweathermap.org"
        let path = "/data/2.5/forecast"
        let parameters: Parameters = [
            "q": city,
            "units": "metric",
            "appid": appID
        ]
        
        let promis = Promise<[Weather]> {resolver in
            Alamofire.request(host + path, method: .get, parameters: parameters).responseData{ (response) in
                switch response.result {
                case .success(let data):
                    do {
                        let weather = try JSONDecoder().decode(WeatherResponse.self, from: data).list
                        weather.forEach{$0.city = city}
                        resolver.fulfill(weather)
                        //self.saveWeatherData(weather, city)
                    }
                    catch {
                        resolver.reject(error)
                    }
                    
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
        return promis
    }
    */
    
    //PromiseKit/Alamofire
    func requestWeather(for city: String, on queue: DispatchQueue = .main) -> Promise<[Weather]> {
        let host = "https://api.openweathermap.org"
        let path = "/data/2.5/forecast"
        let parameters: Parameters = [
            "q": city,
            "units": "metric",
            "appid": appID
        ]
        
        return Alamofire.request(host + path, method: .get, parameters: parameters)
            .responseData()
            .map(on: queue) { (data, responsese) -> [Weather] in
                do {
                    let weathers = try JSONDecoder().decode(WeatherResponse.self, from: data).list
                    weathers.forEach{$0.city = city}
                    return  weathers
                }
                catch {
                    throw error
                }
            }
    }
    
    
 /*
     // OLD
     
     func requestWeather(for city: String) {
        let host = "https://api.openweathermap.org"
        let path = "/data/2.5/forecast"
        let parameters: Parameters = [
            "q": city,
            "units": "metric",
            "appid": appID
        ]
        Alamofire.request(host + path, method: .get, parameters: parameters).responseData{ (response) in
            switch response.result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: data).list
                    weather.forEach{$0.city = city}
                    self.saveWeatherData(weather, city)
                }
                catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
     */
    
    //сохранение погодных данных в Realm
    func saveWeatherData(_ weathers: [Weather],_ city: String) {
        // обработка исключений при работе с хранилищем
        do {
            // получаем доступ к хранилищу
            let realm = try Realm()
            // получаем город
            print(realm.configuration.fileURL ?? "")
            guard let city = realm.object(ofType: City.self, forPrimaryKey: city) else { return }
            // все старые погодные данные для текущего города
            let oldWeathers = city.weathers
            // начинаем изменять хранилище
            realm.beginWrite()
            // удаляем старые данные
            realm.delete(oldWeathers)
            // кладем все объекты класса погоды в хранилище
            city.weathers.append(objectsIn: weathers)
            // завершаем изменение хранилища
            try realm.commitWrite()
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
   /*
    //сохранение погодных данных в Realm
    func saveWeatherData(_ weathers: [Weather],_ city: String) {
        // обработка исключений при работе с хранилищем
        do {
            // получаем доступ к хранилищу
            let realm = try Realm()
            // получаем город
            print(realm.configuration.fileURL ?? "")
            guard let city = realm.object(ofType: City.self, forPrimaryKey: city) else { return }
            // все старые погодные данные для текущего города
            let oldWeathers = city.weathers
            // начинаем изменять хранилище
            realm.beginWrite()
            // удаляем старые данные
            realm.delete(oldWeathers)
            // кладем все объекты класса погоды в хранилище
            city.weathers.append(objectsIn: weathers)
            // завершаем изменение хранилища
            try realm.commitWrite()
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
    */
    
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
