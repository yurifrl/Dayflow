import Foundation
import GRDB

extension StorageManager {
  func hasAnyTimelineCards() -> Bool {
    (try? timedRead("hasAnyTimelineCards") { db in
      try Bool.fetchOne(
        db,
        sql: "SELECT EXISTS(SELECT 1 FROM timeline_cards WHERE is_deleted = 0 LIMIT 1)"
      ) ?? false
    }) ?? false
  }
}
