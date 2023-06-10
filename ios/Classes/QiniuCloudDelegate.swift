import PLRTCStreamingKit

/// 七牛云委托代理
public protocol QiniuCloudDelegate: NSObjectProtocol {

    /// 流处理器
    func mediaStreamingSession(_ session: PLMediaStreamingSession, cameraSourceDidGet pixelBuffer: CVPixelBuffer, timingInfo: CMSampleTimingInfo) -> Unmanaged<CVPixelBuffer>
}