//
//  PostCell.swift
//  BeReal Clone
//
//  Created by Efrain Rodriguez on 2/22/23.
//

import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    private var imageDataRequest: DataRequest?
    
    
    func configure(with post: Post) {
        
        // Username
        
        if let user = post.user {
            usernameLabel.text = user.username

        }
        
        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            // Use AlamoFireImage helper to fetch remote image from URL
            
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                        // Set the image view with fetched image
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                                break
                }
            }
        }
        // Caption
        
        captionLabel.text = post.caption
        
        if let date = post.createdAt {
            dateLabel.text =  DateFormatter.postFormatter.string(from: date)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postImageView.image = nil
        // Cancel Image request
        
        imageDataRequest?.cancel()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
