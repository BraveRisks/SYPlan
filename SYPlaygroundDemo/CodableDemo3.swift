import Foundation

//let confirmedJsonString = """
//{
//  "status": "confirmed",
//  "confirmedUsers": [{
//      "id": "abc",
//      "name": "Rachel"
//    },
//    {
//      "id": "def",
//      "name": "John"
//    }
//  ]
//}
//"""
//
//let waitlistJsonString = """
//{
//  "status": "waitlist",
//  "position": 12,
//  "confirmedUsers": [{
//      "id": "ghi",
//      "name": "Martin"
//    },
//    {
//      "id": "jkl",
//      "name": "Michelle"
//    }
//  ]
//}
//"""
//
//let notAllowedJsonString = """
//{
//  "status": "not allowed",
//  "reason": "It is too late to confirm to this event."
//}
//"""
//
//let badStatusJSONString = """
//{
//  "status": "some bad status"
//}
//"""
//
//struct User: Codable {
//    let id: String
//    let name: String
//}
//
//enum EventConfirmationResponse {
//    case confirmed([User]) //Contains an array of users going to the event
//    case waitlist(Int, [User]) //Contains the position in the waitlist and
//    case notAllowed(String) //Contains the reason why the user is not allowed
//}
//
//extension EventConfirmationResponse: CustomDebugStringConvertible {
//    var debugDescription: String {
//        switch self {
//        case .confirmed(let users):
//            return "Confirmed. Confirmed users are \(users.map { $0.name }.joined(separator: ", ") )"
//        case .waitlist(let position, let users):
//            return "Position \(position) at waitlist. Confirmed users are \(users.map { $0.name }.joined(separator: ", ") )"
//        case .notAllowed(let reason):
//            return "Not allowed. Reason is: \(reason)"
//        }
//    }
//}
//
//extension EventConfirmationResponse: Codable {
//    //declare which keys we are interested in
//    private enum CodingKeys: String, CodingKey {
//        case status
//        case confirmedUsers
//        case position
//        case reason
//    }
//
//    //declare the possible values os the status key
//    private enum EventConfirmationStatus: String, Codable {
//        case confirmed
//        case waitlist
//        case notAllowed = "not allowed"
//    }
//
//    func encode(to encoder: Encoder) throws {
//        //access the keyed container
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        //iterate over self and encode (1) the status and (2) the associated value(s)
//        switch self {
//        case .confirmed(let users):
//            try container.encode(EventConfirmationStatus.confirmed, forKey: .status)
//            try container.encode(users, forKey: .confirmedUsers)
//        case .waitlist(let position, let users):
//            try container.encode(EventConfirmationStatus.waitlist, forKey: .status)
//            try container.encode(users, forKey: .confirmedUsers)
//            try container.encode(position, forKey: .position)
//        case .notAllowed(let reason):
//            try container.encode(EventConfirmationStatus.notAllowed, forKey: .status)
//            try container.encode(reason, forKey: .reason)
//        }
//    }
//
//    init(from decoder: Decoder) throws {
//        //access the keyed container
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        //decode the value for the status key into the EventConfirmationStatus enum
//        let status = try container.decode(EventConfirmationStatus.self, forKey: .status)
//
//        //iterate over the received status, and try to decode the other relevant values
//        switch status {
//        case .confirmed:
//            let users = try container.decode([User].self, forKey: .confirmedUsers)
//            self = .confirmed(users)
//        case .waitlist:
//            let users = try container.decode([User].self, forKey: .confirmedUsers)
//            let position = try container.decode(Int.self, forKey: .position)
//            self = .waitlist(position, users)
//        case .notAllowed:
//            let reason = try container.decode(String.self, forKey: .reason)
//            self = .notAllowed(reason)
//        }
//    }
//}
//
//func decodeToConfirmationDescription(from jsonString: String) -> String {
//    do {
//        let confirmation = try JSONDecoder().decode(EventConfirmationResponse.self,
//                                                    from: jsonString.data(using: .utf8)!)
//        return String(reflecting: confirmation) //this uses the CustomDebugStringConvertible implemented above
//    } catch {
//        return "Couldn't decode \(jsonString) into EventConfirmationResponse. Error: \(error)"
//    }
//}
//
//decodeToConfirmationDescription(from: confirmedJsonString)
//decodeToConfirmationDescription(from: waitlistJsonString)
//decodeToConfirmationDescription(from: notAllowedJsonString)
//decodeToConfirmationDescription(from: badStatusJSONString)
