//
//  ViewController.swift
//  StoryPrompt
//
//  Created by Justin on 2024/3/27.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
	
	@IBOutlet weak var nounTextField: UITextField!
	@IBOutlet weak var adjectiveTextField: UITextField!
	@IBOutlet weak var verbTextField: UITextField!
	@IBOutlet weak var numberSlider: UISlider!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var storyPromptImageView: UIImageView!
	
	let storyPrompt = StoryPromptEntry()
	
	@IBAction func changeNumber(_ sender: UISlider) {
		numberLabel.text = "Number: \(Int(sender.value))"
		storyPrompt.number = Int(sender.value)
	}
	
	@IBAction func changeStoryType(_ sender: UISegmentedControl) {
		if let genre = StoryPrompts.Genre(rawValue: sender.selectedSegmentIndex) {
			storyPrompt.genre = genre
		} else {
			storyPrompt.genre = .scifi
		}
	}
	
	@IBAction func generateStoryPrompt(_ sender: UIButton) {
		updateStoryPrompt()
		if storyPrompt.isValid() {
			print(storyPrompt)
		} else {
			let alert = UIAlertController(title: "Invalid Story Prompt", message: "Please fill out all of the fields", preferredStyle: .alert)
			let action = UIAlertAction(title: "OK", style: .default) { action in
				
			}
			alert.addAction(action)
			present(alert, animated: true)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		numberSlider.value = 7.5
		storyPrompt.noun = "toaster"
		storyPrompt.adjective = "smelly"
		storyPrompt.verb = "burps"
		storyPrompt.number = Int(numberSlider.value)
		storyPromptImageView.isUserInteractionEnabled = true
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
		storyPromptImageView.addGestureRecognizer(gestureRecognizer)
	}
	
	@objc func changeImage() {
//		let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
//		if readWriteStatus == .authorized {
			var configuration = PHPickerConfiguration()
			configuration.filter = .images
			configuration.selectionLimit = 1
			let controller = PHPickerViewController(configuration: configuration)
			controller.delegate = self
			present(controller, animated: true)
//		} else {
//			// Request read-write access to the user's photo library.
//			PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
//				switch status {
//					case .notDetermined:
//						// The user hasn't determined this app's access.
//						print("The user hasn't determined this app's access")
//					case .restricted:
//						// The system restricted this app's access.
//						print("The system restricted this app's access")
//					case .denied:
//						// The user explicitly denied this app's access.
//						print("The user explicitly denied this app's access")
//					case .authorized:
//						// The user authorized this app to access Photos data.
//						print("The user authorized this app to access Photos data")
//						DispatchQueue.main.async {
//							var configuration = PHPickerConfiguration()
//							configuration.filter = .images
//							configuration.selectionLimit = 1
//							let controller = PHPickerViewController(configuration: configuration)
//							controller.delegate = self
//							self?.present(controller, animated: true)
//						}
//					case .limited:
//						// The user authorized this app for limited Photos access.
//						print("The user authorized this app for limited Photos access")
//					@unknown default:
//						fatalError()
//				}
//			}
//		}
	}
	
	func updateStoryPrompt() {
		storyPrompt.noun = nounTextField.text ?? ""
		storyPrompt.adjective = adjectiveTextField.text ?? ""
		storyPrompt.verb = verbTextField.text ?? ""
	}
}

extension ViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		updateStoryPrompt()
		return true
	}
}

extension ViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		print("hereee")
		if !results.isEmpty {
			print("hereee 22222")
			let result = results.first!
			let itemProvider = result.itemProvider
			if itemProvider.canLoadObject(ofClass: UIImage.self) {
				print("hereee 33333")
				itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
					guard let image = image as? UIImage else {
						return
					}
					DispatchQueue.main.async {
						self?.storyPromptImageView.image = image
						picker.dismiss(animated: true)
					}
				}
			}
		}
	}
}

