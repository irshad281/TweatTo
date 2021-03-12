//
//  ApiHelper.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import Foundation


extension URLSession {
    
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
    
}



class UserServiceAPI {
    
    public static let shared = UserServiceAPI()
    private init() {}
    
    private let urlSession = URLSession.shared
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    public func fetchUserList(since: Double, result: @escaping (Result<[User], APIServiceError>) -> Void) {
        let url = URL.init(string: "https://api.github.com/users?since=\(since)")!
        fetchResources(url: url, completion: result)
    }
    
    public func fetchUserDetail(username: String, result: @escaping (Result<UserDetails, APIServiceError>) -> Void) {
        let url = URL.init(string: "https://api.github.com/users/\(username)")!
        fetchResources(url: url, completion: result)
    }
    
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    DispatchQueue.main.async {
                        completion(.failure(.invalidResponse))
                    }
                    
                    return
                }
                do {
                    let values = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(values))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodeError))
                    }
                }
            case .failure(let _):
                DispatchQueue.main.async {
                    completion(.failure(.apiError))
                }
            }
        }.resume()
    }
    
    
}

