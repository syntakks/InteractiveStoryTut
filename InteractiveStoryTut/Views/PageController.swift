//
//  PageController.swift
//  InteractiveStoryTut
//
//  Created by Stephen Wall on 2/6/20.
//  Copyright © 2020 syntaks.io. All rights reserved.
//
import Foundation
import UIKit

extension NSAttributedString {
    var range: NSRange {
        return NSMakeRange(0, self.length)
    }
}

extension Story {
    var attributedText: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: attributedString.range)
        return attributedString
    }
}

extension Page {
    func story(attributed: Bool) -> NSAttributedString {
        if attributed {
            return story.attributedText
        } else {
            return NSAttributedString(string: story.text) // This has no style applied.
        }
    }
}

class PageController: UIViewController {
    
    var page: Page?
    let soundEffectsPlayer = SoundEffectsPlayer()
    
    // MARK: - User Interface Properties
    lazy var artworkView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.page?.story.artwork
        return imageView
    }()
    lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.attributedText = self.page?.story(attributed: true)
        return label
    }()
    lazy var firstChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = self.page?.firstChoice?.title ?? "Play Again"
        let selector = self.page?.firstChoice != nil ? #selector(PageController.loadFirstChoice) : #selector(PageController.playAgain)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }()
    lazy var secondChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(self.page?.secondChoice?.title, for: .normal)
        button.addTarget(self, action: #selector(PageController.loadSecondChoice), for: .touchUpInside)
        return button
    }()
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Add Views and Constraints
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .black
        //artworkView
        view.addSubview(artworkView)
        //artworkView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(equalTo: view.topAnchor),
            artworkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            artworkView.leftAnchor.constraint(equalTo: view.leftAnchor),
            artworkView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        //storyLabel
        view.addSubview(storyLabel)
        NSLayoutConstraint.activate([
            storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            storyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -48)
        ])
        //firstChoiceButton
        view.addSubview(firstChoiceButton)
        firstChoiceButton.tintColor = UIColor(red: 245/255.0, green: 81/255.0, blue: 81/255.0, alpha: 1.0)
        NSLayoutConstraint.activate([
          firstChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          firstChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80.0)
        ])
        //secondChoiceButton
        view.addSubview(secondChoiceButton)
        secondChoiceButton.tintColor = UIColor(red: 245/255.0, green: 81/255.0, blue: 81/255.0, alpha: 1.0)
        NSLayoutConstraint.activate([
          secondChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          secondChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        ])
    }
    
    @objc func loadFirstChoice() {
        if let page = page,
            let firstChoice = page.firstChoice {
            let nextPage = firstChoice.page
            let pageController = PageController(page: nextPage)
            soundEffectsPlayer.playSound(for: nextPage.story)
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    @objc func loadSecondChoice() {
        if let page = page,
            let secondChoice = page.secondChoice {
            let nextPage = secondChoice.page
            let pageController = PageController(page: nextPage)
            soundEffectsPlayer.playSound(for: nextPage.story)
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    @objc func playAgain() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    


}
