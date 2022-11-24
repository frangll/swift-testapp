import UIKit
import Foundation

class AppCoordinator {
    private let navigationController = UINavigationController()
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    private weak var homeViewController: HomeViewController?
    
    func start() {
        showHomeView()
    }
    
    private func showHomeView() {
        guard let homeViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            fatalError("Unable to instantiate HomeViewController")
        }
        self.homeViewController = homeViewController
        homeViewController.delegate = self
        navigationController.setViewControllers([homeViewController], animated: true)
    }
}

extension AppCoordinator: HomeViewControllerDelegate {
    func homeViewControllerDidTapOnAddButton(_ homeViewController: HomeViewController) {
        let addViewController = AddMovementViewController()
        addViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addViewController)
        homeViewController.present(navigationController, animated: true)
    }
}

extension AppCoordinator: AddMovementViewControllerDelegate {
    func addMovementViewControllerDidTapTrashIcon(_ addMovementViewController: AddMovementViewController) {
        addMovementViewController.dismiss(animated: true)
    }
    
    func addMovementViewController(_ addMovementViewController: AddMovementViewController, didTapConfirmWithAmout amount: String, and name: String) {
        addMovementViewController.dismiss(animated: true)
        homeViewController?.addMovement(with: amount, and: name)
    }
}
