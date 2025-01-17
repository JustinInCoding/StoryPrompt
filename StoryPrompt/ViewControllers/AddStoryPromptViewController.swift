//
//  ViewController.swift
//  StoryPrompt
//
//  Created by Justin on 2024/3/27.
//

import UIKit
import PhotosUI

class AddStoryPromptViewController: UIViewController {
	
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
			performSegue(withIdentifier: "StoryPrompt", sender: nil)
		} else {
			let alert = UIAlertController(title: "Invalid Story Prompt", message: "Please fill out all of the fields", preferredStyle: .alert)
			let action = UIAlertAction(title: "OK", style: .default) { action in
				
			}
			alert.addAction(action)
			present(alert, animated: true)
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		numberSlider.value = 7.5
		storyPrompt.number = Int(numberSlider.value)
		storyPromptImageView.isUserInteractionEnabled = true
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
		storyPromptImageView.addGestureRecognizer(gestureRecognizer)
		NotificationCenter.default.addObserver(self, selector: #selector(updateStoryPrompt), name: UIResponder.keyboardDidHideNotification, object: nil)
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
	
	@objc func updateStoryPrompt() {
		storyPrompt.noun = nounTextField.text ?? ""
		storyPrompt.adjective = adjectiveTextField.text ?? ""
		storyPrompt.verb = verbTextField.text ?? ""
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "StoryPrompt" {
			guard let storyPromptViewController = segue.destination as? StoryPromptViewController else {
				return
			}
			storyPromptViewController.storyPrompt = storyPrompt
			storyPromptViewController.isNewStoryPrompt = true
		}
	}
}

extension AddStoryPromptViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension AddStoryPromptViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		if !results.isEmpty {
			let result = results.first!
			let itemProvider = result.itemProvider
			if itemProvider.canLoadObject(ofClass: UIImage.self) {
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

