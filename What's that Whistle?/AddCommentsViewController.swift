//
//  AddCommentsViewController.swift
//  What's that Whistle?
//
//  Created by Tony Alhwayek on 8/22/23.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextViewDelegate {
    
    var genre: String!
    var comments: UITextView!
    let placeholder = "If you have any additional comments that might help identify your tune, add them here."

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTapped))
        comments.text = placeholder
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        comments = UITextView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.delegate = self
        comments.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(comments)
        
        // Make the text view take up the whole screen
        comments.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        comments.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        comments.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        comments.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // When user taps submit
    @objc func submitTapped() {
        let submitVC = SubmitViewController()
        submitVC.genre = genre
        
        if comments.text == placeholder {
            submitVC.comments = ""
        } else {
            submitVC.comments = comments.text
        }
        
        navigationController?.pushViewController(submitVC, animated: true)
    }
    
    // Remove placeholder on tap
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
    }

}
