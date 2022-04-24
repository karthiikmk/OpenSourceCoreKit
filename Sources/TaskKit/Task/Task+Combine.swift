//
//  Created by Karthik on 02/12/21.
//

import UIKit

/// Useful to combine two task to run asyncronously.
/// - Returns: return both the task result.
/// - WARNING: error will be thrown if any one request failed.
extension Task {

    public static func combine<P0, P1>(
        task1: Task<P0>,
        task2: Task<P1>
    ) -> Task<(P0, P1)> where R == (P0, P1) {

        return Task<R> { (controller: Task<R>.Controller) in
            let group = DispatchGroup()
            var result1: TaskResult<P0>?
            var result2: TaskResult<P1>?

            group.enter()
            group.enter()
            task1.perform(on: controller.performQueue, handleOn: controller.handleQueue) {
                result1 = $0
                group.leave()
            }
            task2.perform(on: controller.performQueue, handleOn: controller.handleQueue) {
                result2 = $0
                group.leave()
            }

            group.notify(queue: controller.performQueue) {
                switch (result1, result2) {
                case (.failure(let error), _):
                    controller.fail(with: error)
                case (_, .failure(let error)):
                    controller.fail(with: error)
                case (.success(let value1), .success(let value2)):
                    controller.finish(result: (value1, value2))
                default: // in case when one of values are nil
                    controller.fail(with: TaskError.init(message: "internal app error"))
                }
            }
        }
    }

    public static func combine<P0, P1, P2>(
        task1: Task<P0>,
        task2: Task<P1>,
        task3: Task<P2>
    ) -> Task<(P0, P1, P2)> where R == (P0, P1, P2) {
        Task<((P0, P1), P2)>.combine(
            task1: Task<(P0, P1)>.combine(task1: task1, task2: task2),
            task2: task3
        ).map { (p01, p2) in (p01.0, p01.1, p2) }
    }

    public static func combine<P0, P1, P2, P3, P4>(
        task0: Task<P0>,
        task1: Task<P1>,
        task2: Task<P2>,
        task3: Task<P3>,
        task4: Task<P4>
    ) -> Task<(P0, P1, P2, P3, P4)> where R == (P0, P1, P2, P3, P4) {

        Task<((P0, P1, P2), (P3, P4))>.combine(
            task1: Task<(P0, P1, P2)>.combine(task1: task0, task2: task1, task3: task2),
            task2: Task<(P3, P4)>.combine(task1: task3, task2: task4)
        ).map { (p012, p34) in (p012.0, p012.1, p012.2, p34.0, p34.1) }
    }

    public static func combine<P0, P1, P2, P3, P4, P5>(
        task0: Task<P0>,
        task1: Task<P1>,
        task2: Task<P2>,
        task3: Task<P3>,
        task4: Task<P4>,
        task5: Task<P5>) -> Task<(P0, P1, P2, P3, P4, P5)> where R == (P0, P1, P2, P3, P4, P5) {

            Task<((P0, P1, P2), (P3, P4, P5))>.combine(
                task1: Task<(P0, P1, P2)>.combine(task1: task0, task2: task1, task3: task2),
                task2: Task<(P3, P4, P5)>.combine(task1: task3, task2: task4, task3: task5)
            ).map { (p012, p345) in
                (p012.0, p012.1, p012.2, p345.0, p345.1, p345.2)                
            }
        }

    public static func combine<P0, P1, P2, P3, P4, P5, P6>(
        task0: Task<P0>,
        task1: Task<P1>,
        task2: Task<P2>,
        task3: Task<P3>,
        task4: Task<P4>,
        task5: Task<P5>,
        task6: Task<P6>) -> Task<(P0, P1, P2, P3, P4, P5, P6)> where R == (P0, P1, P2, P3, P4, P5, P6) {

            Task<((P0, P1, P2), (P3, P4), (P5, P6))>.combine(
                task1: Task<(P0, P1, P2)>.combine(task1: task0, task2: task1, task3: task2),
                task2: Task<(P3, P4)>.combine(task1: task3, task2: task4),
                task3: Task<(P5, P6)>.combine(task1: task5, task2: task6)
            ).map { (p012, p34, p56) in
                (p012.0, p012.1, p012.2, p34.0, p34.1, p56.0, p56.1)
            }
        }

    public static func combine<P0, P1, P2, P3, P4, P5, P6, P7>(
        task0: Task<P0>,
        task1: Task<P1>,
        task2: Task<P2>,
        task3: Task<P3>,
        task4: Task<P4>,
        task5: Task<P5>,
        task6: Task<P6>,
        task7: Task<P7>) -> Task<(P0, P1, P2, P3, P4, P5, P6, P7)> where R == (P0, P1, P2, P3, P4, P5, P6, P7) {

            Task<((P0, P1, P2), (P3, P4, P5), (P6, P7))>.combine(
                task1: Task<(P0, P1, P2)>.combine(task1: task0, task2: task1, task3: task2),
                task2: Task<(P3, P4, P5)>.combine(task1: task3, task2: task4, task3: task5),
                task3: Task<(P6, P7)>.combine(task1: task6, task2: task7)
            ).map { (p012, p345, p67) in
                (p012.0, p012.1, p012.2, p345.0, p345.1, p345.2, p67.0, p67.1)
            }
        }
}
