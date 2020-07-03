// swiftlint:disable all
import Amplify
import Foundation

extension RecentlyReadArticles {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case user
    case article
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let recentlyReadArticles = RecentlyReadArticles.keys
    
    model.pluralName = "RecentlyReadArticles"
    
    model.fields(
      .id(),
      .belongsTo(recentlyReadArticles.user, is: .required, ofType: User.self, targetName: "userID"),
      .belongsTo(recentlyReadArticles.article, is: .required, ofType: Article.self, targetName: "articleID")
    )
    }
}