//
//  AudioPlayer.swift
//  easy-peasy
//
//  Created by Sergey Kozlov on 10.01.2025.
//
import AVFoundation

class Audio {
    
    static let shared = Audio()
    
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?

    init() {
        configureAudioSession()
        setupAudioEngine()
        
        let wavURL = urlForAudio("kick.wav")
        loadSound(url: wavURL)
       // loadSound(
    }

    private func setupAudioEngine() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: nil)
        
        do {
            try engine.start()
        } catch {
            print("Ошибка запуска AVAudioEngine: \(error.localizedDescription)")
        }
    }

    var audioBuffer: AVAudioPCMBuffer?

    func loadSound(url: URL) {
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let format = audioFile.processingFormat
            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(audioFile.length))!
            try audioFile.read(into: buffer)
            audioBuffer = buffer
        } catch {
            print("Ошибка загрузки файла: \(error.localizedDescription)")
        }
    }

    func playLoadedSound() {
        guard let buffer = audioBuffer else { return }
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        playerNode.play()
    }


    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудиосессии: \(error.localizedDescription)")
        }
    }
    
    private func urlForAudio(_ fileName: String) -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let result = tempDir.appending(component: Globals.AUDIO_STORAGE_ROOT).appending(component: fileName)
        return result
    }
}
