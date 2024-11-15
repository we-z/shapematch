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
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                .ignoresSafeArea()
            ZStack {
                RotatingSunView()
                    .frame(width: 1, height: 1)
                    .offset(y: -(deviceHeight / 1.8))
                LevelsView()
            }
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

        }
        .onAppear {
            appModel.initialGrid = appModel.grid
            self.notificationManager.registerLocal()
            appModel.checkLivesRenewal()
            // 1054, 1109, 1054, 1057, 1114, 1115, 1159, 1166, 1300, 1308, 1313, 1322, 1334
//            AudioServicesPlaySystemSound(1105)
        }

    }
    
}

#Preview {
    ContentView()
}
