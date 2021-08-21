//
//  MoyaIntegration.swift
//  ExampleMoyaPulse
//
//  Created by Bagus andinata on 21/08/21.
//

import Foundation
import Moya
import Alamofire
import Pulse

let ExampleProvider: MoyaProvider<ExampleEndpoints> = {
    let logger: NetworkLogger = NetworkLogger()
    let eventMonitors: [EventMonitor] = [NetworkLoggerEventMonitor(logger: logger)]
    let session = Alamofire.Session(eventMonitors: eventMonitors)
    return MoyaProvider<ExampleEndpoints>(session: session)
}()

enum ExampleEndpoints {
    case getDummyProduct(id: Int)
}

extension ExampleEndpoints: TargetType {
    var baseURL: URL {
        return URL(string: "https://reqres.in")!
    }
    
    var path: String {
        switch self {
        case .getDummyProduct(let id):
            return "/api/products/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}

//MARK: - LOGGER EVENT

struct NetworkLoggerEventMonitor: EventMonitor {
    let logger: NetworkLogger
    
    func request(_ request: Request, didCreateTask task: URLSessionTask) {
        logger.logTaskCreated(task)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        logger.logDataTask(dataTask, didReceive: data)
        
        guard let response = dataTask.response else { return }
        logger.logDataTask(dataTask, didReceive: response)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        logger.logTask(task, didFinishCollecting: metrics)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        logger.logTask(task, didCompleteWithError: error)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse) {
        logger.logDataTask(dataTask, didReceive: proposedResponse.response)
    }
}


