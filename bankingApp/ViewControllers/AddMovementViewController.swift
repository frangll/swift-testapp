import UIKit

protocol AddMovementViewControllerDelegate: AnyObject {
    func addMovementViewController(_ addMovementViewController: AddMovementViewController, didTapConfirmWithAmout amount: String, and name: String)
    func addMovementViewControllerDidTapTrashIcon(_ addMovementViewController: AddMovementViewController)
}

class AddMovementViewController: UIViewController {
    
    weak var delegate: AddMovementViewControllerDelegate?
    
    lazy var importTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        self.title = "Aggiungi Movimento" // Navigator title
        
        // Navigation bar left side trash icon
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(navigatorIconTapped))
        
        // Components
        
        let amountStackView = UIStackView()
        amountStackView.translatesAutoresizingMaskIntoConstraints = false
        amountStackView.axis = .horizontal
        amountStackView.distribution = .fill
        amountStackView.alignment = .center
        amountStackView.spacing = 5
        
        let nameStackView = UIStackView()
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.axis = .horizontal
        nameStackView.distribution = .fill
        nameStackView.alignment = .center
        nameStackView.spacing = 5
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Nome"
        
        let importLabel = UILabel()
        importLabel.translatesAutoresizingMaskIntoConstraints = false
        importLabel.text = "Importo"
        
        let currencyLabel = UILabel()
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.text = "€"
        
        let confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("Conferma", for: .normal)
        confirmButton.backgroundColor = .systemGreen
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.cornerCurve = .continuous
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        // Add the elements to the view
        view.addSubview(amountStackView)
        view.addSubview(nameStackView)
        view.addSubview(confirmButton)
        
        amountStackView.addArrangedSubview(importLabel)
        amountStackView.addArrangedSubview(importTextField)
        amountStackView.addArrangedSubview(currencyLabel)
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        
        // Constraints
        let amountStackViewTop = amountStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)

        let nameStackViewTop = nameStackView.topAnchor.constraint(equalTo: amountStackView.bottomAnchor, constant: 10)
        
        let buttonHorizontal = confirmButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        let buttonBottom = confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        
        NSLayoutConstraint.activate([
            amountStackViewTop,
            amountStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            amountStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nameStackViewTop,
            nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            buttonBottom,
            buttonHorizontal,
            importTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            nameTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }
    
    @objc func navigatorIconTapped() {
        delegate?.addMovementViewControllerDidTapTrashIcon(self)
    }
    
    @objc func confirmButtonTapped() {
        // controllare i valori delle textfield
        guard let amount = self.importTextField.text else { return }
        guard let name = self.nameTextField.text else { return }
        
        if amount.count > 0 && name.count > 0 {
            // prendere i valori dalle textfield
            delegate?.addMovementViewController(self, didTapConfirmWithAmout: amount, and: name)
        }
    }
}
