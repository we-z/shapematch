import SwiftUI
import AVFoundation

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width
var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

struct ContentView: View {

    @ObservedObject var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @ObservedObject var notificationManager = NotificationManager()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            LevelsView()
            GameView()
                .offset(x: appModel.showGame ? 0 : deviceWidth)
            SkinsMenuView()
                .offset(x: appModel.showSkinsMenu ? 0 : deviceWidth)
            if appModel.showQuitView {
                QuitView()
            }
            if appModel.showCelebration {
                CelebrationEffect()
            }
            if appModel.showNewLevelAnimation {
                NewLevelAnimation()
            }
            if appModel.showLivesView {
                LivesView()
            }
            if appModel.showLevelComplete {
                LevelCompleteView()
            }
            if appModel.showLevelDetails {
                LevelPreviewCard()
            }
            if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
            if appModel.showGemMenu {
                GemMenuView()
            }
            CelebrateGems()
            if appModel.showMovesCard {
                MovesView()
            }
            if appModel.showSettings {
                SettingsView()
            }
            FirstView()
                .opacity(appModel.showLoading ? 1 : 0)
        }
        .onAppear {
            appModel.initialGrid = appModel.grid
            self.notificationManager.registerLocal()
            appModel.checkLivesRenewal()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                withAnimation(.linear) {
                    appModel.showLoading = false
                }
            }
            // 1054, 1109, 1054, 1057, 1114, 1115, 1159, 1166, 1300, 1308, 1313, 1322, 1334
//            AudioServicesPlaySystemSound(1105)
        }

    }
    
}

#Preview {
    ContentView()
}
