//
//  HomePresenter.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import SwiftUI
import RxSwift

class HomePresenter: ObservableObject {

  private let router = HomeRouter()
  private let homeUseCase: HomeUseCase
    private let disposeBag = DisposeBag()

  @Published var categories: [CategoryModel] = []
  @Published var errorMessage: String = ""
  @Published var loadingState: Bool = false

  init(homeUseCase: HomeUseCase) {
    self.homeUseCase = homeUseCase
  }

    
    //MARK: - Before using rxSwift
//  func getCategories() {
//    loadingState = true
//    homeUseCase.getCategories { result in
//      switch result {
//      case .success(let categories):
//        DispatchQueue.main.async {
//          self.loadingState = false
//          self.categories = categories
//        }
//      case .failure(let error):
//        DispatchQueue.main.async {
//          self.loadingState = false
//          self.errorMessage = error.localizedDescription
//        }
//      }
//    }
//  }
    
    func getCategories() {
        loadingState = true
        
        homeUseCase.getCategories().observe(on: MainScheduler.instance).subscribe { result in
            self.categories = result
        } onError: { error in
            self.errorMessage = error.localizedDescription
        } onCompleted: {
            self.loadingState = false
        }.disposed(by: disposeBag)
    }

  func linkBuilder<Content: View>(
    for category: CategoryModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(
    destination: router.makeDetailView(for: category)) { content() }
  }

}
