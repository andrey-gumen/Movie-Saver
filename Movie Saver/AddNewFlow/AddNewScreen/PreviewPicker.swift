import Combine
import EasyAutolayout
import UIKit
import Foundation

final class PreviewPicker: UIView {

    // MARK: - Properties
    // MARK: Public
    let previewChangedSubject = PassthroughSubject<UIImage?, Never>()
    var viewCntroller: UIViewController!

    // MARK: Private
    private let mainImage = UIImageView()

    private static let defaultPreview = UIImage(systemName: "photo")

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview()
        configureUI()
        configureConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API
    // MARK: - Setups
    private func addSubview() {
        addSubview(mainImage)
    }

    private func configureUI() {
        mainImage.backgroundColor = UIColor(red: 0.868, green: 0.868, blue: 0.868, alpha: 1)
        mainImage.layer.cornerRadius = 75
        mainImage.clipsToBounds = true
        mainImage.contentMode = .scaleAspectFill
        mainImage.image = PreviewPicker.defaultPreview
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewDidTapped))
        mainImage.isUserInteractionEnabled = true
        mainImage.addGestureRecognizer(tap)
    }

    private func configureConstraints() {
        mainImage.pin
            .edges([.top, .bottom, .left, .right], to: self)
    }

    // MARK: - Helpers
    @objc func previewDidTapped() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in self.openCamera() }
        alert.addAction(cameraAction)

        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in self.openGallery() }
        alert.addAction(galleryAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(cancelAction)

        viewCntroller.present(alert, animated: true, completion: nil)
    }
    
}

extension PreviewPicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) else {
            let alert = UIAlertController(title: "Warning", message: "You don't have access to camera", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            viewCntroller.present(alert, animated: true, completion: nil)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        viewCntroller.present(imagePicker, animated: true, completion: nil)
    }

    private func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) else {
            let alert = UIAlertController(title: "Warning", message: "You don't have access to gallery", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            viewCntroller.present(alert, animated: true, completion: nil)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        viewCntroller.present(imagePicker, animated: true, completion: nil)
    
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainImage.image = image
        }
    }
    
}
