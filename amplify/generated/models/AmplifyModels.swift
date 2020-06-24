// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "0ee92aecb506a332d7ee167f36d98e05"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Article.self)
  }
}