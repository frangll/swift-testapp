import UIKit
import Foundation

class AppCoordinator {
    private let navigationController = UINavigationController()
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    func start() {
        showHomeView()
    }
    
    private func showHomeView() {
        guard let homeViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            fatalError("Unable to instantiate HomeViewController")
        }
        homeViewController.delegate = self
        navigationController.setViewControllers([homeViewController], animated: true)
    }
}

extension AppCoordinator: HomeViewControllerDelegate {
    
    func homeViewControllerDidTapOnAddButton(_ homeViewController: HomeViewController) {
        let addViewController = AddMovementViewController()
        addViewController.delegate = homeViewController
        let navigationController = UINavigationController(rootViewController: addViewController)
        homeViewController.present(navigationController, animated: true)
    }
}
