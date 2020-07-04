// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "a71c12dd3e457bc68d79041a5ad1ca9a"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: FavoriteArticles.self)
    ModelRegistry.register(modelType: Article.self)
    ModelRegistry.register(modelType: RecentlyReadArticles.self)
    ModelRegistry.register(modelType: Recommend.self)
  }
}