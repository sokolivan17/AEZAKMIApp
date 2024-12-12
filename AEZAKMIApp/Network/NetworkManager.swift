//
//  NetworkManager.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 05.12.2024.
//

import UIKit

enum Method: String {
    case get = "GET"
    case post = "POST"
}

class CustomError: Error {
    let message: String
    
    init(message: String) {
        self.message = message
    }
}

final class NetworkManager {
    
    private let urlString = Endpoints.all
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private lazy var urlSession: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForResource = 120
        session.configuration.timeoutIntervalForRequest = 120
        session.configuration.waitsForConnectivity = true
        return session
    }()
    
    private var dataTask: URLSessionDataTask? = nil
    private let jsonDecoder = JSONDecoder()
    
    private init() { }
    
    public func loadCountries(completion: @escaping(Result<[Country], Error>) -> Void) {
        self.request(urlString: urlString, completion: completion)
    }
    
    private func request<T: Decodable>(urlString: String, method: Method = .get, completion: @escaping(Result<T, Error>)->Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(CustomError(message: "Url is not correct.")))
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        self.dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            guard let self = self else {
                completion(.failure(CustomError(message: "Get error while unwrapping self.")))
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            if let data = data {
                if let content = try? self.jsonDecoder.decode(T.self, from: data) {
                    DispatchQueue.main.async {
                        completion(.success(content))
                    }
                }
            }
        })
        self.dataTask?.resume()
    }
    
    public func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        let placeholder = UIImage(systemName: "flag")

        if let image = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                completed(image)
            }
            return
        }

        guard let url = URL(string: urlString) else {
            completed(placeholder)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                    error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(placeholder)
                return
            }

            self.cache.setObject(image, forKey: cacheKey)

            DispatchQueue.main.async {
                completed(image)
            }
        }

        task.resume()
    }
}
