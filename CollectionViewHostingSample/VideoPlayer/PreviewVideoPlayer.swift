import AVKit
import SwiftUI

struct PreviewVideoPlayer: View {
  private enum PlayerState: String {
    case idle
    case playing
    case pausing
  }

  private let url: String
  private let id: Int
  @Binding var isPreview: Bool
  @Binding var videoSize: CGSize
  @State private var player = AVPlayer()
  @State private var state = PlayerState.idle

  init(
    id: Int,
    url: String,
    isPreview: Binding<Bool>,
    videoSize: Binding<CGSize>
  ) {
    self.id = id
    self.url = url
    self._isPreview = isPreview
    self._videoSize = videoSize
  }

  var body: some View {
    ZStack {
      if isPreview {
        VideoPlayer(player: player)
        // AVPlayerView(player: player)
          .task {
            guard state == .idle else {
              play()
              return
            }
            guard let item = playerItem() else {
              return
            }
            try? await setVideoSize(asset: item.asset)
            self.player.replaceCurrentItem(with: item)
            play()
          }
          .onDisappear {
            pause()
          }
          .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
            print("\(id): AVPlayerItemDidPlayToEndTime")
          }
          .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemFailedToPlayToEndTime)) { _ in
            print("\(id): AVPlayerItemFailedToPlayToEndTime")
          }
          .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)) { _ in
            print("\(id): AVPlayerItemPlaybackStalled")
          }

      } else {
        EmptyView()
      }

      Text(state.rawValue)
        .font(.title2)
        .foregroundColor(.blue)
    }
  }

  private func playerItem() -> AVPlayerItem? {
    guard let url = URL(string: url) else {
      return nil
    }
    let asset = AVURLAsset(url: url)
    return AVPlayerItem(asset: asset)
  }

  private func play() {
    guard state != .playing else {
      return
    }
    player.isMuted = true
    player.play()
    self.state = .playing
  }

  private func pause() {
    guard state == .playing else {
      return
    }
    player.pause()
    self.state = .pausing
  }

  private func setVideoSize(asset: AVAsset) async throws {
    let track = try await asset.load(.tracks).first
    let size = try await track?.load(.naturalSize)
    self.videoSize = size ?? .zero
  }
}
