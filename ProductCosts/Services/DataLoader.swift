
import Foundation

final class DataLoader {
    func fetchData<T: Decodable>(from plistName: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            guard let url = Bundle.main.url(forResource: plistName, withExtension: "plist") else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "error", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(plistName).plist not found"])))
                }
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decoder = PropertyListDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                print("Ошибка чтения \(plistName).plist: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
