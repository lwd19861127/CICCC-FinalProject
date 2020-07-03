// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userName
    case userEmail
    case favorites
    case recentlyRead
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.pluralName = "Users"
    
    model.fields(
      .id(),
      .field(user.userName, is: .required, ofType: .string),
      .field(user.userEmail, is: .optional, ofType: .string),
      .hasMany(user.favorites, is: .optional, ofType: FavoriteArticles.self, associatedWith: FavoriteArticles.keys.user),
      .hasMany(user.recentlyRead, is: .optional, ofType: RecentlyReadArticles.self, associatedWith: RecentlyReadArticles.keys.user)
    )
    }
}