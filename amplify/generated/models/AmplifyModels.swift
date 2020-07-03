// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "46011b51eeb6be6a2155fab828396f03"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: FavoriteArticles.self)
    ModelRegistry.register(modelType: Article.self)
    ModelRegistry.register(modelType: RecentlyReadArticles.self)
  }
}