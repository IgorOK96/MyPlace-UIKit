//
//  RatingControl.swift
//  MyPlace
//
//  Created by user246073 on 10/28/24.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    private var ratingButtons = [UIButton]()

    var ratng = 0
    
    @IBInspectable var startSize: CGSize = CGSize(width: 44, height: 44) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

//MARK: Initialozation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button action
    @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // load button image
        let filedStar =
        
        for _ in 0..<starCount {
            
            let button = UIButton()
            button.backgroundColor = .red
            
            //add constraint
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: startSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant:startSize.width).isActive = true
            
            //Setup the button action
            button.addTarget(
                self,
                action: #selector(ratingButtonTapped(button:)),
                for: .touchUpInside
            )
            
            //add the button to the stack
            addArrangedSubview(button)
            
            //add new button in arrey
            ratingButtons.append(button)
        }
    }

}
