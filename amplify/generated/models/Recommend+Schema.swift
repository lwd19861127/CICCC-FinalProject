// swiftlint:disable all
import Amplify
import Foundation

extension Recommend {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case image
    case category
    case priority
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let recommend = Recommend.keys
    
    model.pluralName = "Recommends"
    
    model.fields(
      .id(),
      .field(recommend.title, is: .required, ofType: .string),
      .field(recommend.image, is: .optional, ofType: .string),
      .field(recommend.category, is: .required, ofType: .enum(type: ArticleCategory.self)),
      .field(recommend.priority, is: .optional, ofType: .int)
    )
    }
}