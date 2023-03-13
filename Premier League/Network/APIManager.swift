//
//  ApiManager.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 09/03/2023.
//

import Moya

enum APIManager {
//    case matches(dateFrom: String, dateTo: String)
    case matches
}

// MARK: - TargetType Protocol Implementation
extension APIManager: TargetType {
    var baseURL: URL {
        return URL(string: Constants.APIURL)!
    }
    
    var path: String {
        switch self {
        case .matches:
            return "competitions/PL/matches"
        }
    }
    
    var parameters: [String: Any]? {
//        var params = [String : Any]()
//        switch self {
//        case .matches(let dateFrom, let dateTo):
//            params["dateFrom"] = dateFrom
//            params["dateTo"] = dateTo
//        }
//        return params
        return [:]
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        return JSONEncoding.default
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.queryString)
    }
    
    var headers: [String: String]? {
        var headers = [String: String]()
        switch self {
        case .matches:
            headers["X-Auth-Token"] = Constants.APIKey
        }
        return headers
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var manager: Data {
        return Data()
    }
}
