// swiftlint:disable all
import Amplify
import Foundation

public enum Category: String, EnumPersistable {
  case bookRecommendations = "BookRecommendations"
  case parentalExperiences = "ParentalExperiences"
  case growthRecord = "GrowthRecord"
  case parentingCode = "ParentingCode"
  case bitOfLife = "BitOfLife"
  case thereAreStudents = "ThereAreStudents"
  case admissionGuide = "AdmissionGuide"
  case wellEducated = "WellEducated"
  case healthAndSafety = "HealthAndSafety"
}