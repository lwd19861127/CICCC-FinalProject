// swiftlint:disable all
import Amplify
import Foundation

public struct Recommend: Model {
  public let id: String
  public var title: String
  public var status: Status
  public var category: Category
  public var priority: Int
  public var image: String?
  
  public init(id: String = UUID().uuidString,
      title: String,
      status: Status,
      category: Category,
      priority: Int,
      image: String? = nil) {
      self.id = id
      self.title = title
      self.status = status
      self.category = category
      self.priority = priority
      self.image = image
  }
}