//
//  Service.swift
//  StocksApp
//
//  Created by user243757 on 10/16/23.
//

import Foundation
class Service{
    private init(){}
    static var shared = Service()
    
    enum error: Error {
        case badURL
    }
  
    
    let headers = [
        "X-RapidAPI-Key": "562f007be0msh92c97f3d9b838ecp15ba90jsn8d323031b052",
        "X-RapidAPI-Host": "ms-finance.p.rapidapi.com"
    ]

    func getData(url : String, completion: @escaping (Result<Data,Error>)->Void) {

     //   print("url in service \(url)")
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest){(data, response, error) in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                completion(.success(data))
            }
            
        }.resume()
        
    }


}



