// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "7ca6eae6e4b4cd7f6efc7bf2e78b5de4"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: FavoriteArticles.self)
    ModelRegistry.register(modelType: Article.self)
    ModelRegistry.register(modelType: RecentlyReadArticles.self)
    ModelRegistry.register(modelType: Recommend.self)
  }
}