//
//  NetworkManager.swift
//  Weather
//
//  Created by Anil Reddy on 19/08/24.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}

typealias ResultHandler<T> = (Result<T, DataError>) -> Void

class NetworkManager {
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler
    
    init(networkHandler: NetworkHandler = NetworkHandler(),
         responseHandler: ResponseHandler = ResponseHandler()) {
        self.networkHandler = networkHandler
        self.responseHandler = responseHandler
    }
    
    func request<T: Codable>(modelType: T.Type, url: URL?, httpMethod:HttpMethodType, completion: @escaping ResultHandler<T>) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.value
        networkHandler.requestDataAPI(url: urlRequest) { result in
            switch result {
            case .success(let data):
                self.responseHandler.parseResonseDecode(
                    data: data,
                    modelType: modelType) { response in
                        switch response {
                        case .success(let mainResponse):
                            completion(.success(mainResponse)) // Final
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
}

class NetworkHandler {

    func requestDataAPI(
        url: URLRequest,
        completionHandler: @escaping (Result<Data, DataError>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completionHandler(.failure(.invalidResponse))
                return
            }

            guard let data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }

            completionHandler(.success(data))
        }
        session.resume()
    }

}

class ResponseHandler {

    func parseResonseDecode<T: Decodable>(
        data: Data,
        modelType: T.Type,
        completionHandler: ResultHandler<T>
    ) {
        do {
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            print(userResponse)
            completionHandler(.success(userResponse))
        }catch {
            completionHandler(.failure(.decoding(error)))
        }
    }

}

enum HttpMethodType: String {
    
    case Get = "GET"
    case Post = "POST"
    case Put =  "PUT"
    case Delete = "DELETE"

    var value: String{
        self.rawValue
    }
}
