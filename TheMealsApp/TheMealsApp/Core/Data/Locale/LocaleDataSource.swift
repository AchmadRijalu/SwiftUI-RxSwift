//
//  LocaleDataStore.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import Foundation
import RealmSwift
import RxSwift

protocol LocaleDataSourceProtocol: AnyObject {

    //MARK: Before using RxSwift
//  func getCategories(result: @escaping (Result<[CategoryEntity], DatabaseError>) -> Void)
//  func addCategories(
//    from categories: [CategoryEntity],
//    result: @escaping (Result<Bool, DatabaseError>) -> Void
//  )
    
    func getCategories() -> Observable<[CategoryEntity]>
    func addCategorie(from categories: [CategoryEntity]) -> Observable<Bool>
    

}

final class LocaleDataSource: NSObject {

  private let realm: Realm?

  private init(realm: Realm?) {
    self.realm = realm
  }

  static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
    return LocaleDataSource(realm: realmDatabase)
  }

}

extension LocaleDataSource: LocaleDataSourceProtocol {
    func getCategories() -> RxSwift.Observable<[CategoryEntity]> {
        return Observable<[CategoryEntity]>.create { observer in
            if let realm = self.realm {
                let categories: Results<CategoryEntity> = {
                    realm.objects(CategoryEntity.self).sorted(byKeyPath: "title", ascending: true)
                }()
                observer.onNext(categories.toArray(ofType: CategoryEntity.self))
                observer.onCompleted()
            }
            else{
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func addCategorie(from categories: [CategoryEntity]) -> RxSwift.Observable<Bool> {
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                do {
                    try realm.write {
                        for category in categories {
                            realm.add(category, update: .all)
                        }
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                
                }
                catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            }
            else{
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    

    
    
    //MARK: Before using rxswift
//  func getCategories(
//    result: @escaping (Result<[CategoryEntity], DatabaseError>) -> Void
//  ) {
//    if let realm = realm {
//      let categories: Results<CategoryEntity> = {
//        realm.objects(CategoryEntity.self)
//          .sorted(byKeyPath: "title", ascending: true)
//      }()
//      result(.success(categories.toArray(ofType: CategoryEntity.self)))
//    } else {
//      result(.failure(.invalidInstance))
//    }
//  }
//
//  func addCategories(
//    from categories: [CategoryEntity],
//    result: @escaping (Result<Bool, DatabaseError>) -> Void
//  ) {
//    if let realm = realm {
//      do {
//        try realm.write {
//          for category in categories {
//            realm.add(category, update: .all)
//          }
//          result(.success(true))
//        }
//      } catch {
//        result(.failure(.requestFailed))
//      }
//    } else {
//      result(.failure(.invalidInstance))
//    }
//  }

}

extension Results {

  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }

}
