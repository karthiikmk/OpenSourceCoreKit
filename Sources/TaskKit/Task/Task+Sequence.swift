//
//  Created by Karthik on 02/12/21.
//

import Foundation

/*
 NOTE: Applicable only for function which doesn't return anything.
 so that we can move forward.
 */
extension Task where R == Void {
    public static func sequence(_ tasks: [Task]) -> Task {
        var index = 0

        func performNext(using controller: Controller<R>) {
            guard index < tasks.count else {
                // We’ve reached the end of our array of tasks, time to finish the sequence.
                controller.finish()
                return
            }

            let task = tasks[index]
            index += 1

            task.perform(
                on: controller.performQueue,
                handleOn: controller.handleQueue
            ) { (outcome: TaskResult<Void>) in
                switch outcome {
                case .success:
                    performNext(using: controller)
                case .failure(let error):
                    // As soon as an error was occurred, we’ll fail the entire sequence.
                    controller.fail(with: error)
                }
            }
        }
        return Task(closure: performNext)
    }
}
