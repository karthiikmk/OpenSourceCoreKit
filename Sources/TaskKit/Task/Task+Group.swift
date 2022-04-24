//
//  Created by Karthik on 02/12/21.
//

import Foundation

/*
 func groupProcess() {
 	let task1 = Task { self.getPhotoId(completion: $0) }
 	let task2 = Task { self.getPhotoId(completion: $0) }

 	Task.group([task1, task2]).perform { result in
 		switch result {
 			case .success(let results): break
 			case .failure(let error): break
 			}
 		}
 	}
*/
extension Task {
    public static func group(_ tasks: [Task<R>]) -> Task<[R]> {
        return Task<[R]> { (controller: Task<[R]>.Controller<[R]>) in

            let group = DispatchGroup()
            // To avoid race conditions with errors, we set up a private
            // queue to sync all assignments to our error variable
            let errorSyncQueue = DispatchQueue(label: "Task.ErrorSync")
            var anyError: Error?
            var results = [R]()

            for task in tasks {
                group.enter()
                // It’s important to make the sub-tasks execute
                // on the same DispatchQueue as the group, since
                // we might cause unexpected threading issues otherwise.
                task.perform(on: controller.performQueue, handleOn: controller.handleQueue) { result in
                    switch result {
                    case .success(let result):
                        results.append(result)
                    case .failure(let error):
                        errorSyncQueue.sync {
                            anyError = anyError ?? error
                        }
                    }
                    group.leave()
                }
            }

            group.notify(queue: controller.performQueue) {
                switch anyError {
                case .some(let error):
                    controller.fail(with: error)
                case .none:
                    controller.finish(result: results)
                }
            }
        }
    }
}
