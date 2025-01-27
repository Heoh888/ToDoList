//
//  SpeechService.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 26.01.2025.
//
import Foundation
import AVFAudio
import AVFoundation
import Speech
import Combine

/// Протокол, описывающий входные функции службы распознавания речи.
protocol SpeechServiceInput {
    /// Подписка для передачи распознанного текста.
    var recognizedText: PassthroughSubject<String, Never> { get set }
    /// Запрос на распознавание аудио.
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest? { get set }
    /// Останавливает распознавание.
    func stop()
    /// Запускает распознавание.
    func start()
}

/// Класс, который предоставляет функциональность для распознавания речи.
class SpeechService: NSObject, SFSpeechRecognizerDelegate, SpeechServiceInput {
    
    /// Подписка для получения распознанного текста.
    var recognizedText = PassthroughSubject<String, Never>()
    /// Распознаватель речи, поддерживающий русский язык.
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    /// Запрос на распознавание аудио.
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    /// Задача распознавания речи.
    var recognitionTask: SFSpeechRecognitionTask?
    /// Аудио-движок для работы с аудиопотоком.
    let audioEngine = AVAudioEngine()
    /// Сессия аудио для управления настройками звука.
    var recordingSession = AVAudioSession.sharedInstance()
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }
    
    /// Запрашивает разрешение на использование микрофона и запускает распознавание.
    func start() {
        SFSpeechRecognizer.requestAuthorization { _ in
            self.startRecognition()
        }
    }
    
    /// Останавливает распознавание и сбрасывает параметры.
    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }

    /// Локальная функция, начинающая процесс распознавания речи.
    private func startRecognition() {
        do {
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let currentRecognitionRequest = recognitionRequest else {
                fatalError("Не удалось создать объект SFSpeechAudioBufferRecognitionRequest")
            }
            currentRecognitionRequest.requiresOnDeviceRecognition = true
            recognitionTask = speechRecognizer?.recognitionTask(with: currentRecognitionRequest) { result, _ in
                if let recognizedResult = result {
                    self.recognizedText.send(recognizedResult.bestTranscription.formattedString)
                }
            }
            
            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                currentRecognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Ошибка при запуске аудио-движка: \(error.localizedDescription)")
        }
    }
}
