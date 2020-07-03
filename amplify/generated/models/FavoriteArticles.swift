// swiftlint:disable all
import Amplify
import Foundation

public struct FavoriteArticles: Model {
  public let id: String
  public var user: User
  public var article: Article
  
  public init(id: String = UUID().uuidString,
      user: User,
      article: Article) {
      self.id = id
      self.user = user
      self.article = article
  }
}