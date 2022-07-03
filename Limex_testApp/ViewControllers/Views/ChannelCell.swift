//
//  ChannelCell.swift
//  Limex_testApp
//
//  Created by Никита Горбунов on 02.07.2022.
//

import UIKit
import RealmSwift

class ChannelCell: UITableViewCell {
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonTapped() {
        
    }
    
    // MARK: - Public methods
    func configure(with channel: Channel?) {
        channelName.text = channel?.nameRu
        channelTitle.text = channel?.current?.title
        
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: channel?.image) else { return }
            DispatchQueue.main.async {
                self.channelImage.image = UIImage(data: imageData)
            }
        }
    }
}
