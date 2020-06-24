// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "d277ccb042e01b6b17b418180c4801d5"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Article.self)
  }
}