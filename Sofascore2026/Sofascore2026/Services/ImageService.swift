import UIKit
import OSLog

@MainActor
enum ImageService {

    private static let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 200
        return cache
    }()

    private static var inFlight: [URL: Task<UIImage?, Never>] = [:]

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Sofascore2026",
        category: "ImageService"
    )

    static func image(from url: URL) async -> UIImage? {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }

        if let existing = inFlight[url] {
            return await existing.value
        }

        let task = Task<UIImage?, Never> { await fetch(url) }
        inFlight[url] = task
        let image = await task.value
        inFlight[url] = nil
        return image
    }

    private static func fetch(_ url: URL) async -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let image = UIImage(data: data) else {
                logger.warning("Image HTTP/decode failure for \(url.absoluteString)")
                return nil
            }
            cache.setObject(image, forKey: url as NSURL)
            return image
        } catch is CancellationError {
            return nil
        } catch let error as URLError where error.code == .cancelled {
            return nil
        } catch {
            logger.warning("Image fetch failed for \(url.absoluteString): \(String(describing: error))")
            return nil
        }
    }
    
    static func image(fromString urlString: String?) async -> UIImage? {
            guard let urlString, let url = URL(string: urlString) else { return nil }
            return await image(from: url)
        }
}
