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
        case .clamshellAgent: return "Kapak Kapalı Ajan"
        case .fullPresentation: return "Kapak + Ekran Açık"
        case .smartAgentWatch: return "Akıllı Ajan Gözcüsü"
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
            return "Kapak kapansa bile CPU, Wi-Fi ve tüm Ajan/Terminaller tam hız çalışır; ekran kapanıp ısınmayı önler."
        case .fullPresentation:
            return "Hem kapak uykusunu hem de ekranın kararmasını tamamen engeller."
        case .smartAgentWatch:
            return "Kapak kapalı çalışır; izlenen tüm kodlama ve terminal ajanları bittiğinde uykuyu serbest bırakır."
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
        case .cursorAgentTerminal: return "Cursor Agent Terminal"
        case .opencode: return "OpenCode"
        case .opencodeTerminal: return "OpenCode Terminal"
        case .deepseekHarness: return "DeepSeek Harness"
        case .terminalApps: return "Terminal Havuzu"
        }
    }

    var categoryBadge: String {
        switch self {
        case .claudeCode, .codex, .agy, .cursor, .opencode, .deepseekHarness:
            return "APP / IDE"
        case .claudeTerminal, .codexTerminal, .agyTerminal, .cursorAgentTerminal, .opencodeTerminal:
            return "CLI / TTY"
        case .terminalApps:
            return "KABUK"
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
    @Published var launchAtLogin: Bool = false

    // İzlenen Ajan Filtresi (Akıllı Gözcü ve Otomatik Başlatma için)
    @Published var watchedAgentKinds: Set<CodingAgentKind> = Set(CodingAgentKind.allCases.filter { $0 != .terminalApps })

    // Canlı Sistem & Ajan Telemetrisi
    @Published var hardwareSleepDisabled: Bool = false
    @Published var batteryLevel: Int = 100
    @Published var isCharging: Bool = true
    @Published var agentStatuses: [AgentRuntimeStatus] = CodingAgentKind.allCases.map {
        AgentRuntimeStatus(kind: $0, instanceCount: 0, ttys: [], detail: "Kapalı")
    }
    @Published var statusMessage: String = "Kalkan hazır. Tek dokunuşla kapak korumasını başlatın."

    var onStatusBarUpdate: (() -> Void)?

    private var caffeinateProcess: Process?
    private var countdownTimer: Timer?
    private var telemetryTimer: Timer?
    private var idleAgentEmptyCount: Int = 0

    // Özet hesaplamalar
    var activeCodingAgentsCount: Int {
        agentStatuses
            .filter { $0.kind != .terminalApps && $0.isRunning }
            .reduce(0) { $0 + $1.instanceCount }
    }

    var activeCodingAgentTypesCount: Int {
        agentStatuses.filter { $0.kind != .terminalApps && $0.isRunning }.count
    }

    var activeAgentShortNames: [String] {
        agentStatuses
            .filter { $0.kind != .terminalApps && $0.isRunning }
            .map { status in
                status.instanceCount > 1
                    ? "\(status.kind.displayName) (\(status.instanceCount))"
                    : status.kind.displayName
            }
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

        checkLaunchAtLoginStatus()
        refreshSystemTelemetry()
        startTelemetryLoop()
    }

    // MARK: - Başlat / Durdur / Süre Değiştir
    func toggleShield() {
        if isActive {
            deactivateShield(reason: "Kullanıcı tarafından durduruldu.")
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
            ? "Kapak Kalkanı SÜRESİZ aktif. Kapağı güvenle kapatabilirsiniz."
            : "Kapak Kalkanı \(duration.title) boyunca aktif."

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
                ? "Süre SÜRESİZ olarak güncellendi. Kapağı kapatabilirsiniz."
                : "Süre \(duration.title) olarak güncellendi."
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
                deactivateShield(reason: "Seçilen süre tamamlandı, Mac normal uyku moduna döndü.")
                sendUserNotification(
                    title: "Ajan Kalkanı Süresi Doldu",
                    body: "Seçtiğiniz koruma süresi tamamlandı. MacBook normal uyku moduna geri döndü."
                )
                return
            }
        }
    }

    // MARK: - Sistem & Ajan Telemetri Döngüsü (Her 3 saniyede bir sıfır-blokajlı radar taraması)
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
            deactivateShield(reason: "Kritik pil koruması (%\(batLevel)): Veri kaybını önlemek için uyku kilidi açıldı.")
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

                // Otomatik Ajan Kalkanı: İzlenen ajanlardan biri aktifse ve kalkan kapalıysa otomatik başlat
                if !self.isActive && self.autoActivateOnAgent && watchedRunning {
                    self.activateShield(duration: self.selectedDuration)
                    self.statusMessage = "Aktif kodlama ajanı algılandı, kalkan otomatik açıldı."
                }

                // Akıllı Ajan Gözcüsü Modu: İzlenen ajanlar bittiğinde uykuyu serbest bırak
                if self.isActive && currentMode == .smartAgentWatch {
                    if !watchedRunning {
                        self.idleAgentEmptyCount += 1
                        if self.idleAgentEmptyCount >= 8 { // ~24 saniye boyunca hiç aktif ajan yoksa
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
            // ÖNCE pipe okunur (64KB tampon kilitlenmesini %100 önler)
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            proc.waitUntilExit()

            if let output = String(data: data, encoding: .utf8) {
                let lines = output.split(separator: "\n")
                for rawLine in lines {
                    let line = rawLine.trimmingCharacters(in: .whitespaces)
                    guard !line.isEmpty else { continue }

                    // Format: PID TTY COMM ARGS
                    let parts = line.split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
                    guard parts.count >= 3 else { continue }

                    let tty = String(parts[1])
                    let comm = String(parts[2])
                    let args = parts.count == 4 ? String(parts[3]) : comm
                    let lowerArgs = args.lowercased()
                    let lowerComm = (comm as NSString).lastPathComponent.lowercased()

                    // Kendi alt süreçlerimizi ve sistem yardımcılarını hariç tut
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
                        // /bin/sh wrapper ve gerçek binary çift sayılmasın diye wrapper satırını filtrele
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

                    // 12: Terminal Uygulamaları (Terminal.app, iTerm2, Warp, Ghostty, Kitty, Alacritty, WezTerm, tmux, cmux)
                    if lowerArgs.contains("/terminal.app/contents/macos/terminal") {
                        counts[.terminalApps, default: 0] += 1
                        terminalNames.insert("macOS Terminal")
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

            let detailText: String
            if kind == .terminalApps {
                if count > 0 {
                    let names = terminalNames.sorted().joined(separator: ", ")
                    detailText = "\(names) • \(allTtys.count) TTY sekmesi"
                } else {
                    detailText = "Açık terminal yok"
                }
            } else if count > 0 {
                if !ttys.isEmpty {
                    let ttyPreview = ttys.prefix(3).joined(separator: ", ")
                    detailText = "\(count) oturum (\(ttyPreview))"
                } else {
                    detailText = "\(count) aktif süreç çalışıyor"
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
        if isActive || hardwareSleepDisabled {
            _ = setPmsetSleepDisabled(false)
        }
    }
}

// MARK: - Görsel Ana Arayüz (Glassmorphic Premium Popover & HUD)
struct ShieldControlPopoverView: View {
    @ObservedObject var engine: ShieldEngine
    @State private var selectedTab: DashboardTab = .shield
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
            .ignoresSafeArea()

            Circle()
                .fill(
                    RadialGradient(
                        colors: engine.isActive
                            ? [accentCyan.opacity(0.22), accentIndigo.opacity(0.10), .clear]
                            : [accentIndigo.opacity(0.09), .clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 230
                    )
                )
                .frame(width: 400, height: 400)
                .offset(y: -80)
                .scaleEffect(pulseAnimation && engine.isActive ? 1.08 : 0.94)
                .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true), value: pulseAnimation)

            VStack(spacing: 12) {
                headerBar
                tabSelectorBar

                Group {
                    switch selectedTab {
                    case .shield:
                        mainDashboard
                    case .radar:
                        agentRadarMatrixView
                    case .settings:
                        settingsPanel
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                footerBar
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .frame(width: 396, height: 600)
        .preferredColorScheme(.dark)
        .onAppear {
            pulseAnimation = true
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                ringRotation = 360
            }
        }
    }

    // MARK: - Üst Başlık Barı
    private var headerBar: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: engine.isActive
                                ? [accentCyan, accentIndigo]
                                : [Color.white.opacity(0.12), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 34, height: 34)
                    .shadow(color: engine.isActive ? accentCyan.opacity(0.45) : .clear, radius: 8)

                Image(systemName: engine.isActive ? "bolt.shield.fill" : "shield.lefthalf.filled")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(engine.isActive ? .black : .white.opacity(0.85))
            }

            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 6) {
                    Text("AJAN KALKANI")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .tracking(0.8)
                        .foregroundColor(.white)

                    Text(engine.isActive ? "KORUMA AKTİF" : "BEKLEMEDE")
                        .font(.system(size: 8.5, weight: .black, design: .rounded))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(engine.isActive ? accentCyan.opacity(0.22) : Color.white.opacity(0.08))
                        )
                        .foregroundColor(engine.isActive ? accentCyan : .white.opacity(0.55))
                }

                Text("Otonom Kodlama & Terminal Uyku Koruyucu")
                    .font(.system(size: 10.5, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.55))
            }

            Spacer()

            // Sağ Üst Menü Çubuğuna Küçült butonu
            Button {
                NSApp.keyWindow?.orderOut(nil)
            } label: {
                Image(systemName: "menubar.arrow.up.rectangle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(accentCyan)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(accentCyan.opacity(0.12)))
            }
            .buttonStyle(.plain)
            .help("Pencereyi gizle (Sağ üst menü çubuğundan her an açabilirsiniz)")
        }
    }

    // MARK: - 3'lü Sekme Çubuğu (Kalkan | Ajan Radarı | Ayarlar)
    private var tabSelectorBar: some View {
        HStack(spacing: 6) {
            ForEach(DashboardTab.allCases) { tab in
                let isSelected = (selectedTab == tab)
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 11, weight: .bold))
                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: isSelected ? .heavy : .semibold, design: .rounded))

                        if tab == .radar {
                            Text("\(engine.activeCodingAgentsCount)")
                                .font(.system(size: 9.5, weight: .black, design: .monospaced))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 1.5)
                                .background(
                                    Capsule()
                                        .fill(engine.activeCodingAgentsCount > 0 ? accentCyan : Color.white.opacity(0.15))
                                )
                                .foregroundColor(engine.activeCodingAgentsCount > 0 ? .black : .white.opacity(0.7))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6.5)
                    .background(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .fill(isSelected ? Color.white.opacity(0.12) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .stroke(isSelected ? accentCyan.opacity(0.45) : Color.clear, lineWidth: 1)
                    )
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
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
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }

    // MARK: - SEKME 1: Ana Kalkan Kontrol Paneli
    private var mainDashboard: some View {
        VStack(spacing: 12) {
            powerOrbSection
            durationSelectorSection
            modeSelectorSection
            activeAgentsQuickStrip
        }
    }

    // MARK: - Merkezdeki Nefes Alan Tek Tuş Güç Küresi (Power Orb)
    private var powerOrbSection: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.06), lineWidth: 9)
                    .frame(width: 136, height: 136)

                if engine.isActive {
                    Circle()
                        .trim(from: 0.0, to: CGFloat(max(0.04, engine.progressFraction)))
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [accentCyan, accentIndigo, accentCyan]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 9, lineCap: .round)
                        )
                        .frame(width: 136, height: 136)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: accentCyan.opacity(0.55), radius: 10)
                        .animation(.easeInOut(duration: 0.4), value: engine.progressFraction)

                    Circle()
                        .strokeBorder(
                            AngularGradient(
                                gradient: Gradient(colors: [.clear, accentCyan.opacity(0.6), .clear, accentIndigo.opacity(0.6), .clear]),
                                center: .center
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 152, height: 152)
                        .rotationEffect(.degrees(ringRotation))
                }

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
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
                                color: engine.isActive ? accentCyan.opacity(0.35) : .black.opacity(0.4),
                                radius: hoverPowerOrb ? 18 : 10
                            )

                        VStack(spacing: 3) {
                            Image(systemName: engine.isActive ? "lock.laptopcomputer" : "power")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundStyle(
                                    engine.isActive
                                        ? LinearGradient(colors: [accentCyan, .white], startPoint: .top, endPoint: .bottom)
                                        : LinearGradient(colors: [.white.opacity(0.85), .white.opacity(0.45)], startPoint: .top, endPoint: .bottom)
                                )

                            Text(engine.formattedRemainingTime)
                                .font(.system(size: 15, weight: .black, design: .monospaced))
                                .foregroundColor(engine.isActive ? .white : .white.opacity(0.55))

                            Text(engine.isActive ? "DURDURMAK İÇİN DOKUN" : "BAŞLATMAK İÇİN DOKUN")
                                .font(.system(size: 7.2, weight: .bold, design: .rounded))
                                .tracking(0.5)
                                .foregroundColor(engine.isActive ? accentCyan : .white.opacity(0.4))
                        }
                    }
                    .scaleEffect(hoverPowerOrb ? 1.04 : 1.0)
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    withAnimation(.easeOut(duration: 0.18)) {
                        hoverPowerOrb = hovering
                    }
                }

                if engine.isActive && engine.selectedDuration != .infinite {
                    HStack {
                        Button {
                            engine.addMinutes(-15)
                        } label: {
                            Text("-15d")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.75))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(Color.white.opacity(0.08)))
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Button {
                            engine.addMinutes(15)
                        } label: {
                            Text("+15d")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(accentCyan)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(accentCyan.opacity(0.14)))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .frame(height: 152)

            Text(engine.statusMessage)
                .font(.system(size: 10.5, weight: .medium, design: .rounded))
                .foregroundColor(engine.isActive ? accentCyan.opacity(0.95) : .white.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
    }

    // MARK: - Süre Seçici Haplar
    private var durationSelectorSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("AÇIK KALMA SÜRESİ", systemImage: "timer")
                    .font(.system(size: 9.5, weight: .bold, design: .rounded))
                    .tracking(0.6)
                    .foregroundColor(.white.opacity(0.55))

                Spacer()

                Text(engine.selectedDuration.subtitle)
                    .font(.system(size: 9.5, weight: .medium, design: .rounded))
                    .foregroundColor(accentCyan.opacity(0.85))
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
                ForEach(ShieldDuration.allCases) { duration in
                    let isSelected = (engine.selectedDuration == duration)
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                            engine.selectDuration(duration)
                        }
                    } label: {
                        Text(duration.title)
                            .font(.system(size: 11, weight: isSelected ? .heavy : .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6.5)
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
                            .foregroundColor(isSelected ? .black : .white.opacity(0.85))
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        engine.activateShield(duration: engine.selectedDuration)
                    }
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 9.5, weight: .bold))
                        Text("Şimdi")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6.5)
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
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }

    // MARK: - Çalışma Modu Seçici
    private var modeSelectorSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                ForEach(ShieldMode.allCases) { mode in
                    let isSelected = (engine.selectedMode == mode)
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                            engine.selectMode(mode)
                        }
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: mode.icon)
                                .font(.system(size: 12.5, weight: .bold))
                            Text(mode.title)
                                .font(.system(size: 9.5, weight: .bold, design: .rounded))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(isSelected ? accentIndigo.opacity(0.32) : Color.white.opacity(0.04))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(isSelected ? accentCyan.opacity(0.65) : Color.white.opacity(0.07), lineWidth: 1)
                        )
                        .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
            }

            Text(engine.selectedMode.description)
                .font(.system(size: 9.5, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }

    // MARK: - Canlı Ajan & Terminal Hızlı Durum Kartı (Tıklayınca Ajan Radarına Gider)
    private var activeAgentsQuickStrip: some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                selectedTab = .radar
            }
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(engine.activeCodingAgentsCount > 0 ? accentCyan : Color.white.opacity(0.25))
                            .frame(width: 7, height: 7)
                            .shadow(color: engine.activeCodingAgentsCount > 0 ? accentCyan : .clear, radius: 4)

                        Text(
                            engine.activeCodingAgentsCount > 0
                                ? "CANLI RADAR: \(engine.activeCodingAgentsCount) Ajan Oturumu Çalışıyor"
                                : "CANLI RADAR: Aktif Kodlama Ajanı Yok"
                        )
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    }

                    Spacer()

                    HStack(spacing: 3) {
                        Text("Tümünü Gör")
                            .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 8.5, weight: .bold))
                    }
                    .foregroundColor(accentCyan)
                }

                // Aktif olanların renkli rozetleri
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(engine.agentStatuses.filter { $0.isRunning }) { status in
                            HStack(spacing: 4) {
                                Image(systemName: status.kind.icon)
                                    .font(.system(size: 9.5, weight: .bold))
                                    .foregroundColor(status.kind.color)
                                Text(status.kind.displayName)
                                    .font(.system(size: 9.5, weight: .bold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                                if status.instanceCount > 1 {
                                    Text("×\(status.instanceCount)")
                                        .font(.system(size: 9, weight: .black, design: .monospaced))
                                        .foregroundColor(status.kind.color)
                                }
                            }
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3.5)
                            .background(
                                Capsule()
                                    .fill(status.kind.color.opacity(0.14))
                                    .overlay(Capsule().stroke(status.kind.color.opacity(0.35), lineWidth: 0.8))
                            )
                        }
                    }
                }
            }
            .padding(9)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(engine.activeCodingAgentsCount > 0 ? accentCyan.opacity(0.3) : Color.white.opacity(0.07), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - SEKME 2: 12'li Ajan & Terminal Radar Matrisi
    private var agentRadarMatrixView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text("KODLAMA AJANLARI & TERMİNAL HAVUZU")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .tracking(0.6)
                        .foregroundColor(accentCyan)
                    Text("İzlemek için karta dokunun • Çift/Ok simgesiyle uygulamayı açın")
                        .font(.system(size: 9.5, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                Button {
                    engine.refreshSystemTelemetry()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 9.5, weight: .bold))
                        Text("Tara")
                            .font(.system(size: 9.5, weight: .bold, design: .rounded))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.white.opacity(0.08)))
                    .foregroundColor(.white.opacity(0.85))
                }
                .buttonStyle(.plain)
            }

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 7), GridItem(.flexible(), spacing: 7)], spacing: 7) {
                    ForEach(engine.agentStatuses) { status in
                        agentRadarCard(status)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private func agentRadarCard(_ status: AgentRuntimeStatus) -> some View {
        let isWatched = engine.watchedAgentKinds.contains(status.kind)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(status.isRunning ? status.kind.color.opacity(0.22) : Color.white.opacity(0.06))
                        .frame(width: 26, height: 26)

                    Image(systemName: status.kind.icon)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(status.isRunning ? status.kind.color : .white.opacity(0.4))
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(status.kind.displayName)
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                        .foregroundColor(status.isRunning ? .white : .white.opacity(0.65))
                        .lineLimit(1)

                    Text(status.kind.categoryBadge)
                        .font(.system(size: 7.5, weight: .heavy, design: .monospaced))
                        .foregroundColor(status.kind.color.opacity(0.85))
                }

                Spacer(minLength: 2)

                // Aktif oturum sayısı rozeti
                if status.isRunning {
                    Text("×\(status.instanceCount)")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .padding(.horizontal, 5.5)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(status.kind.color))
                        .foregroundColor(.black)
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 7, height: 7)
                }
            }

            HStack {
                Text(status.detail)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(status.isRunning ? status.kind.color.opacity(0.95) : .white.opacity(0.38))
                    .lineLimit(1)

                Spacer()

                if status.kind != .terminalApps {
                    Button {
                        engine.toggleWatchedAgent(status.kind)
                    } label: {
                        Image(systemName: isWatched ? "eye.fill" : "eye.slash")
                            .font(.system(size: 9.5, weight: .bold))
                            .foregroundColor(isWatched ? accentCyan : .white.opacity(0.3))
                    }
                    .buttonStyle(.plain)
                    .help(isWatched ? "Bu ajan kalkan gözcüsünde izleniyor" : "İzleme dışı")
                }

                Button {
                    engine.focusOrLaunchAgent(status.kind)
                } label: {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.45))
                }
                .buttonStyle(.plain)
                .help("\(status.kind.displayName) uygulamasını/terminalini öne getir")
            }
        }
        .padding(8.5)
        .background(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(status.isRunning ? status.kind.color.opacity(0.09) : Color.white.opacity(0.035))
                .overlay(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(
                            status.isRunning ? status.kind.color.opacity(0.45) : Color.white.opacity(0.06),
                            lineWidth: 1
                        )
                )
        )
    }

    // MARK: - SEKME 3: Ayarlar Paneli
    private var settingsPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("OTONOM KORUMA & TERCİHLER")
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .tracking(0.6)
                .foregroundColor(accentCyan)

            VStack(spacing: 9) {
                settingToggleRow(
                    icon: "Cpu.fill",
                    sysIcon: "bolt.badge.automatic.fill",
                    title: "Ajan Çalışırken Kalkanı Otomatik Aç",
                    subtitle: "Claude, Codex, AGY, Cursor veya OpenCode algılanınca kalkanı başlatır",
                    isOn: $engine.autoActivateOnAgent
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    icon: "",
                    sysIcon: "clock.badge.checkmark",
                    title: "Menü Çubuğunda Canlı Sayaç",
                    subtitle: "Sağ üstteki simgenin yanında kalan süreyi gösterir",
                    isOn: $engine.showMenuBarTimer
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    icon: "",
                    sysIcon: "dock.rectangle",
                    title: "Dock Simgesini Göster",
                    subtitle: "Kapatırsanız sadece sağ üst menü çubuğunda çalışır",
                    isOn: $engine.showInDock
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    icon: "",
                    sysIcon: "battery.25",
                    title: "Düşük Pil Sigortası (%15)",
                    subtitle: "Şarjda değilken pil %15'e düşerse uykuyu serbest bırakır",
                    isOn: $engine.batterySafetyEnabled
                )

                Divider().background(Color.white.opacity(0.08))

                settingToggleRow(
                    icon: "",
                    sysIcon: "speaker.wave.2.fill",
                    title: "Akustik Ses Efektleri",
                    subtitle: "Kalkan açılıp kapanırken sistem ses bildirimi çalar",
                    isOn: $engine.soundEffectsEnabled
                )

                Divider().background(Color.white.opacity(0.08))

                HStack {
                    Image(systemName: "power.circle.fill")
                        .font(.system(size: 15))
                        .foregroundColor(accentCyan)
                        .frame(width: 22)

                    VStack(alignment: .leading, spacing: 1) {
                        Text("Mac Açılışında Otomatik Başlat")
                            .font(.system(size: 11.5, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Bilgisayar açıldığında sağ üst köşede hazır bekler")
                            .font(.system(size: 9.5, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.55))
                    }

                    Spacer()

                    Toggle("", isOn: Binding(
                        get: { engine.launchAtLogin },
                        set: { _ in engine.toggleLaunchAtLogin() }
                    ))
                    .toggleStyle(.switch)
                    .labelsHidden()
                }
            }
            .padding(11)
            .background(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(Color.white.opacity(0.05))
            )

            Spacer()
        }
    }

    private func settingToggleRow(icon: String, sysIcon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: sysIcon)
                .font(.system(size: 15))
                .foregroundColor(accentCyan)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 9.5, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.55))
            }

            Spacer()

            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }

    // MARK: - Alt Durum & Çıkış Çubuğu
    private var footerBar: some View {
        HStack(spacing: 8) {
            HStack(spacing: 5) {
                Circle()
                    .fill(engine.hardwareSleepDisabled ? accentCyan : Color.white.opacity(0.25))
                    .frame(width: 6.5, height: 6.5)
                Text(engine.hardwareSleepDisabled ? "Donanım Kilidi: AÇIK" : "Normal Uyku")
                    .font(.system(size: 9.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.75))
            }

            Text("•")
                .foregroundColor(.white.opacity(0.25))

            HStack(spacing: 3) {
                Image(systemName: engine.isCharging ? "bolt.batteryblock.fill" : "battery.75")
                    .font(.system(size: 9.5, weight: .bold))
                    .foregroundColor(engine.isCharging ? accentCyan : .yellow)
                Text("%\(engine.batteryLevel)")
                    .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.75))
            }

            Spacer()

            Button {
                engine.cleanupBeforeExit()
                NSApplication.shared.terminate(nil)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "power")
                        .font(.system(size: 9, weight: .bold))
                    Text("Çıkış")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white.opacity(0.55))
                .padding(.horizontal, 8)
                .padding(.vertical, 3.5)
                .background(Capsule().fill(Color.white.opacity(0.06)))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - AppDelegate & Menü Çubuğu + Yüzen HUD Pencere Yöneticisi
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var hudWindow: NSPanel!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let engine = ShieldEngine.shared
        NSApp.setActivationPolicy(engine.showInDock ? .regular : .accessory)

        let pop = NSPopover()
        pop.contentSize = NSSize(width: 396, height: 600)
        pop.behavior = .transient
        pop.animates = true
        pop.contentViewController = NSHostingController(rootView: ShieldControlPopoverView(engine: engine))
        self.popover = pop

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 396, height: 600),
            styleMask: [.titled, .closable, .fullSizeContentView, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
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
