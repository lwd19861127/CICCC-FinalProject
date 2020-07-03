// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "0b871e900e82c87fa5175792718e4621"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: FavoriteArticles.self)
    ModelRegistry.register(modelType: Article.self)
    ModelRegistry.register(modelType: RecentlyReadArticles.self)
  }
}