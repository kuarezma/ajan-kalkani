import SwiftUI
import AppKit
import IOKit.ps
import ServiceManagement

// MARK: - Süre Seçenekleri
enum ShieldDuration: Int, CaseIterable, Identifiable {
    case min15 = 900
    case min30 = 1800
    case hour1 = 3600
    case hour2 = 7200
    case hour4 = 14400
    case hour8 = 28800
    case infinite = 0

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .min15: return "15 dk"
        case .min30: return "30 dk"
        case .hour1: return "1 Saat"
        case .hour2: return "2 Saat"
        case .hour4: return "4 Saat"
        case .hour8: return "8 Saat"
        case .infinite: return "Süresiz"
        }
    }

    var subtitle: String {
        switch self {
        case .min15: return "Hızlı görev & derleme"
        case .min30: return "Orta ölçekli ajan turu"
        case .hour1: return "Standart kodlama seansı"
        case .hour2: return "Derin refactor & test"
        case .hour4: return "Uzun otonom ajan mesaisi"
        case .hour8: return "Gece boyu tam otonom"
        case .infinite: return "Ben kapatana kadar açık"
        }
    }
}

// MARK: - Çalışma Modları
enum ShieldMode: String, CaseIterable, Identifiable {
    case clamshellAgent = "clamshell"
    case fullPresentation = "display"
    case smartAgentWatch = "smart"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .clamshellAgent: return "Kapak Kapalı"
        case .fullPresentation: return "Ekran da Açık"
        case .smartAgentWatch: return "Ajan Gözcüsü"
        }
    }

    var icon: String {
        switch self {
        case .clamshellAgent: return "laptopcomputer.slash"
        case .fullPresentation: return "sparkles.tv"
        case .smartAgentWatch: return "cpu.fill"
        }
    }

    var description: String {
        switch self {
        case .clamshellAgent:
            return "Kapak kapansa da CPU, Wi-Fi ve Ajanlar tam hız çalışır; ekran kapanıp ısınmayı önler."
        case .fullPresentation:
            return "Hem kapak uykusunu hem de ekranın kararmasını tamamen engeller."
        case .smartAgentWatch:
            return "İzlenen tüm kodlama ve terminal ajanları görevini bitirdiğinde uykuyu serbest bırakır."
        }
    }
}

// MARK: - Ajan & Terminal Tanımlayıcıları (12 Kategori)
enum CodingAgentKind: String, CaseIterable, Identifiable {
    case claudeCode = "claude_code"
    case claudeTerminal = "claude_terminal"
    case codex = "codex_app"
    case codexTerminal = "codex_terminal"
    case agy = "agy_app"
    case agyTerminal = "agy_terminal"
    case cursor = "cursor_app"
    case cursorAgentTerminal = "cursor_agent_terminal"
    case opencode = "opencode_app"
    case opencodeTerminal = "opencode_terminal"
    case deepseekHarness = "deepseek_harness"
    case terminalApps = "terminal_apps"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .claudeCode: return "Claude Code"
        case .claudeTerminal: return "Claude Terminal"
        case .codex: return "Codex"
        case .codexTerminal: return "Codex Terminal"
        case .agy: return "AGY"
        case .agyTerminal: return "AGY Terminal"
        case .cursor: return "Cursor"
        case .cursorAgentTerminal: return "Cursor Agent CLI"
        case .opencode: return "OpenCode"
        case .opencodeTerminal: return "OpenCode Terminal"
        case .deepseekHarness: return "DeepSeek Harness"
        case .terminalApps: return "Terminal Havuzu"
        }
    }

    var categoryBadge: String {
        switch self {
        case .claudeCode, .codex, .agy, .cursor, .opencode, .deepseekHarness:
            return "MASAÜSTÜ / IDE"
        case .claudeTerminal, .codexTerminal, .agyTerminal, .cursorAgentTerminal, .opencodeTerminal:
            return "TERMİNAL / CLI"
        case .terminalApps:
            return "KABUK / TTY"
        }
    }

    var icon: String {
        switch self {
        case .claudeCode: return "sparkles.rectangle.stack.fill"
        case .claudeTerminal: return "apple.terminal.fill"
        case .codex: return "cube.transparent.fill"
        case .codexTerminal: return "chevron.left.forwardslash.chevron.right"
        case .agy: return "atom"
        case .agyTerminal: return "bolt.horizontal.circle.fill"
        case .cursor: return "cursorarrow.rays"
        case .cursorAgentTerminal: return "apple.terminal.on.rectangle.fill"
        case .opencode: return "square.stack.3d.up.fill"
        case .opencodeTerminal: return "greaterthan.square.fill"
        case .deepseekHarness: return "brain.head.profile"
        case .terminalApps: return "terminal.fill"
        }
    }

    var color: Color {
        switch self {
        case .claudeCode: return Color(red: 0.96, green: 0.58, blue: 0.28)
        case .claudeTerminal: return Color(red: 0.98, green: 0.72, blue: 0.32)
        case .codex: return Color(red: 0.16, green: 0.88, blue: 0.62)
        case .codexTerminal: return Color(red: 0.28, green: 0.95, blue: 0.72)
        case .agy: return Color(red: 0.18, green: 0.86, blue: 0.98)
        case .agyTerminal: return Color(red: 0.35, green: 0.68, blue: 1.00)
        case .cursor: return Color(red: 0.56, green: 0.48, blue: 0.98)
        case .cursorAgentTerminal: return Color(red: 0.74, green: 0.52, blue: 0.98)
        case .opencode: return Color(red: 0.28, green: 0.78, blue: 0.96)
        case .opencodeTerminal: return Color(red: 0.44, green: 0.86, blue: 0.98)
        case .deepseekHarness: return Color(red: 0.96, green: 0.42, blue: 0.68)
        case .terminalApps: return Color(red: 0.72, green: 0.82, blue: 0.92)
        }
    }

    var appPathToOpen: String? {
        switch self {
        case .claudeCode: return "/Applications/Claude.app"
        case .codex: return "/Applications/Codex.app"
        case .agy: return "/Applications/Antigravity.app"
        case .cursor: return "/Applications/Cursor.app"
        case .opencode: return "/Applications/OpenCode.app"
        case .deepseekHarness: return "/Applications/DeepSeek Harness.app"
        case .claudeTerminal, .codexTerminal, .agyTerminal, .cursorAgentTerminal, .opencodeTerminal, .terminalApps:
            return "/System/Applications/Utilities/Terminal.app"
        }
    }
}

struct AgentRuntimeStatus: Identifiable, Equatable {
    let kind: CodingAgentKind
    var instanceCount: Int
    var ttys: [String]
    var detail: String

    var id: String { kind.rawValue }
    var isRunning: Bool { instanceCount > 0 }
}

// MARK: - Uzaktan OTA Güncelleme Modeli
struct RemoteVersionManifest: Codable {
    let version: String
    let build: Int
    let released_at: String?
    let download_url: String?
    let tarball_url: String?
    let notes: String?
}

enum UpdateState: Equatable {
    case idle
    case checking
    case upToDate
    case updateAvailable(version: String, build: Int, notes: String)
    case installing(step: String)
    case failed(String)
}

// MARK: - Sekmeler
enum DashboardTab: String, CaseIterable, Identifiable {
    case shield = "Kalkan"
    case radar = "Ajan Radarı"
    case settings = "Ayarlar"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .shield: return "bolt.shield.fill"
        case .radar: return "dot.radiowaves.left.and.right"
        case .settings: return "slider.horizontal.3"
        }
    }
}

// MARK: - Ana Kontrol Motoru (ShieldEngine)
@MainActor
final class ShieldEngine: ObservableObject {
    static let shared = ShieldEngine()

    @Published var isActive: Bool = false
    @Published var selectedDuration: ShieldDuration = .hour2
    @Published var selectedMode: ShieldMode = .clamshellAgent
    @Published var remainingSeconds: Int = 0
    @Published var totalSeconds: Int = 7200
    @Published var currentTab: DashboardTab = .shield

    // Ayarlar
    @Published var showMenuBarTimer: Bool = true {
        didSet {
            UserDefaults.standard.set(showMenuBarTimer, forKey: "showMenuBarTimer")
            onStatusBarUpdate?()
        }
    }
    @Published var showInDock: Bool = true {
        didSet {
            UserDefaults.standard.set(showInDock, forKey: "showInDock")
            NSApp.setActivationPolicy(showInDock ? .regular : .accessory)
        }
    }
    @Published var autoActivateOnAgent: Bool = false {
        didSet {
            UserDefaults.standard.set(autoActivateOnAgent, forKey: "autoActivateOnAgent")
        }
    }
    @Published var batterySafetyEnabled: Bool = true {
        didSet { UserDefaults.standard.set(batterySafetyEnabled, forKey: "batterySafetyEnabled") }
    }
    @Published var batterySafetyThreshold: Int = 15 {
        didSet { UserDefaults.standard.set(batterySafetyThreshold, forKey: "batterySafetyThreshold") }
    }
    @Published var soundEffectsEnabled: Bool = true {
        didSet { UserDefaults.standard.set(soundEffectsEnabled, forKey: "soundEffectsEnabled") }
    }
    @Published var autoInstallUpdates: Bool = true {
        didSet { UserDefaults.standard.set(autoInstallUpdates, forKey: "autoInstallUpdates") }
    }
    @Published var launchAtLogin: Bool = false

    // OTA Güncelleme Durumu
    let currentVersionString: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "3.2.0"
    let currentBuildNumber: Int = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "320") ?? 320
    @Published var updateState: UpdateState = .idle
    @Published var latestManifest: RemoteVersionManifest? = nil
    @Published var lastUpdateCheckText: String = "Henüz kontrol edilmedi"
    private var isUpdatingAndRestarting: Bool = false
    private var updateCheckTimer: Timer?

    // İzlenen Ajan Filtresi
    @Published var watchedAgentKinds: Set<CodingAgentKind> = Set(CodingAgentKind.allCases.filter { $0 != .terminalApps })

    // Canlı Sistem & Ajan Telemetrisi
    @Published var hardwareSleepDisabled: Bool = false
    @Published var batteryLevel: Int = 100
    @Published var isCharging: Bool = true
    @Published var agentStatuses: [AgentRuntimeStatus] = CodingAgentKind.allCases.map {
        AgentRuntimeStatus(kind: $0, instanceCount: 0, ttys: [], detail: "Beklemede")
    }
    @Published var statusMessage: String = "Kalkan hazır. Tek dokunuşla kapak korumasını başlatın."

    var onStatusBarUpdate: (() -> Void)?

    private var caffeinateProcess: Process?
    private var countdownTimer: Timer?
    private var telemetryTimer: Timer?
    private var idleAgentEmptyCount: Int = 0

    var activeCodingAgentsCount: Int {
        agentStatuses
            .filter { $0.kind != .terminalApps && $0.isRunning }
            .reduce(0) { $0 + $1.instanceCount }
    }

    private init() {
        if UserDefaults.standard.object(forKey: "showMenuBarTimer") != nil {
            self.showMenuBarTimer = UserDefaults.standard.bool(forKey: "showMenuBarTimer")
        }
        if UserDefaults.standard.object(forKey: "showInDock") != nil {
            self.showInDock = UserDefaults.standard.bool(forKey: "showInDock")
        }
        if UserDefaults.standard.object(forKey: "autoActivateOnAgent") != nil {
            self.autoActivateOnAgent = UserDefaults.standard.bool(forKey: "autoActivateOnAgent")
        }
        if UserDefaults.standard.object(forKey: "batterySafetyEnabled") != nil {
            self.batterySafetyEnabled = UserDefaults.standard.bool(forKey: "batterySafetyEnabled")
        }
        let savedThreshold = UserDefaults.standard.integer(forKey: "batterySafetyThreshold")
        if savedThreshold >= 5 && savedThreshold <= 50 {
            self.batterySafetyThreshold = savedThreshold
        }
        if UserDefaults.standard.object(forKey: "soundEffectsEnabled") != nil {
            self.soundEffectsEnabled = UserDefaults.standard.bool(forKey: "soundEffectsEnabled")
        }
        if UserDefaults.standard.object(forKey: "autoInstallUpdates") != nil {
            self.autoInstallUpdates = UserDefaults.standard.bool(forKey: "autoInstallUpdates")
        }

        checkLaunchAtLoginStatus()
        restoreSessionIfUpdated()
        refreshSystemTelemetry()
        startTelemetryLoop()
        startUpdateCheckLoop()
    }

    // MARK: - Güncelleme Sonrası Aktif Kalkan Oturumunu Kaldığı Saniyeden Devam Ettir
    private func restoreSessionIfUpdated() {
        if UserDefaults.standard.bool(forKey: "resumeShieldAfterUpdate") {
            UserDefaults.standard.set(false, forKey: "resumeShieldAfterUpdate")
            let savedDurRaw = UserDefaults.standard.integer(forKey: "resumeDurationRaw")
            let savedRem = UserDefaults.standard.integer(forKey: "resumeRemainingSeconds")
            let savedTot = UserDefaults.standard.integer(forKey: "resumeTotalSeconds")
            let savedModeRaw = UserDefaults.standard.string(forKey: "resumeModeRaw") ?? ShieldMode.clamshellAgent.rawValue
            let updatedToVer = UserDefaults.standard.string(forKey: "updatedToVersionString") ?? currentVersionString

            if let mode = ShieldMode(rawValue: savedModeRaw) {
                self.selectedMode = mode
            }
            if let dur = ShieldDuration(rawValue: savedDurRaw) {
                self.selectedDuration = dur
            }
            self.totalSeconds = savedTot
            self.remainingSeconds = savedRem
            _ = setPmsetSleepDisabled(true)
            startCaffeinateProcess()
            self.isActive = true
            self.hardwareSleepDisabled = true
            self.statusMessage = "v\(updatedToVer) sürümüne güncellendi • Kalkan kesintisiz devam ediyor"
            startCountdownLoop()
            onStatusBarUpdate?()
        }
    }

    // MARK: - Otomatik OTA Güncelleme Motoru (GitHub)
    private func startUpdateCheckLoop() {
        // Açılıştan 4 saniye sonra ilk kontrolü yap, ardından her 30 dakikada bir denetle
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            self?.checkForUpdates(userInitiated: false)
        }
        updateCheckTimer = Timer.scheduledTimer(withTimeInterval: 1800.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkForUpdates(userInitiated: false)
            }
        }
        if let timer = updateCheckTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    func checkForUpdates(userInitiated: Bool = true) {
        if case .installing = updateState { return }
        if userInitiated {
            updateState = .checking
        }

        let ts = Int(Date().timeIntervalSince1970)
        guard let url = URL(string: "https://raw.githubusercontent.com/kuarezma/ajan-kalkani/main/version.json?t=\(ts)") else {
            return
        }

        var req = URLRequest(url: url)
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        req.timeoutInterval = 12

        URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let timeStr = formatter.string(from: Date())

                guard error == nil,
                      let http = response as? HTTPURLResponse, http.statusCode == 200,
                      let data = data,
                      let manifest = try? JSONDecoder().decode(RemoteVersionManifest.self, from: data) else {
                    if userInitiated {
                        self.updateState = .failed("Güncelleme sunucusuna ulaşılamadı")
                    }
                    return
                }

                self.latestManifest = manifest
                self.lastUpdateCheckText = "Son kontrol: \(timeStr)"

                if manifest.build > self.currentBuildNumber {
                    let notes = manifest.notes ?? "Performans ve kararlılık iyileştirmeleri."
                    self.updateState = .updateAvailable(version: manifest.version, build: manifest.build, notes: notes)

                    if self.autoInstallUpdates && !userInitiated {
                        self.performInAppUpdate()
                    }
                } else {
                    self.updateState = .upToDate
                }
            }
        }.resume()
    }

    func performInAppUpdate() {
        let targetVersion = latestManifest?.version ?? "Yeni"
        let tarballURL = latestManifest?.tarball_url ?? "https://github.com/kuarezma/ajan-kalkani/archive/refs/heads/main.tar.gz"
        let releaseZipURL = latestManifest?.download_url ?? "https://github.com/kuarezma/ajan-kalkani/releases/latest/download/AjanKalkani.app.zip"

        updateState = .installing(step: "GitHub'dan yeni sürüm indiriliyor...")
        statusMessage = "v\(targetVersion) sürümü indiriliyor ve kuruluyor..."

        // Eğer kalkan şu an aktifse durumu kaydet ki güncelleme bitip yeniden başladığında kaldığı yerden devam etsin
        if isActive {
            UserDefaults.standard.set(true, forKey: "resumeShieldAfterUpdate")
            UserDefaults.standard.set(selectedDuration.rawValue, forKey: "resumeDurationRaw")
            UserDefaults.standard.set(remainingSeconds, forKey: "resumeRemainingSeconds")
            UserDefaults.standard.set(totalSeconds, forKey: "resumeTotalSeconds")
            UserDefaults.standard.set(selectedMode.rawValue, forKey: "resumeModeRaw")
            UserDefaults.standard.set(targetVersion, forKey: "updatedToVersionString")
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let script = """
            set -e
            STAGE="/tmp/ajan_kalkani_ota_$$"
            rm -rf "$STAGE"
            mkdir -p "$STAGE"
            cd "$STAGE"

            APP_BUNDLE="/Applications/Ajan Kalkanı.app"

            # 1. Önce hazır imzalı Release ZIP paketi var mı dene
            if curl -fsSL --max-time 20 "\(releaseZipURL)" -o app.zip 2>/dev/null && unzip -q app.zip 2>/dev/null && [ -d "Ajan Kalkanı.app" ]; then
                rm -rf "$APP_BUNDLE"
                cp -R "Ajan Kalkanı.app" "$APP_BUNDLE"
                codesign --force --deep --sign - "$APP_BUNDLE"
            else
                # 2. Yoksa GitHub main dalından kaynak kodu çekip 1.5 saniyede Native Swift 6 ile derle ve kur
                curl -fsSL --max-time 25 "\(tarballURL)" -o src.tar.gz
                tar -xzf src.tar.gz
                cd ajan-kalkani-*
                mkdir -p build
                swiftc -O -parse-as-library ./Sources/AjanKalkaniApp.swift -o ./build/AjanKalkani -framework SwiftUI -framework AppKit -framework IOKit -framework ServiceManagement
                mkdir -p "$APP_BUNDLE/Contents/MacOS" "$APP_BUNDLE/Contents/Resources"
                cp ./build/AjanKalkani "$APP_BUNDLE/Contents/MacOS/AjanKalkani"
                cp ./Resources/Info.plist "$APP_BUNDLE/Contents/Info.plist"
                cp ./Resources/AppIcon.icns "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
                codesign --force --deep --sign - "$APP_BUNDLE"
            fi

            rm -rf "$STAGE"
            """

            let proc = Process()
            proc.executableURL = URL(fileURLWithPath: "/bin/bash")
            proc.arguments = ["-c", script]
            let pipe = Pipe()
            proc.standardOutput = pipe
            proc.standardError = pipe

            do {
                try proc.run()
                _ = pipe.fileHandleForReading.readDataToEndOfFile()
                proc.waitUntilExit()

                if proc.terminationStatus == 0 {
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        self.updateState = .installing(step: "Kurulum tamamlandı, yeniden başlatılıyor...")
                        self.playSound(named: "Hero")
                        self.sendUserNotification(
                            title: "Ajan Kalkanı Güncellendi (v\(targetVersion))",
                            body: "Yeni sürüm başarıyla kuruldu ve yeniden başlatıldı."
                        )
                        self.isUpdatingAndRestarting = true

                        // 0.4 sn sonra yeni sürümü başlat ve mevcut süreci sonlandır
                        let relaunch = Process()
                        relaunch.executableURL = URL(fileURLWithPath: "/bin/sh")
                        relaunch.arguments = ["-c", "sleep 0.4 && open -a \"/Applications/Ajan Kalkanı.app\""]
                        try? relaunch.run()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            NSApplication.shared.terminate(nil)
                        }
                    }
                } else {
                    Task { @MainActor [weak self] in
                        self?.updateState = .failed("Güncelleme kurulumu başarısız oldu")
                    }
                }
            } catch {
                Task { @MainActor [weak self] in
                    self?.updateState = .failed("Güncelleme hatası: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Başlat / Durdur / Süre Değiştir
    func toggleShield() {
        if isActive {
            deactivateShield(reason: "Kalkan kullanıcı tarafından durduruldu.")
        } else {
            activateShield(duration: selectedDuration)
        }
    }

    func activateShield(duration: ShieldDuration) {
        selectedDuration = duration
        totalSeconds = duration.rawValue
        remainingSeconds = duration.rawValue
        idleAgentEmptyCount = 0

        let pmsetOk = setPmsetSleepDisabled(true)
        startCaffeinateProcess()

        isActive = true
        hardwareSleepDisabled = pmsetOk
        statusMessage = duration == .infinite
            ? "Kapak Kalkanı SÜRESİZ aktif • Kapağı kapatabilirsiniz"
            : "Kapak Kalkanı \(duration.title) boyunca aktif • Kapağı kapatabilirsiniz"

        playSound(named: "Hero")
        startCountdownLoop()
        refreshSystemTelemetry()
        onStatusBarUpdate?()
    }

    func deactivateShield(reason: String = "Kalkan devre dışı bırakıldı.") {
        stopCountdownLoop()
        stopCaffeinateProcess()
        _ = setPmsetSleepDisabled(false)

        isActive = false
        hardwareSleepDisabled = false
        remainingSeconds = 0
        statusMessage = reason

        playSound(named: "Glass")
        refreshSystemTelemetry()
        onStatusBarUpdate?()
    }

    func selectDuration(_ duration: ShieldDuration) {
        selectedDuration = duration
        if isActive {
            totalSeconds = duration.rawValue
            remainingSeconds = duration.rawValue
            statusMessage = duration == .infinite
                ? "Süre SÜRESİZ olarak güncellendi • Kapağı kapatabilirsiniz"
                : "Süre \(duration.title) olarak güncellendi • Kapağı kapatabilirsiniz"
            playSound(named: "Tink")
            onStatusBarUpdate?()
        } else {
            activateShield(duration: duration)
        }
    }

    func addMinutes(_ minutes: Int) {
        guard isActive else { return }
        if selectedDuration == .infinite {
            selectedDuration = .hour1
            totalSeconds = 3600
            remainingSeconds = 3600
        } else {
            let delta = minutes * 60
            let newRemaining = max(60, remainingSeconds + delta)
            remainingSeconds = newRemaining
            totalSeconds = max(totalSeconds, newRemaining)
        }
        playSound(named: "Pop")
        onStatusBarUpdate?()
    }

    func selectMode(_ mode: ShieldMode) {
        selectedMode = mode
        if isActive {
            startCaffeinateProcess()
            playSound(named: "Tink")
            statusMessage = "\(mode.title) moduna geçildi."
        }
    }

    func toggleWatchedAgent(_ kind: CodingAgentKind) {
        if watchedAgentKinds.contains(kind) {
            watchedAgentKinds.remove(kind)
        } else {
            watchedAgentKinds.insert(kind)
        }
        playSound(named: "Tink")
    }

    func focusOrLaunchAgent(_ kind: CodingAgentKind) {
        if let path = kind.appPathToOpen, FileManager.default.fileExists(atPath: path) {
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    }

    // MARK: - Sayaç ve İlerleme Hesaplamaları
    var progressFraction: Double {
        guard isActive else { return 0.0 }
        if selectedDuration == .infinite { return 1.0 }
        guard totalSeconds > 0 else { return 0.0 }
        return min(1.0, max(0.0, Double(remainingSeconds) / Double(totalSeconds)))
    }

    var formattedRemainingTime: String {
        guard isActive else { return "KAPALI" }
        if selectedDuration == .infinite { return "SÜRESİZ" }
        let hrs = remainingSeconds / 3600
        let mins = (remainingSeconds % 3600) / 60
        let secs = remainingSeconds % 60
        if hrs > 0 {
            return String(format: "%02d:%02d:%02d", hrs, mins, secs)
        } else {
            return String(format: "%02d:%02d", mins, secs)
        }
    }

    var compactMenuBarTime: String {
        guard isActive, showMenuBarTimer else { return "" }
        if selectedDuration == .infinite { return " ∞" }
        let hrs = remainingSeconds / 3600
        let mins = (remainingSeconds % 3600) / 60
        let secs = remainingSeconds % 60
        if hrs > 0 {
            return String(format: " %d:%02d", hrs, mins)
        } else {
            return String(format: " %02d:%02d", mins, secs)
        }
    }

    // MARK: - Zamanlayıcı Döngüsü
    private func startCountdownLoop() {
        stopCountdownLoop()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tickSecond()
            }
        }
        if let timer = countdownTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    private func stopCountdownLoop() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }

    private func tickSecond() {
        guard isActive else { return }

        if selectedDuration != .infinite {
            if remainingSeconds > 1 {
                remainingSeconds -= 1
                onStatusBarUpdate?()
            } else {
                deactivateShield(reason: "Süre tamamlandı, Mac normal uyku moduna döndü.")
                sendUserNotification(
                    title: "Ajan Kalkanı Süresi Doldu",
                    body: "Seçtiğiniz koruma süresi tamamlandı. MacBook normal uyku moduna geri döndü."
                )
                return
            }
        }
    }

    // MARK: - Sistem & Ajan Telemetri Döngüsü
    private func startTelemetryLoop() {
        telemetryTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.refreshSystemTelemetry()
            }
        }
        if let timer = telemetryTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    func refreshSystemTelemetry() {
        updateBatteryInfo()

        let currentlyActive = isActive
        let currentMode = selectedMode
        let batEnabled = batterySafetyEnabled
        let batCharging = isCharging
        let batLevel = batteryLevel
        let batThreshold = batterySafetyThreshold

        if currentlyActive && batEnabled && !batCharging && batLevel <= batThreshold {
            deactivateShield(reason: "Düşük pil koruması (%\(batLevel)): Uyku kilidi güvenle açıldı.")
            sendUserNotification(
                title: "Düşük Pil Koruması Devrede",
                body: "Pil seviyesi %\(batLevel) altına düştüğü için Kapak Kalkanı güvenle kapatıldı."
            )
            return
        }

        DispatchQueue.global(qos: .utility).async { [weak self] in
            let sleepDis = Self.checkPmsetSleepDisabledSync()
            let statuses = Self.scanAllAgentsAndTerminalsSync()

            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.hardwareSleepDisabled = sleepDis
                self.agentStatuses = statuses

                if self.isActive && !sleepDis {
                    _ = self.setPmsetSleepDisabled(true)
                    self.hardwareSleepDisabled = true
                }

                let watchedRunning = statuses.contains { status in
                    self.watchedAgentKinds.contains(status.kind) && status.isRunning
                }

                if !self.isActive && self.autoActivateOnAgent && watchedRunning {
                    self.activateShield(duration: self.selectedDuration)
                    self.statusMessage = "Aktif kodlama ajanı algılandı, kalkan otomatik açıldı."
                }

                if self.isActive && currentMode == .smartAgentWatch {
                    if !watchedRunning {
                        self.idleAgentEmptyCount += 1
                        if self.idleAgentEmptyCount >= 8 {
                            self.deactivateShield(reason: "Tüm izlenen kodlama ajanları görevini tamamladı.")
                            self.sendUserNotification(
                                title: "Kodlama Ajanları Tamamlandı",
                                body: "Aktif ajan kalmadığı için MacBook uyku koruması otomatik kapatıldı."
                            )
                        }
                    } else {
                        self.idleAgentEmptyCount = 0
                    }
                }
            }
        }
    }

    // MARK: - 12'li Ajan & Terminal Derin Radar Tarayıcısı
    nonisolated private static func scanAllAgentsAndTerminalsSync() -> [AgentRuntimeStatus] {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/bin/ps")
        proc.arguments = ["-axo", "pid=,tty=,comm=,args="]
        let pipe = Pipe()
        proc.standardOutput = pipe
        proc.standardError = Pipe()

        var counts: [CodingAgentKind: Int] = [:]
        var ttyMap: [CodingAgentKind: Set<String>] = [:]
        var terminalNames = Set<String>()
        var allTtys = Set<String>()

        for kind in CodingAgentKind.allCases {
            counts[kind] = 0
            ttyMap[kind] = []
        }

        do {
            try proc.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            proc.waitUntilExit()

            if let output = String(data: data, encoding: .utf8) {
                let lines = output.split(separator: "\n")
                for rawLine in lines {
                    let line = rawLine.trimmingCharacters(in: .whitespaces)
                    guard !line.isEmpty else { continue }

                    let parts = line.split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
                    guard parts.count >= 3 else { continue }

                    let tty = String(parts[1])
                    let comm = String(parts[2])
                    let args = parts.count == 4 ? String(parts[3]) : comm
                    let lowerArgs = args.lowercased()
                    let lowerComm = (comm as NSString).lastPathComponent.lowercased()

                    if lowerArgs.contains("ajankalkani") || lowerArgs.contains("cursoruiviewservice") || lowerArgs.contains("claude code url handler") {
                        continue
                    }

                    let hasRealTty = tty != "??" && !tty.isEmpty
                    if hasRealTty {
                        allTtys.insert(tty)
                    }

                    // 1 & 2: Claude Code (App) vs Claude Terminal (CLI)
                    if lowerArgs.contains("/claude.app/contents/macos/claude") {
                        counts[.claudeCode, default: 0] += 1
                    } else if lowerComm == "claude" || lowerArgs.contains("/.local/bin/claude") || lowerArgs.contains("/.local/share/claude/") || lowerArgs.contains("claude-science") {
                        if !lowerComm.hasSuffix("sh") && lowerComm != "script" {
                            counts[.claudeTerminal, default: 0] += 1
                            if hasRealTty { ttyMap[.claudeTerminal, default: []].insert(tty) }
                        } else if lowerArgs.contains("claude remote-control") && lowerComm == "script" {
                            counts[.claudeTerminal, default: 0] += 1
                        }
                    }

                    // 3 & 4: Codex (App/Host) vs Codex Terminal (CLI)
                    if lowerArgs.contains("/codex.app/contents/macos/") || lowerArgs.contains("codex-code-mode-host") {
                        counts[.codex, default: 0] += 1
                    } else if lowerComm == "codex" || lowerArgs.contains("/bin/codex") || lowerArgs.contains("codex-cli") {
                        if !lowerComm.hasSuffix("sh") && !lowerArgs.contains("codex-title-ratelimit") {
                            counts[.codexTerminal, default: 0] += 1
                            if hasRealTty { ttyMap[.codexTerminal, default: []].insert(tty) }
                        }
                    }

                    // 5 & 6: AGY (Antigravity App/Daemon) vs AGY Terminal (CLI)
                    if lowerArgs.contains("/antigravity.app/contents/macos/") || lowerArgs.contains("agy-hud-daemon") || lowerArgs.contains("agy-companion") {
                        if !lowerArgs.contains("helper") {
                            counts[.agy, default: 0] += 1
                        }
                    } else if lowerComm == "agy" || lowerComm == "agyc" || lowerArgs.contains("/.local/bin/agy") || lowerArgs.contains("antigravity-cli") {
                        if !lowerArgs.contains("agy-hud-daemon") && !lowerArgs.contains("agy-notify") && !lowerArgs.contains("agy-checkpoint") && !lowerArgs.contains("agy-quota") && !lowerComm.hasSuffix("sh") {
                            counts[.agyTerminal, default: 0] += 1
                            if hasRealTty { ttyMap[.agyTerminal, default: []].insert(tty) }
                        }
                    }

                    // 7 & 8: Cursor (IDE App) vs Cursor Agent Terminal (CLI)
                    if lowerArgs.contains("/cursor.app/contents/macos/cursor") && !lowerArgs.contains("cursor helper") {
                        counts[.cursor, default: 0] += 1
                    } else if lowerComm == "cursor-agent" || lowerArgs.contains("/cursor-agent/") || lowerArgs.contains("/.local/bin/agent") {
                        if !lowerComm.hasSuffix("sh") {
                            counts[.cursorAgentTerminal, default: 0] += 1
                            if hasRealTty { ttyMap[.cursorAgentTerminal, default: []].insert(tty) }
                        }
                    }

                    // 9 & 10: OpenCode (App) vs OpenCode Terminal (CLI)
                    if lowerArgs.contains("/opencode.app/contents/macos/") && !lowerArgs.contains("helper") {
                        counts[.opencode, default: 0] += 1
                    } else if lowerComm == "opencode" || lowerArgs.contains("/bin/opencode") || lowerArgs.contains("/.opencode/bin/opencode") {
                        if !lowerComm.hasSuffix("sh") {
                            counts[.opencodeTerminal, default: 0] += 1
                            if hasRealTty { ttyMap[.opencodeTerminal, default: []].insert(tty) }
                        }
                    }

                    // 11: DeepSeek Harness (App & CLI)
                    if lowerArgs.contains("/deepseek harness.app/contents/macos/deepseek harness") || lowerComm == "deepseek-harness" || lowerComm == "dsh" {
                        if !lowerArgs.contains("helper") {
                            counts[.deepseekHarness, default: 0] += 1
                            if hasRealTty { ttyMap[.deepseekHarness, default: []].insert(tty) }
                        }
                    }

                    // 12: Terminal Uygulamaları
                    if lowerArgs.contains("/terminal.app/contents/macos/terminal") {
                        counts[.terminalApps, default: 0] += 1
                        terminalNames.insert("Terminal")
                    } else if lowerArgs.contains("/iterm.app/contents/macos/iterm2") {
                        counts[.terminalApps, default: 0] += 1
                        terminalNames.insert("iTerm2")
                    } else if lowerArgs.contains("/warp.app/contents/macos/") && !lowerArgs.contains("helper") {
                        counts[.terminalApps, default: 0] += 1
                        terminalNames.insert("Warp")
                    } else if lowerArgs.contains("/ghostty.app/contents/macos/ghostty") {
                        counts[.terminalApps, default: 0] += 1
                        terminalNames.insert("Ghostty")
                    } else if lowerComm == "tmux" || lowerComm == "cmux" {
                        counts[.terminalApps, default: 0] += 1
                        terminalNames.insert(lowerComm.uppercased())
                    }
                }
            }
        } catch {}

        return CodingAgentKind.allCases.map { kind in
            let count = counts[kind] ?? 0
            let ttys = Array(ttyMap[kind] ?? []).sorted()

            // Kısa, kesilmeyen, jilet gibi hizalı durum metinleri
            let detailText: String
            if kind == .terminalApps {
                if count > 0 {
                    let names = terminalNames.sorted().joined(separator: "+")
                    detailText = "\(names) • \(allTtys.count) TTY"
                } else {
                    detailText = "Açık terminal yok"
                }
            } else if count > 0 {
                if ttys.count == 1, let first = ttys.first {
                    detailText = "\(count) oturum (\(first))"
                } else if ttys.count > 1, let first = ttys.first, let last = ttys.last {
                    let shortLast = last.replacingOccurrences(of: "ttys", with: "")
                    detailText = "\(count) oturum (\(first)..\(shortLast))"
                } else {
                    detailText = "\(count) aktif süreç"
                }
            } else {
                detailText = "Beklemede"
            }

            return AgentRuntimeStatus(
                kind: kind,
                instanceCount: count,
                ttys: ttys,
                detail: detailText
            )
        }
    }

    // MARK: - Donanım Komutları (pmset & caffeinate)
    @discardableResult
    private func setPmsetSleepDisabled(_ disable: Bool) -> Bool {
        let flag = disable ? "1" : "0"
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
        proc.arguments = ["-n", "/usr/bin/pmset", "disablesleep", flag]
        let pipe = Pipe()
        proc.standardOutput = pipe
        proc.standardError = pipe

        do {
            try proc.run()
            _ = pipe.fileHandleForReading.readDataToEndOfFile()
            proc.waitUntilExit()
            if proc.terminationStatus == 0 {
                return true
            }
        } catch {}

        let scriptSource = "do shell script \"/usr/bin/pmset disablesleep \(flag)\" with administrator privileges"
        if let appleScript = NSAppleScript(source: scriptSource) {
            var errorDict: NSDictionary? = nil
            appleScript.executeAndReturnError(&errorDict)
            return errorDict == nil
        }
        return false
    }

    nonisolated private static func checkPmsetSleepDisabledSync() -> Bool {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        proc.arguments = ["-g"]
        let outPipe = Pipe()
        proc.standardOutput = outPipe
        proc.standardError = Pipe()
        do {
            try proc.run()
            let data = outPipe.fileHandleForReading.readDataToEndOfFile()
            proc.waitUntilExit()
            if let output = String(data: data, encoding: .utf8) {
                return output.range(of: #"SleepDisabled\s+1"#, options: .regularExpression) != nil
            }
        } catch {}
        return false
    }

    private func startCaffeinateProcess() {
        stopCaffeinateProcess()
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        switch selectedMode {
        case .clamshellAgent, .smartAgentWatch:
            proc.arguments = ["-ims"]
        case .fullPresentation:
            proc.arguments = ["-dims"]
        }
        do {
            try proc.run()
            caffeinateProcess = proc
        } catch {}
    }

    private func stopCaffeinateProcess() {
        if let proc = caffeinateProcess, proc.isRunning {
            proc.terminate()
        }
        caffeinateProcess = nil
    }

    // MARK: - Pil Bilgisi (IOKit)
    private func updateBatteryInfo() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else {
            return
        }

        for ps in sources {
            if let info = IOPSGetPowerSourceDescription(snapshot, ps)?.takeUnretainedValue() as? [String: Any] {
                if let capacity = info[kIOPSCurrentCapacityKey as String] as? Int {
                    self.batteryLevel = capacity
                }
                if let state = info[kIOPSPowerSourceStateKey as String] as? String {
                    self.isCharging = (state == kIOPSACPowerValue as String)
                }
            }
        }
    }

    // MARK: - Başlangıçta Otomatik Açılma (LaunchAgent)
    private var launchAgentURL: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/LaunchAgents/dev.ajankalkani.app.plist")
    }

    func checkLaunchAtLoginStatus() {
        launchAtLogin = FileManager.default.fileExists(atPath: launchAgentURL.path)
    }

    func toggleLaunchAtLogin() {
        if launchAtLogin {
            try? FileManager.default.removeItem(at: launchAgentURL)
            launchAtLogin = false
        } else {
            let appPath = "/Applications/Ajan Kalkanı.app/Contents/MacOS/AjanKalkani"
            let plistContent = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
                <key>Label</key>
                <string>dev.ajankalkani.app</string>
                <key>ProgramArguments</key>
                <array>
                    <string>\(appPath)</string>
                </array>
                <key>RunAtLoad</key>
                <true/>
                <key>KeepAlive</key>
                <false/>
            </dict>
            </plist>
            """
            try? FileManager.default.createDirectory(
                at: launchAgentURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try? plistContent.write(to: launchAgentURL, atomically: true, encoding: .utf8)
            launchAtLogin = true
        }
        playSound(named: "Tink")
    }

    // MARK: - Yardımcılar
    private func playSound(named name: String) {
        guard soundEffectsEnabled else { return }
        NSSound(named: NSSound.Name(name))?.play()
    }

    private func sendUserNotification(title: String, body: String) {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        proc.arguments = ["-e", "display notification \"\(body)\" with title \"\(title)\" sound name \"Glass\""]
        try? proc.run()
    }

    func cleanupBeforeExit() {
        stopCaffeinateProcess()
        // Eğer uygulama kendi kendini güncelliyorsa kapak uykusu kilidini koru; yeni sürüm 0.4sn içinde devralacak
        if !isUpdatingAndRestarting && (isActive || hardwareSleepDisabled) {
            _ = setPmsetSleepDisabled(false)
        }
    }
}

// MARK: - Görsel Ana Arayüz (Sıfır Kaymalı Sabit Izgara Tasarımı)
struct ShieldControlPopoverView: View {
    @ObservedObject var engine: ShieldEngine
    @State private var pulseAnimation: Bool = false
    @State private var ringRotation: Double = 0
    @State private var hoverPowerOrb: Bool = false

    private let accentCyan = Color(red: 0.16, green: 0.88, blue: 0.76)
    private let accentIndigo = Color(red: 0.39, green: 0.40, blue: 0.98)
    private let darkBgTop = Color(red: 0.06, green: 0.07, blue: 0.12)
    private let darkBgBottom = Color(red: 0.03, green: 0.04, blue: 0.07)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [darkBgTop, darkBgBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(
                    RadialGradient(
                        colors: engine.isActive
                            ? [accentCyan.opacity(0.20), accentIndigo.opacity(0.09), .clear]
                            : [accentIndigo.opacity(0.08), .clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 230
                    )
                )
                .frame(width: 420, height: 420)
                .offset(y: -85)
                .scaleEffect(pulseAnimation && engine.isActive ? 1.06 : 0.95)
                .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true), value: pulseAnimation)
                .allowsHitTesting(false)

            VStack(spacing: 12) {
                headerBar
                tabSelectorBar

                ZStack(alignment: .top) {
                    switch engine.currentTab {
                    case .shield:
                        mainDashboard
                    case .radar:
                        agentRadarMatrixView
                    case .settings:
                        settingsPanel
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                footerBar
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 14)
        }
        .frame(width: 436, height: 620)
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .onAppear {
            pulseAnimation = true
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                ringRotation = 360
            }
        }
    }

    // MARK: - Üst Başlık Barı (Sıfır Kaymalı Simetrik Düzen)
    private var headerBar: some View {
        HStack(spacing: 11) {
            ZStack {
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: engine.isActive
                                ? [accentCyan, accentIndigo]
                                : [Color.white.opacity(0.12), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)
                    .shadow(color: engine.isActive ? accentCyan.opacity(0.45) : .clear, radius: 8)

                Image(systemName: engine.isActive ? "bolt.shield.fill" : "shield.lefthalf.filled")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(engine.isActive ? .black : .white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 7) {
                    Text("AJAN KALKANI")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .tracking(0.6)
                        .foregroundColor(.white)
                        .fixedSize()

                    Text(engine.isActive ? "KORUMA AKTİF" : "BEKLEMEDE")
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2.5)
                        .background(
                            Capsule()
                                .fill(engine.isActive ? accentCyan.opacity(0.22) : Color.white.opacity(0.09))
                        )
                        .foregroundColor(engine.isActive ? accentCyan : .white.opacity(0.6))
                        .fixedSize()
                }

                Text("Otonom Kodlama & Terminal Uyku Koruyucu")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.58))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }

            Spacer(minLength: 6)

            // Yeni güncelleme varsa başlıkta parlayan tek tık "Güncelle" rozeti göster
            if case .updateAvailable(let newVer, _, _) = engine.updateState {
                Button {
                    engine.performInAppUpdate()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 11, weight: .bold))
                        Text("v\(newVer)")
                            .font(.system(size: 10, weight: .black, design: .rounded))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5.5)
                    .background(Capsule().fill(accentCyan))
                }
                .buttonStyle(.plain)
                .help("Yeni sürümü hemen indir ve otomatik kur")
            }

            // Sağ Üst Menü Çubuğuna Küçült / Gizle butonu
            Button {
                NSApp.keyWindow?.orderOut(nil)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "menubar.arrow.up.rectangle")
                        .font(.system(size: 12, weight: .bold))
                    Text("Gizle")
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                }
                .foregroundColor(accentCyan)
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(accentCyan.opacity(0.13))
                        .overlay(Capsule().stroke(accentCyan.opacity(0.35), lineWidth: 1))
                )
            }
            .buttonStyle(.plain)
            .help("Pencereyi gizle (Sağ üst menü çubuğundan her an açabilirsiniz)")
        }
        .frame(height: 40)
    }

    // MARK: - 3'lü Sekme Çubuğu (Sabit Genişlikli & Titremesiz)
    private var tabSelectorBar: some View {
        HStack(spacing: 6) {
            ForEach(DashboardTab.allCases) { tab in
                let isSelected = (engine.currentTab == tab)
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.82)) {
                        engine.currentTab = tab
                    }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 11.5, weight: .bold))
                        Text(tab.rawValue)
                            .font(.system(size: 11.5, weight: isSelected ? .heavy : .semibold, design: .rounded))
                            .lineLimit(1)
                            .fixedSize()

                        if tab == .radar {
                            Text("\(engine.activeCodingAgentsCount)")
                                .font(.system(size: 9.5, weight: .black, design: .monospaced))
                                .frame(minWidth: 18)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1.5)
                                .background(
                                    Capsule()
                                        .fill(engine.activeCodingAgentsCount > 0 ? accentCyan : Color.white.opacity(0.15))
                                )
                                .foregroundColor(engine.activeCodingAgentsCount > 0 ? .black : .white.opacity(0.75))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .fill(isSelected ? Color.white.opacity(0.12) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .stroke(isSelected ? accentCyan.opacity(0.45) : Color.clear, lineWidth: 1)
                    )
                    .foregroundColor(isSelected ? .white : .white.opacity(0.62))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }

    // MARK: - SEKME 1: Ana Kalkan Kontrol Paneli
    private var mainDashboard: some View {
        VStack(spacing: 11) {
            powerOrbSection
            durationSelectorSection
            modeSelectorSection
            activeAgentsQuickStrip
        }
    }

    // MARK: - Merkezdeki Nefes Alan Tek Tuş Güç Küresi (Power Orb)
    private var powerOrbSection: some View {
        VStack(spacing: 6) {
            HStack(spacing: 18) {
                // Sol Hızlı Süre Azalt (-15 dk) — Sabit genişlikli alan (Küre asla sağa/sola kaymaz!)
                Button {
                    engine.addMinutes(-15)
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "minus")
                            .font(.system(size: 9, weight: .black))
                        Text("15 dk")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white.opacity(0.85))
                    .frame(width: 68, height: 30)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                    )
                }
                .buttonStyle(.plain)
                .opacity(engine.isActive && engine.selectedDuration != .infinite ? 1.0 : 0.0)
                .disabled(!(engine.isActive && engine.selectedDuration != .infinite))

                // Merkezdeki Güç Küresi
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.06), lineWidth: 8)
                        .frame(width: 132, height: 132)

                    if engine.isActive {
                        Circle()
                            .trim(from: 0.0, to: CGFloat(max(0.04, engine.progressFraction)))
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [accentCyan, accentIndigo, accentCyan]),
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 132, height: 132)
                            .rotationEffect(.degrees(-90))
                            .shadow(color: accentCyan.opacity(0.5), radius: 8)
                            .animation(.easeInOut(duration: 0.4), value: engine.progressFraction)

                        Circle()
                            .strokeBorder(
                                AngularGradient(
                                    gradient: Gradient(colors: [.clear, accentCyan.opacity(0.6), .clear, accentIndigo.opacity(0.6), .clear]),
                                    center: .center
                                ),
                                lineWidth: 1.8
                            )
                            .frame(width: 146, height: 146)
                            .rotationEffect(.degrees(ringRotation))
                    }

                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            engine.toggleShield()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: engine.isActive
                                            ? [Color(red: 0.08, green: 0.25, blue: 0.28), Color(red: 0.07, green: 0.11, blue: 0.22)]
                                            : [Color.white.opacity(0.08), Color.white.opacity(0.03)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 112, height: 112)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: engine.isActive
                                                    ? [accentCyan.opacity(0.8), accentIndigo.opacity(0.5)]
                                                    : [Color.white.opacity(0.2), Color.white.opacity(0.05)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                                .shadow(
                                    color: engine.isActive ? accentCyan.opacity(0.32) : .black.opacity(0.4),
                                    radius: hoverPowerOrb ? 16 : 8
                                )

                            VStack(spacing: 3) {
                                Image(systemName: engine.isActive ? "lock.laptopcomputer" : "power")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(
                                        engine.isActive
                                            ? LinearGradient(colors: [accentCyan, .white], startPoint: .top, endPoint: .bottom)
                                            : LinearGradient(colors: [.white.opacity(0.85), .white.opacity(0.45)], startPoint: .top, endPoint: .bottom)
                                    )

                                Text(engine.formattedRemainingTime)
                                    .font(.system(size: 14.5, weight: .black, design: .monospaced))
                                    .foregroundColor(engine.isActive ? .white : .white.opacity(0.6))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                    .frame(width: 86)

                                Text(engine.isActive ? "DURDUR" : "BAŞLAT")
                                    .font(.system(size: 8.5, weight: .heavy, design: .rounded))
                                    .tracking(0.8)
                                    .foregroundColor(engine.isActive ? accentCyan : .white.opacity(0.45))
                            }
                        }
                        .scaleEffect(hoverPowerOrb ? 1.03 : 1.0)
                    }
                    .buttonStyle(.plain)
                    .onHover { hovering in
                        withAnimation(.easeOut(duration: 0.18)) {
                            hoverPowerOrb = hovering
                        }
                    }
                }
                .frame(width: 150, height: 150)

                // Sağ Hızlı Süre Artır (+15 dk) — Sabit genişlikli alan
                Button {
                    engine.addMinutes(15)
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "plus")
                            .font(.system(size: 9, weight: .black))
                        Text("15 dk")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(accentCyan)
                    .frame(width: 68, height: 30)
                    .background(
                        Capsule()
                            .fill(accentCyan.opacity(0.14))
                            .overlay(Capsule().stroke(accentCyan.opacity(0.35), lineWidth: 1))
                    )
                }
                .buttonStyle(.plain)
                .opacity(engine.isActive && engine.selectedDuration != .infinite ? 1.0 : 0.0)
                .disabled(!(engine.isActive && engine.selectedDuration != .infinite))
            }

            Text(engine.statusMessage)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(engine.isActive ? accentCyan.opacity(0.95) : .white.opacity(0.62))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
                .frame(height: 16)
        }
    }

    // MARK: - Süre Seçici Haplar
    private var durationSelectorSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Label("AÇIK KALMA SÜRESİ", systemImage: "timer")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(0.5)
                    .foregroundColor(.white.opacity(0.6))

                Spacer()

                Text(engine.selectedDuration.subtitle)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(accentCyan.opacity(0.9))
                    .lineLimit(1)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 7), count: 4), spacing: 7) {
                ForEach(ShieldDuration.allCases) { duration in
                    let isSelected = (engine.selectedDuration == duration)
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.78)) {
                            engine.selectDuration(duration)
                        }
                    } label: {
                        Text(duration.title)
                            .font(.system(size: 11.5, weight: isSelected ? .heavy : .semibold, design: .rounded))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 29)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(
                                        isSelected
                                            ? LinearGradient(colors: [accentCyan, accentIndigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)], startPoint: .top, endPoint: .bottom)
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(isSelected ? Color.white.opacity(0.35) : Color.white.opacity(0.07), lineWidth: 1)
                            )
                            .foregroundColor(isSelected ? .black : .white.opacity(0.88))
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.78)) {
                        engine.activateShield(duration: engine.selectedDuration)
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 10, weight: .bold))
                        Text("Şimdi")
                            .font(.system(size: 11.5, weight: .bold, design: .rounded))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 29)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(accentCyan.opacity(0.16))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(accentCyan.opacity(0.45), lineWidth: 1)
                    )
                    .foregroundColor(accentCyan)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(11)
        .background(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }

    // MARK: - Çalışma Modu Seçici (Sabit Yüksekli Açıklama Alanı — Zıplama Yok)
    private var modeSelectorSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 7) {
                ForEach(ShieldMode.allCases) { mode in
                    let isSelected = (engine.selectedMode == mode)
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            engine.selectMode(mode)
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: mode.icon)
                                .font(.system(size: 12, weight: .bold))
                            Text(mode.title)
                                .font(.system(size: 10.5, weight: .bold, design: .rounded))
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(isSelected ? accentIndigo.opacity(0.34) : Color.white.opacity(0.04))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(isSelected ? accentCyan.opacity(0.65) : Color.white.opacity(0.07), lineWidth: 1)
                        )
                        .foregroundColor(isSelected ? .white : .white.opacity(0.65))
                    }
                    .buttonStyle(.plain)
                }
            }

            Text(engine.selectedMode.description)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 26, alignment: .topLeading)
        }
        .padding(11)
        .background(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }

    // MARK: - Canlı Ajan & Terminal Hızlı Durum Kartı
    private var activeAgentsQuickStrip: some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                engine.currentTab = .radar
            }
        } label: {
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(engine.activeCodingAgentsCount > 0 ? accentCyan : Color.white.opacity(0.25))
                            .frame(width: 7, height: 7)
                            .shadow(color: engine.activeCodingAgentsCount > 0 ? accentCyan : .clear, radius: 4)

                        Text(
                            engine.activeCodingAgentsCount > 0
                                ? "CANLI RADAR: \(engine.activeCodingAgentsCount) Ajan Oturumu Çalışıyor"
                                : "CANLI RADAR: Aktif Kodlama Ajanı Yok"
                        )
                        .font(.system(size: 10.5, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    }

                    Spacer()

                    HStack(spacing: 3) {
                        Text("Tümünü Gör")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .foregroundColor(accentCyan)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        let runningList = engine.agentStatuses.filter { $0.isRunning }
                        if runningList.isEmpty {
                            Text("Herhangi bir ajan veya terminal başladığında burada canlı listelenir.")
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.45))
                        } else {
                            ForEach(runningList) { status in
                                HStack(spacing: 4) {
                                    Image(systemName: status.kind.icon)
                                        .font(.system(size: 9.5, weight: .bold))
                                        .foregroundColor(status.kind.color)
                                    Text(status.kind.displayName)
                                        .font(.system(size: 10, weight: .bold, design: .rounded))
                                        .foregroundColor(.white.opacity(0.92))
                                    Text("×\(status.instanceCount)")
                                        .font(.system(size: 9.5, weight: .black, design: .monospaced))
                                        .foregroundColor(status.kind.color)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(status.kind.color.opacity(0.14))
                                        .overlay(Capsule().stroke(status.kind.color.opacity(0.35), lineWidth: 0.8))
                                )
                            }
                        }
                    }
                }
                .frame(height: 24)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .stroke(engine.activeCodingAgentsCount > 0 ? accentCyan.opacity(0.32) : Color.white.opacity(0.07), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - SEKME 2: 12'li Ajan & Terminal Radar Matrisi (Sıfır Kesilmeli Kartlar)
    private var agentRadarMatrixView: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("KODLAMA AJANLARI & TERMİNAL HAVUZU")
                        .font(.system(size: 10.5, weight: .heavy, design: .rounded))
                        .tracking(0.5)
                        .foregroundColor(accentCyan)
                    Text("Göz simgesiyle izlemeye alın • Ok simgesiyle uygulamayı açın")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.55))
                }

                Spacer()

                Button {
                    engine.refreshSystemTelemetry()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 10, weight: .bold))
                        Text("Şimdi Tara")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.white.opacity(0.09)))
                    .foregroundColor(.white.opacity(0.9))
                }
                .buttonStyle(.plain)
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 7) {
                ForEach(engine.agentStatuses) { status in
                    agentRadarCard(status)
                }
            }
        }
    }

    private func agentRadarCard(_ status: AgentRuntimeStatus) -> some View {
        let isWatched = engine.watchedAgentKinds.contains(status.kind)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 7) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(status.isRunning ? status.kind.color.opacity(0.22) : Color.white.opacity(0.06))
                        .frame(width: 26, height: 26)

                    Image(systemName: status.kind.icon)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(status.isRunning ? status.kind.color : .white.opacity(0.42))
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(status.kind.displayName)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(status.isRunning ? .white : .white.opacity(0.72))
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)

                    Text(status.kind.categoryBadge)
                        .font(.system(size: 7.5, weight: .heavy, design: .monospaced))
                        .foregroundColor(status.kind.color.opacity(0.88))
                        .lineLimit(1)
                }

                Spacer(minLength: 2)

                if status.isRunning {
                    Text("×\(status.instanceCount)")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(status.kind.color))
                        .foregroundColor(.black)
                        .fixedSize()
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.16))
                        .frame(width: 7, height: 7)
                }
            }

            HStack(spacing: 5) {
                Text(status.detail)
                    .font(.system(size: 9.5, weight: .semibold, design: .rounded))
                    .foregroundColor(status.isRunning ? status.kind.color.opacity(0.95) : .white.opacity(0.40))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 2)

                if status.kind != .terminalApps {
                    Button {
                        engine.toggleWatchedAgent(status.kind)
                    } label: {
                        Image(systemName: isWatched ? "eye.fill" : "eye.slash")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(isWatched ? accentCyan : .white.opacity(0.3))
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .help(isWatched ? "Kalkan gözcüsünde izleniyor" : "İzleme dışı")
                }

                Button {
                    engine.focusOrLaunchAgent(status.kind)
                } label: {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .font(.system(size: 10.5, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.plain)
                .help("\(status.kind.displayName) uygulamasını/terminalini öne getir")
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7.5)
        .frame(height: 58)
        .background(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(status.isRunning ? status.kind.color.opacity(0.10) : Color.white.opacity(0.035))
                .overlay(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(
                            status.isRunning ? status.kind.color.opacity(0.48) : Color.white.opacity(0.06),
                            lineWidth: 1
                        )
                )
        )
    }

    // MARK: - SEKME 3: Ayarlar & Otomatik OTA Güncelleme Merkezi
    private var settingsPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            // OTA Otomatik Güncelleme Kartı
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(accentCyan.opacity(0.16))
                            .frame(width: 30, height: 30)
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(accentCyan)
                    }

                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 6) {
                            Text("Otomatik Güncelleme (OTA)")
                                .font(.system(size: 11.5, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .fixedSize()

                            Text("v\(engine.currentVersionString)")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .padding(.horizontal, 5.5)
                                .padding(.vertical, 1.5)
                                .background(Capsule().fill(Color.white.opacity(0.12)))
                                .foregroundColor(accentCyan)
                        }

                        Text(updateStatusSubtitle)
                            .font(.system(size: 9.5, weight: .medium, design: .rounded))
                            .foregroundColor(updateStatusColor)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 4)

                    updateActionButton
                }

                Divider().background(Color.white.opacity(0.08))

                HStack {
                    Text("Yeni sürümleri arka planda otomatik indir ve kur")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.78))
                    Spacer()
                    Toggle("", isOn: $engine.autoInstallUpdates)
                        .toggleStyle(.switch)
                        .controlSize(.small)
                        .labelsHidden()
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(accentIndigo.opacity(0.13))
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .stroke(accentCyan.opacity(0.32), lineWidth: 1)
                    )
            )

            Text("OTONOM KORUMA & SİSTEM TERCİHLERİ")
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .tracking(0.5)
                .foregroundColor(accentCyan)
                .padding(.top, 2)

            VStack(spacing: 7) {
                settingToggleRow(
                    sysIcon: "bolt.badge.automatic.fill",
                    title: "Ajan Çalışırken Kalkanı Otomatik Aç",
                    subtitle: "İzlenen bir ajan algılandığında korumayı otomatik başlatır",
                    isOn: $engine.autoActivateOnAgent
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    sysIcon: "clock.badge.checkmark",
                    title: "Menü Çubuğunda Canlı Sayaç",
                    subtitle: "Sağ üstteki Kalkan simgesinin yanında kalan süreyi gösterir",
                    isOn: $engine.showMenuBarTimer
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    sysIcon: "dock.rectangle",
                    title: "Dock Simgesini Göster",
                    subtitle: "Kapatıldığında yalnızca sağ üst menü çubuğunda çalışır",
                    isOn: $engine.showInDock
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    sysIcon: "battery.25",
                    title: "Düşük Pil Güvenlik Sigortası (%15)",
                    subtitle: "Şarjda değilken pil %15 altına düşerse uykuyu serbest bırakır",
                    isOn: $engine.batterySafetyEnabled
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    sysIcon: "speaker.wave.2.fill",
                    title: "Akustik Etkileşim Sesleri",
                    subtitle: "Kalkan başlatılıp durdurulurken macOS ses bildirimi çalar",
                    isOn: $engine.soundEffectsEnabled
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    sysIcon: "power.circle.fill",
                    title: "Mac Açılışında Otomatik Başlat",
                    subtitle: "Bilgisayar açıldığında sağ üst menü çubuğunda hazır bekler",
                    isOn: Binding(
                        get: { engine.launchAtLogin },
                        set: { _ in engine.toggleLaunchAtLogin() }
                    )
                )
            }
            .padding(11)
            .background(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(Color.white.opacity(0.045))
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .stroke(Color.white.opacity(0.07), lineWidth: 1)
                    )
            )

            Spacer(minLength: 0)
        }
    }

    private var updateStatusSubtitle: String {
        switch engine.updateState {
        case .idle:
            return "GitHub OTA • \(engine.lastUpdateCheckText)"
        case .checking:
            return "GitHub üzerinden yeni sürüm kontrol ediliyor..."
        case .upToDate:
            return "En güncel sürümdesiniz • \(engine.lastUpdateCheckText)"
        case .updateAvailable(let ver, _, let notes):
            return "Yeni v\(ver) hazır: \(notes)"
        case .installing(let step):
            return step
        case .failed(let err):
            return err
        }
    }

    private var updateStatusColor: Color {
        switch engine.updateState {
        case .updateAvailable, .installing:
            return accentCyan
        case .failed:
            return Color.orange
        default:
            return Color.white.opacity(0.58)
        }
    }

    @ViewBuilder
    private var updateActionButton: some View {
        switch engine.updateState {
        case .checking, .installing:
            Text("İşleniyor...")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(accentCyan)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.white.opacity(0.08)))
        case .updateAvailable(let ver, _, _):
            Button {
                engine.performInAppUpdate()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.to.line.compact")
                        .font(.system(size: 10, weight: .bold))
                    Text("v\(ver) Kur")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 5.5)
                .background(Capsule().fill(accentCyan))
            }
            .buttonStyle(.plain)
        default:
            Button {
                engine.checkForUpdates(userInitiated: true)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 9.5, weight: .bold))
                    Text("Denetle")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.white.opacity(0.10)))
            }
            .buttonStyle(.plain)
        }
    }

    private func settingToggleRow(sysIcon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: sysIcon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(accentCyan)
                .frame(width: 22, alignment: .center)

            VStack(alignment: .leading, spacing: 1.5) {
                Text(title)
                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.system(size: 9.5, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.55))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 8)

            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .controlSize(.small)
                .labelsHidden()
        }
        .frame(height: 31)
    }

    // MARK: - Alt Durum & Çıkış Çubuğu
    private var footerBar: some View {
        HStack(spacing: 8) {
            HStack(spacing: 5) {
                Circle()
                    .fill(engine.hardwareSleepDisabled ? accentCyan : Color.white.opacity(0.25))
                    .frame(width: 7, height: 7)
                Text(engine.hardwareSleepDisabled ? "Donanım Kilidi: AÇIK" : "Normal Uyku Modu")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }

            Text("•")
                .foregroundColor(.white.opacity(0.25))

            HStack(spacing: 4) {
                Image(systemName: engine.isCharging ? "bolt.batteryblock.fill" : "battery.75")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(engine.isCharging ? accentCyan : .yellow)
                Text("%\(engine.batteryLevel)")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Button {
                engine.cleanupBeforeExit()
                NSApplication.shared.terminate(nil)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "power")
                        .font(.system(size: 9.5, weight: .bold))
                    Text("Çıkış")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white.opacity(0.65))
                .padding(.horizontal, 10)
                .padding(.vertical, 4.5)
                .background(Capsule().fill(Color.white.opacity(0.07)))
            }
            .buttonStyle(.plain)
        }
        .frame(height: 24)
    }
}

// MARK: - AppDelegate & Menü Çubuğu + Yüzen HUD Pencere Yöneticisi
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var hudWindow: NSPanel!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Komut satırından --tab radar veya --tab settings ile başlatma desteği
        let args = CommandLine.arguments
        if let tabIdx = args.firstIndex(of: "--tab"), tabIdx + 1 < args.count {
            let tabArg = args[tabIdx + 1].lowercased()
            if tabArg == "radar" { ShieldEngine.shared.currentTab = .radar }
            else if tabArg == "settings" { ShieldEngine.shared.currentTab = .settings }
            else { ShieldEngine.shared.currentTab = .shield }
        }

        let engine = ShieldEngine.shared
        NSApp.setActivationPolicy(engine.showInDock ? .regular : .accessory)

        let pop = NSPopover()
        pop.contentSize = NSSize(width: 436, height: 620)
        pop.behavior = .transient
        pop.animates = true
        pop.contentViewController = NSHostingController(rootView: ShieldControlPopoverView(engine: engine))
        self.popover = pop

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 436, height: 620),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.hidesOnDeactivate = false
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.standardWindowButton(.closeButton)?.isHidden = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true
        panel.contentViewController = NSHostingController(rootView: ShieldControlPopoverView(engine: engine))
        positionWindowTopRight(panel)
        self.hudWindow = panel

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.autosaveName = "AjanKalkaniStatusItem"
        statusItem.isVisible = true
        if let button = statusItem.button {
            button.action = #selector(handleStatusBarClick(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        engine.onStatusBarUpdate = { [weak self] in
            self?.updateStatusItemAppearance()
        }
        updateStatusItemAppearance()

        showControlInterface()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showControlInterface()
        return true
    }

    private func positionWindowTopRight(_ window: NSWindow) {
        if let screen = NSScreen.main ?? NSScreen.screens.first {
            let visibleFrame = screen.visibleFrame
            let x = visibleFrame.maxX - window.frame.width - 20
            let y = visibleFrame.maxY - window.frame.height - 12
            window.setFrameOrigin(NSPoint(x: x, y: y))
        } else {
            window.center()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        ShieldEngine.shared.cleanupBeforeExit()
    }

    @objc private func handleStatusBarClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else {
            toggleControlInterface()
            return
        }

        if event.type == .rightMouseUp || event.modifierFlags.contains(.option) {
            ShieldEngine.shared.toggleShield()
            updateStatusItemAppearance()
        } else {
            toggleControlInterface()
        }
    }

    private func toggleControlInterface() {
        if popover.isShown {
            popover.performClose(nil)
            return
        }
        if hudWindow.isVisible {
            hudWindow.orderOut(nil)
            return
        }
        showControlInterface()
    }

    private func showControlInterface() {
        ShieldEngine.shared.refreshSystemTelemetry()
        if !hudWindow.isVisible {
            positionWindowTopRight(hudWindow)
        }
        hudWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func updateStatusItemAppearance() {
        guard let button = statusItem.button else { return }
        let engine = ShieldEngine.shared

        let symbolName = "bolt.shield.fill"
        let config = NSImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        if let img = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Ajan Kalkanı")?.withSymbolConfiguration(config) {
            if engine.isActive {
                let tinted = NSImage(size: img.size, flipped: false) { rect in
                    img.draw(in: rect)
                    NSColor(calibratedRed: 0.18, green: 0.92, blue: 0.78, alpha: 1.0).set()
                    rect.fill(using: .sourceAtop)
                    return true
                }
                tinted.isTemplate = false
                button.image = tinted
            } else {
                img.isTemplate = true
                button.image = img
            }
        }

        button.imagePosition = .imageLeading
        let titleText = engine.compactMenuBarTime
        if titleText.isEmpty {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 11, weight: .bold)
            ]
            button.attributedTitle = NSAttributedString(string: " Kalkan", attributes: attrs)
        } else {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 11.5, weight: .bold),
                .foregroundColor: NSColor(calibratedRed: 0.25, green: 0.95, blue: 0.82, alpha: 1.0)
            ]
            button.attributedTitle = NSAttributedString(string: titleText, attributes: attrs)
        }

        button.toolTip = engine.isActive
            ? "Ajan Kalkanı AKTİF (\(engine.formattedRemainingTime)) — Sağ tık: Durdur | Sol tık: Panel"
            : "Ajan Kalkanı KAPALI — Sağ tık: Hemen Başlat | Sol tık: Panel"
    }
}

// MARK: - Uygulama Giriş Noktası
@main
@MainActor
struct AjanKalkaniMain {
    static var retainedDelegate: AppDelegate?

    static func main() {
        signal(SIGTERM) { _ in
            let proc = Process()
            proc.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
            proc.arguments = ["-n", "/usr/bin/pmset", "disablesleep", "0"]
            try? proc.run()
            proc.waitUntilExit()
            exit(0)
        }
        signal(SIGINT) { _ in
            let proc = Process()
            proc.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
            proc.arguments = ["-n", "/usr/bin/pmset", "disablesleep", "0"]
            try? proc.run()
            proc.waitUntilExit()
            exit(0)
        }

        let app = NSApplication.shared
        let delegate = AppDelegate()
        retainedDelegate = delegate
        app.delegate = delegate
        withExtendedLifetime(delegate) {
            app.run()
        }
    }
}
