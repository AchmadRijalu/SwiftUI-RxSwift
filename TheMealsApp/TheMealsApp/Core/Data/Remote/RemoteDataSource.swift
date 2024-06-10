//
//  RemoteDataSource.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import Foundation
import Alamofire
import RxSwift

protocol RemoteDataSourceProtocol: AnyObject {
    
    //  func getCategories(result: @escaping (Result<[CategoryResponse], URLError>) -> Void)
    
    func getCategories() -> Observable<[CategoryResponse]>
    
}

final class RemoteDataSource: NSObject {
    
    private override init() { }
    
    static let sharedInstance: RemoteDataSource =  RemoteDataSource()
    
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    func getCategories() -> RxSwift.Observable<[CategoryResponse]> {
        return Observable<[CategoryResponse]>.create { observer in
            if let url = URL(string: Endpoints.Gets.categories.url){
                AF.request(url).validate().responseDecodable(of: CategoriesResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value.categories)
                        observer.onCompleted()
                    case .failure:
                        observer.onError(URLError.invalidResponse)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    
    //MARK: Before Using RxSwift
    //  func getCategories(
    //    result: @escaping (Result<[CategoryResponse], URLError>) -> Void
    //  ) {
    //    guard let url = URL(string: Endpoints.Gets.categories.url) else { return }
    //
    //    AF.request(url)
    //      .validate()
    //      .responseDecodable(of: CategoriesResponse.self) { response in
    //        switch response.result {
    //        case .success(let value): result(.success(value.categories))
    //        case .failure: result(.failure(.invalidResponse))
    //        }
    //      }
    //  }
    
}
