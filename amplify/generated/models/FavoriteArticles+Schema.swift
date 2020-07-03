// swiftlint:disable all
import Amplify
import Foundation

extension FavoriteArticles {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case user
    case article
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let favoriteArticles = FavoriteArticles.keys
    
    model.pluralName = "FavoriteArticles"
    
    model.fields(
      .id(),
      .belongsTo(favoriteArticles.user, is: .required, ofType: User.self, targetName: "userID"),
      .belongsTo(favoriteArticles.article, is: .required, ofType: Article.self, targetName: "articleID")
    )
    }
}