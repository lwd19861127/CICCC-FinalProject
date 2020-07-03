// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var userName: String
  public var userEmail: String?
  public var favorites: List<FavoriteArticles>?
  public var recentlyRead: List<RecentlyReadArticles>?
  
  public init(id: String = UUID().uuidString,
      userName: String,
      userEmail: String? = nil,
      favorites: List<FavoriteArticles>? = [],
      recentlyRead: List<RecentlyReadArticles>? = []) {
      self.id = id
      self.userName = userName
      self.userEmail = userEmail
      self.favorites = favorites
      self.recentlyRead = recentlyRead
  }
}