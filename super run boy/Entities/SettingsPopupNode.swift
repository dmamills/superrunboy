//
//  SettingsPopupNode.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-21.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit


class SettingsPopupNode : PopupNode {

    var musicMuted = false
    var muteMusicButton : SpriteKitButton!
    var backgroundMusicDelegate : BackgroundMusicDelegate?

    init(withTitle title: String, texture: SKTexture, buttonHandlerDelegate: PopupButtonHandlerDelegate, backgroundMusicDelegate : BackgroundMusicDelegate?) {
        self.backgroundMusicDelegate = backgroundMusicDelegate
        super.init(withTitle: title, texture: texture, buttonHandlerDelegate: buttonHandlerDelegate)

        musicMuted = UserDefaults.standard.bool(forKey: "music_muted")
        addSettings()
    }

    func addSettings() {
        let muteMusicLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        muteMusicLabel.text = "Mute Music"
        muteMusicLabel.fontSize = 200.0
        muteMusicLabel.scale(to: size, width: true, multiplier: 0.4)
        muteMusicLabel.position = CGPoint(x: frame.minX + frame.size.width / 4, y: frame.midY + frame.height / 4 - muteMusicLabel.frame.size.height)
        muteMusicLabel.zPosition = GameConstants.ZPositions.hud + 2

        addChild(muteMusicLabel)

        muteMusicButton = SpriteKitButton(defaultButtonImage: getMusicMuteButtonImage(), action: onButtonPress, index: 0)
        muteMusicButton.scale(to: size, width: true, multiplier: 0.175)
        muteMusicButton.position = CGPoint(x: frame.maxX - frame.size.width / 4 + muteMusicButton.frame.size.width / 2, y: frame.midY + frame.height / 4 - muteMusicButton.frame.size.height / 4 - muteMusicLabel.frame.height / 4)
        muteMusicButton.zPosition = GameConstants.ZPositions.hud + 2

        addChild(muteMusicButton)
    }

    func onButtonPress(_ index: Int) {
        if index == 0 {
            toggleMusic()
        }
    }

    func toggleMusic() {
        musicMuted = !musicMuted
        UserDefaults.standard.set(musicMuted, forKey: "music_muted")
        UserDefaults.standard.synchronize()

        muteMusicButton!.defaultButton.texture = SKTexture(imageNamed: getMusicMuteButtonImage())
        backgroundMusicDelegate?.musicStateChanged(muted: musicMuted)
    }

    func getMusicMuteButtonImage() -> String {
        return musicMuted ? GameConstants.Strings.emptyButton : GameConstants.Strings.playButton
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }
}
