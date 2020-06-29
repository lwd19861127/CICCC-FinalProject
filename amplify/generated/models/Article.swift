// swiftlint:disable all
import Amplify
import Foundation

public struct Article: Model {
  public let id: String
  public var title: String
  public var date: Temporal.DateTime
  public var link: String
  public var status: Status
  public var image: String?
  public var categories: ArticleCategory?
  public var priority: Int?
  public var description: String?
  
  public init(id: String = UUID().uuidString,
      title: String,
      date: Temporal.DateTime,
      link: String,
      status: Status,
      image: String? = nil,
      categories: ArticleCategory? = nil,
      priority: Int? = nil,
      description: String? = nil) {
      self.id = id
      self.title = title
      self.date = date
      self.link = link
      self.status = status
      self.image = image
      self.categories = categories
      self.priority = priority
      self.description = description
  }
}