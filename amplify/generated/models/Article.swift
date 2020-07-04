// swiftlint:disable all
import Amplify
import Foundation

public struct Article: Model {
  public let id: String
  public var title: String
  public var link: String
  public var status: Status
  public var priority: Int
  public var createdAt: Temporal.DateTime
  public var image: String?
  public var categories: Category?
  public var description: String?
  public var favoriteReaders: List<FavoriteArticles>?
  public var recentlyReaders: List<RecentlyReadArticles>?
  
  public init(id: String = UUID().uuidString,
      title: String,
      link: String,
      status: Status,
      priority: Int,
      createdAt: Temporal.DateTime,
      image: String? = nil,
      categories: Category? = nil,
      description: String? = nil,
      favoriteReaders: List<FavoriteArticles>? = [],
      recentlyReaders: List<RecentlyReadArticles>? = []) {
      self.id = id
      self.title = title
      self.link = link
      self.status = status
      self.priority = priority
      self.createdAt = createdAt
      self.image = image
      self.categories = categories
      self.description = description
      self.favoriteReaders = favoriteReaders
      self.recentlyReaders = recentlyReaders
  }
}