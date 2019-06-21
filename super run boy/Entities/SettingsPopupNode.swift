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
    var soundMuted = false
    
    var muteMusicButton : SpriteKitButton!
    var muteSoundButton : SpriteKitButton!
    var backgroundMusicDelegate : BackgroundMusicDelegate?

    init(withTitle title: String, texture: SKTexture, buttonHandlerDelegate: PopupButtonHandlerDelegate, backgroundMusicDelegate : BackgroundMusicDelegate?) {
        self.backgroundMusicDelegate = backgroundMusicDelegate
        super.init(withTitle: title, texture: texture, buttonHandlerDelegate: buttonHandlerDelegate)

        musicMuted = UserDefaults.standard.bool(forKey: GameConstants.Strings.musicMuteKey)
        soundMuted = UserDefaults.standard.bool(forKey: GameConstants.Strings.soundMuteKey)
        addSettings()
    }

    func addSettings() {
        addMusicMute()
        addSfxMute()
    }

    func addMusicMute() {
        let muteMusicLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        muteMusicLabel.text = "Mute Music"
        muteMusicLabel.fontSize = 200.0
        muteMusicLabel.scale(to: size, width: true, multiplier: 0.4)
        muteMusicLabel.position = CGPoint(x: frame.minX + frame.size.width / 4, y: frame.midY + frame.height / 4 - muteMusicLabel.frame.size.height)
        muteMusicLabel.zPosition = GameConstants.ZPositions.hud + 2

        addChild(muteMusicLabel)

        muteMusicButton = SpriteKitButton(defaultButtonImage: getImageForState(musicMuted), action: onButtonPress, index: 0)
        muteMusicButton.scale(to: size, width: true, multiplier: 0.175)
        muteMusicButton.position = CGPoint(x: frame.maxX - frame.size.width / 4 + muteMusicButton.frame.size.width / 2, y: frame.midY + frame.height / 4 - muteMusicButton.frame.size.height / 4 - muteMusicLabel.frame.height / 4)
        muteMusicButton.zPosition = GameConstants.ZPositions.hud + 2

        addChild(muteMusicButton)
    }

    func addSfxMute() {

        let muteSoundLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        muteSoundLabel.text = "Mute Sounds"
        muteSoundLabel.fontSize = 200.0
        muteSoundLabel.scale(to: size, width: true, multiplier: 0.4)
        muteSoundLabel.position = CGPoint(x: frame.minX + frame.size.width / 4, y: frame.midY + frame.height / 4 - muteSoundLabel.frame.size.height * 3)
        muteSoundLabel.zPosition = GameConstants.ZPositions.hud + 2

        addChild(muteSoundLabel)

        muteSoundButton = SpriteKitButton(defaultButtonImage: getImageForState(soundMuted), action: onButtonPress, index: 1)
        muteSoundButton.scale(to: size, width: true, multiplier: 0.175)
        muteSoundButton.position = CGPoint(x: frame.maxX - frame.size.width / 4 + muteMusicButton.frame.size.width / 2, y: muteSoundLabel.position.y + muteSoundLabel.frame.size.height / 4)
        muteSoundButton.zPosition = GameConstants.ZPositions.hud + 2

        addChild(muteSoundButton)
    }

    func onButtonPress(_ index: Int) {
        if index == 0 {
            toggleMusic()
        }

        if index == 1 {
            toggleSfx();
        }
    }

    func toggleSfx() {
        soundMuted = !soundMuted
        UserDefaults.standard.set(soundMuted, forKey: GameConstants.Strings.soundMuteKey)
        UserDefaults.standard.synchronize()

        muteSoundButton!.defaultButton.texture = SKTexture(imageNamed: getImageForState(soundMuted))
    }

    func toggleMusic() {
        musicMuted = !musicMuted
        UserDefaults.standard.set(musicMuted, forKey: GameConstants.Strings.musicMuteKey)
        UserDefaults.standard.synchronize()

        muteMusicButton!.defaultButton.texture = SKTexture(imageNamed: getImageForState(musicMuted))
        backgroundMusicDelegate?.musicStateChanged(muted: musicMuted)
    }

    func getImageForState(_ bool : Bool) -> String {
        return bool ? GameConstants.Strings.soundMutedButton : GameConstants.Strings.soundOnButton
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }
}
