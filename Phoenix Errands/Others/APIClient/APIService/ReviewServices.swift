
import Foundation
import Foundation
import Alamofire
import AlamofireObjectMapper
import Localize_Swift

protocol ReviewServicesProtocol {
    func sendReviewDetails(param : [String : Any], completion: RequestCompletionHandler?)
    func sendMarkAsCompletedDetails(param : [String : Any], completion: RequestCompletionHandler?)
}

class ReviewServices: ReviewServicesProtocol {
    
    func sendReviewDetails(param: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.AddreviewAPI()
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json"]
        Alamofire.request(loginApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<BidModel>) in
            print("loginApi==>\(loginApi)")
            print("params==>\(param)")
            let loginApiResponse : Response!
            var responseStausCode: Int = 1
            var failureMessage: String = ""
            
            if let message = response.error?.localizedDescription {
                failureMessage = message
            }
            if let statusCode = response.response?.statusCode {
                responseStausCode = statusCode
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            switch(response.result) {
            case .success(let data):
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
    
    func sendMarkAsCompletedDetails(param: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.serviceCompletdAPI()
        let header = ["Content-Type" : "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userToken)!, "Accept" : "application/json" , "X-localization": Localize.currentLanguage()]
        Alamofire.request(loginApi, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<CompletedModel>) in
            print("loginApi==>\(loginApi)")
            print("params==>\(param)")
            let loginApiResponse : Response!
            
            var responseStausCode: Int = 1
            var failureMessage: String = ""
            
            if let message = response.error?.localizedDescription {
                failureMessage = message
            }
            if let statusCode = response.response?.statusCode {
                responseStausCode = statusCode
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            switch(response.result) {
            case .success(let data):
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
}
