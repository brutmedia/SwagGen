//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension PetstoreTest.Fake {

    /** To test "client" model */
    public enum TestClientModel {

      public static let service = APIService<Response>(id: "testClientModel", tag: "fake", method: "PATCH", path: "/fake", hasBody: true)

      public class Request: APIRequest<Response> {

          public var body: Client

          public init(body: Client) {
              self.body = body
              super.init(service: TestClientModel.service)
          }

          public override var jsonBody: Any? {
              return body.encode()
          }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = Client

            /** successful operation */
            case success200(Client)

            public var success: Client? {
                switch self {
                case .success200(let response): return response
                }
            }

            public var response: Any {
                switch self {
                case .success200(let response): return response
                }
            }

            public var statusCode: Int {
              switch self {
              case .success200: return 200
              }
            }

            public var successful: Bool {
              switch self {
              case .success200: return true
              }
            }

            public init(statusCode: Int, data: Data) throws {
                switch statusCode {
                case 200: self = try .success200(JSONDecoder.decode(data: data))
                default: throw APIError.unexpectedStatusCode(statusCode: statusCode, data: data)
                }
            }

            public var description: String {
                return "\(statusCode) \(successful ? "success" : "failure")"
            }

            public var debugDescription: String {
                var string = description
                let responseString = "\(response)"
                if responseString != "()" {
                    string += "\n\(responseString)"
                }
                return string
            }
        }
    }
}