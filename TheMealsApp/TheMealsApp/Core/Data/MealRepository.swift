//
//  MealRepository.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import Foundation
import RxSwift

protocol MealRepositoryProtocol {

    
    //MARK: - Before Using RXSwift
//  func getCategories(result: @escaping (Result<[CategoryModel], Error>) -> Void)
    
    func getCategories() -> Observable<[CategoryModel]>

}

final class MealRepository: NSObject {

  typealias MealInstance = (LocaleDataSource, RemoteDataSource) -> MealRepository

  fileprivate let remote: RemoteDataSource
  fileprivate let locale: LocaleDataSource

  private init(locale: LocaleDataSource, remote: RemoteDataSource) {
    self.locale = locale
    self.remote = remote
  }

  static let sharedInstance: MealInstance = { localeRepo, remoteRepo in
    return MealRepository(locale: localeRepo, remote: remoteRepo)
  }

}

extension MealRepository: MealRepositoryProtocol {
    func getCategories() -> RxSwift.Observable<[CategoryModel]> {
        return self.locale.getCategories().map {
            CategoryMapper.mapCategoryEntitiesToDomains(input: $0)
            
        }.filter {
            !$0.isEmpty
            
        }.ifEmpty(switchTo: self.remote.getCategories().map {
            CategoryMapper.mapCategoryResponsesToEntities(input: $0)
        }.flatMap{
            self.locale.addCategorie(from: $0)
        }.filter{
            $0
        }.flatMap { _ in self.locale.getCategories().map {
            CategoryMapper.mapCategoryEntitiesToDomains(input: $0)
        }
            
        })
    }
    

    //MARK: - Before using RXSWift
//  func getCategories(
//    result: @escaping (Result<[CategoryModel], Error>) -> Void
//  ) {
//    locale.getCategories { localeResponses in
//      switch localeResponses {
//      case .success(let categoryEntity):
//        let categoryList = CategoryMapper.mapCategoryEntitiesToDomains(input: categoryEntity)
//        if categoryList.isEmpty {
//          self.remote.getCategories { remoteResponses in
//            switch remoteResponses {
//            case .success(let categoryResponses):
//              let categoryEntities = CategoryMapper.mapCategoryResponsesToEntities(input: categoryResponses)
//              self.locale.addCategories(from: categoryEntities) { addState in
//                switch addState {
//                case .success(let resultFromAdd):
//                  if resultFromAdd {
//                    self.locale.getCategories { localeResponses in
//                      switch localeResponses {
//                      case .success(let categoryEntity):
//                        let resultList = CategoryMapper.mapCategoryEntitiesToDomains(input: categoryEntity)
//                        result(.success(resultList))
//                      case .failure(let error):
//                        result(.failure(error))
//                      }
//                    }
//                  }
//                case .failure(let error):
//                  result(.failure(error))
//                }
//              }
//            case .failure(let error):
//              result(.failure(error))
//            }
//          }
//        } else {
//          result(.success(categoryList))
//        }
//      case .failure(let error):
//        result(.failure(error))
//      }
//    }
//  }
}
