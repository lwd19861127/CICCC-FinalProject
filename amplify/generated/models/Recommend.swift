// swiftlint:disable all
import Amplify
import Foundation

public struct Recommend: Model {
  public let id: String
  public var title: String
  public var image: String?
  public var category: ArticleCategory
  public var priority: Int?
  
  public init(id: String = UUID().uuidString,
      title: String,
      image: String? = nil,
      category: ArticleCategory,
      priority: Int? = nil) {
      self.id = id
      self.title = title
      self.image = image
      self.category = category
      self.priority = priority
  }
}