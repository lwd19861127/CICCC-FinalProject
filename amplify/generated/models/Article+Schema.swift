// swiftlint:disable all
import Amplify
import Foundation

extension Article {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case date
    case link
    case status
    case image
    case categories
    case priority
    case description
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let article = Article.keys
    
    model.pluralName = "Articles"
    
    model.fields(
      .id(),
      .field(article.title, is: .required, ofType: .string),
      .field(article.date, is: .required, ofType: .dateTime),
      .field(article.link, is: .required, ofType: .string),
      .field(article.status, is: .required, ofType: .enum(type: Status.self)),
      .field(article.image, is: .optional, ofType: .string),
      .field(article.categories, is: .optional, ofType: .string),
      .field(article.priority, is: .optional, ofType: .int),
      .field(article.description, is: .optional, ofType: .string)
    )
    }
}