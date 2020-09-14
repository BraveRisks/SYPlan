// https://matteomanferdini.com/codable/?utm_campaign=Swift%20Weekly&utm_medium=email&utm_source=Revue%20newsletter
import UIKit

//extension DateFormatter {
//    static let fullISO8601: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(secondsFromGMT: 8)
//        formatter.locale = Locale(identifier: "zh-TW")
//        return formatter
//    }()
//}
//
//let json = """
//{
//    "flight_number": 65,
//    "mission_name": "Telstar 19V",
//    "launch_date_unix": 1532238600,
//    "launch_date_utc": "2018-07-22T05:50:00.000Z",
//    "launch_success": true,
//    "rocket": {
//        "rocket_id": "falcon9",
//        "second_stage": {
//            "payloads": [
//                {
//                    "payload_id": "Telstar 19V"
//                },
//                {
//                    "payload_id": "Jaguar 21V"
//                }
//            ]
//        }
//    },
//    "launch_site": {
//        "site_name_long": "Cape Canaveral Air Force Station Space Launch Complex 40"
//    },
//    "links": {
//        "mission_patch": "https://images2.imgbox.com/c5/53/5jklZkPz_o.png"
//    },
//    "timeline": {
//        "go_for_prop_loading": -2280,
//        "liftoff": 0,
//        "meco": 150,
//        "payload_deploy": 1960
//    }
//}
//"""
//
//struct Launch: Decodable {
//    let flightNumber: Int
//    let missionName: String
//    //let dateUnix: Date
//    let dateUTC: Date
//    let succeeded: Bool
//    let timeline: Timeline?
//    let rocket: String
//    let site: String
//    let patchURL: URL
//    let payloads: [Payload]
//
//    private enum CodingKeys: String, CodingKey {
//        case flightNumber = "flight_number"
//        case missionName = "mission_name"
//        //case dateUnix = "launch_date_unix"
//        case dateUTC = "launch_date_utc"
//        case succeeded = "launch_success"
//        case timeline
//        case rocket
//        case launchSite = "launch_site"
//        case links
//
//        enum RocketKeys: String, CodingKey {
//            case rocketID = "rocket_id"
//            case secondStage = "second_stage"
//
//            enum SecondStageKeys: String, CodingKey {
//                case payloads
//            }
//        }
//
//        enum LaunchSiteKeys: String, CodingKey {
//            case siteName = "site_name_long"
//        }
//
//        enum LinksKeys: String, CodingKey {
//            case patchURL = "mission_patch"
//        }
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        flightNumber = try container.decode(Int.self, forKey: .flightNumber)
//        missionName = try container.decode(String.self, forKey: .missionName)
//        dateUTC = try container.decode(Date.self, forKey: .dateUTC)
//        succeeded = try container.decode(Bool.self, forKey: .succeeded)
//        timeline = try container.decodeIfPresent(Timeline.self, forKey: .timeline)
//
//        let linksContainer = try container.nestedContainer(keyedBy: CodingKeys.LinksKeys.self, forKey: .links)
//        patchURL = try linksContainer.decode(URL.self, forKey: .patchURL)
//
//        let siteContainer = try container.nestedContainer(keyedBy: CodingKeys.LaunchSiteKeys.self, forKey: .launchSite)
//        site = try siteContainer.decode(String.self, forKey: .siteName)
//
//        let rocketContainer = try container.nestedContainer(keyedBy: CodingKeys.RocketKeys.self, forKey: .rocket)
//        rocket = try rocketContainer.decode(String.self, forKey: .rocketID)
//
//        let secondStageContainer = try rocketContainer.nestedContainer(keyedBy: CodingKeys.RocketKeys.SecondStageKeys.self, forKey: .secondStage)
//        payloads = try secondStageContainer.decode([Payload].self, forKey: .payloads)
//    }
//}
//
//struct Timeline: Decodable {
//    let propellerLoading: Int?
//    let liftoff: Int?
//    let mainEngineCutoff: Int?
//    let payloadDeploy: Int?
//
//    private enum CodingKeys: String, CodingKey {
//        case propellerLoading = "go_for_prop_loading"
//        case liftoff
//        case mainEngineCutoff = "meco"
//        case payloadDeploy = "payload_deploy"
//    }
//}
//
//struct Payload: Decodable {
//    let name: String
//
//    private enum CodingKeys: String, CodingKey {
//        case name = "payload_id"
//    }
//}
//
//let decoder = JSONDecoder()
////decoder.keyDecodingStrategy = .convertFromSnakeCase
////decoder.dateDecodingStrategy = .secondsSince1970
//decoder.dateDecodingStrategy = .formatted(DateFormatter.fullISO8601)
//let launch = try decoder.decode(Launch.self, from: json.data(using: .utf8)!)
//print("Launch --> \(launch)")
//
//
/////////////////// Encodable
//struct Customer: Encodable {
//    let name: String
//    let gender: Bool
//    let birth: Date?
//    let age: Int
//    let mobile: String?
//    let childs: [Child]?
//
//    private enum CodingKeys: String, CodingKey {
//        case name = "Name"
//        case gender = "Gender"
//        case birth = "Birthday"
//        case age = "Age"
//        case mobile = "Mobile"
//        case childs = "Childs"
//    }
//
//}
//
//struct Child: Encodable {
//    let name: String
//    let gender: Bool
//    let age: Int
//
//    private enum CodingKeys: String, CodingKey {
//        case name = "Name"
//        case gender = "Gender"
//        case age = "Age"
//    }
//}
//
//let childs = [Child(name: "Jack", gender: true, age: 2),
//              Child(name: "Jane", gender: false, age: 1)]
//let customer1 = Customer(name: "Ray",
//                         gender: true,
//                         birth: Date(),
//                         age: 30,
//                         mobile: nil,
//                         childs: childs)
//let encoder = JSONEncoder()
//let df = DateFormatter()
//df.dateFormat = "yyyy/MM/dd"
//encoder.dateEncodingStrategy = .formatted(df)
//encoder.outputFormatting = .prettyPrinted
//let data = try encoder.encode(customer1)
//let parameters = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//print("parameters --> \(parameters)")
