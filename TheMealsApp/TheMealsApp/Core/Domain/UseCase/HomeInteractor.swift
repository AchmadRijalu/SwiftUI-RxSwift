//
//  HomeInteractor.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import Foundation
import RxSwift

protocol HomeUseCase {

    //MARK: - Before using RXSwift
//  func getCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void)
    func getCategories() -> Observable<[CategoryModel]>

}

class HomeInteractor: HomeUseCase {

  private let repository: MealRepositoryProtocol

  required init(repository: MealRepositoryProtocol) {
    self.repository = repository
  }

    
    //MARK: - Before using RXSwift
//  func getCategories(
//    completion: @escaping (Result<[CategoryModel], Error>) -> Void
//  ) {
//    repository.getCategories { result in
//      completion(result)
//    }
//  }
    
    func getCategories() -> RxSwift.Observable<[CategoryModel]> {
        return repository.getCategories()
    }
    

}
