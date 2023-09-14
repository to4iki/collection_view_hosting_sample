import SwiftUI
import AVKit

/// - SeeAlso: https://benoitpasquier.com/playing-video-avplayer-swiftui/
struct AVPlayerView: UIViewRepresentable {
  let player: AVPlayer

  init(player: AVPlayer) {
    self.player = player
  }

  func makeUIView(context: Context) -> PlayerUIView {
    PlayerUIView(player: player)
  }

  func updateUIView(_ uiView: PlayerUIView, context: Context) {}
}

final class PlayerUIView: UIView {
  var playerLayer: AVPlayerLayer {
    layer as! AVPlayerLayer
  }

  override static var layerClass: AnyClass {
    AVPlayerLayer.self
  }

  init(player: AVPlayer) {
    super.init(frame: .zero)
    self.playerLayer.player = player
    self.backgroundColor = .black
    self.playerLayer.contentsGravity = .resizeAspectFill
    self.playerLayer.videoGravity = .resizeAspectFill
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
