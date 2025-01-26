import AVFoundation
import Foundation

class AudioRecorder: NSObject, ObservableObject {
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile?
    private var isRecording = false
    private var captureSession: AVCaptureSession?

    override init() {
        super.init()
        audioEngine = AVAudioEngine()
    }

    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        #if os(iOS)
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
        #elseif os(macOS)
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
        #endif
    }

    func startRecording(to fileURL: URL) throws {
        guard !isRecording else { return }
        
        let audioFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioFile = try AVAudioFile(forWriting: fileURL, settings: audioFormat.settings)
        
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: audioFormat) { buffer, _ in
            do {
                try self.audioFile?.write(from: buffer)
            } catch {
                print("Error writing audio buffer: \(error)")
            }
        }
        
        try audioEngine.start()
        isRecording = true
    }

    func stopRecording() {
        guard isRecording else { return }
        
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        isRecording = false
        audioFile = nil
    }
} 