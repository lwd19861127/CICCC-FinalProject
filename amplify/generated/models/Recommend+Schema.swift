// swiftlint:disable all
import Amplify
import Foundation

extension Recommend {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case status
    case category
    case priority
    case image
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let recommend = Recommend.keys
    
    model.pluralName = "Recommends"
    
    model.fields(
      .id(),
      .field(recommend.title, is: .required, ofType: .string),
      .field(recommend.status, is: .required, ofType: .enum(type: Status.self)),
      .field(recommend.category, is: .required, ofType: .enum(type: Category.self)),
      .field(recommend.priority, is: .required, ofType: .int),
      .field(recommend.image, is: .optional, ofType: .string)
    )
    }
}