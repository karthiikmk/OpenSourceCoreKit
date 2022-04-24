//
//  Created by Karthik on 02/12/21.
//
import Foundation

public struct TaskError: Error {
    public let message: String

    public init(message: String) {
        self.message = message
    }

    public init(error: Error) {
        self.message = error.localizedDescription
    }
}

public typealias VoidAction = () -> Void
public typealias Action<T> = (T) -> Void // Closure

public typealias TaskResult<Value> = Result<Value, Error>
public typealias TaskResultAction<Value> = Action<TaskResult<Value>> // Result as Closure arg

public struct Task<R> {
    public typealias Closure = Action<Controller<R>>
    private let closure: Closure

    public init(closure: @escaping Closure) {
        self.closure = closure
    }
    
    public init<T, E>(action: @escaping (@escaping Action<Result<R, E>>) -> T) {
        self.closure = { controller in
            _ = action { result in
                switch result {
                case .success(let value):
                    controller.finish(result: value)
                case .failure(let error):
                    controller.fail(with: error)
                }
            }
        }
    }
}

extension Task {
    public struct Controller<R> {
        let performQueue: DispatchQueue
        let handleQueue: DispatchQueue
        let handler: TaskResultAction<R>
        
        public func finish(result: R) {
            handleQueue.async {
                self.handler(.success(result))
            }
        }
        
        public func fail(with error: Error) {
            handleQueue.async {
                self.handler(.failure(TaskError.init(message: error.localizedDescription)))
            }
        }
    }
}

extension Task.Controller where R == Void {
    public func finish() {
        handler(.success(()))
    }
}

// MARK: Perform
extension Task {

    public func perform(
        on performQueue: DispatchQueue = .global(),
        handleOn handleQueue: DispatchQueue = .global(),
        then handler: @escaping TaskResultAction<R>
    ) {
        performQueue.async {
            let controller = Controller(
                performQueue: performQueue,
                handleQueue: handleQueue,
                handler: handler
            )
            self.closure(controller)
        }
    }

    public func perform(on queue: TaskQueue = .default, then handler: @escaping TaskResultAction<R>) {
        perform(
            on: queue.performQueue,
            handleOn: queue.handleQueue,
            then: handler
        )
    }
}


/*
 NOTE: it will be useful when we want to return something for the local or manual.
 for eg: Task.just(value: [])
*/
extension Task {
    public static func just(value: R) -> Task<R> {
        self.init(closure: { $0.finish(result: value) })
    }
}

extension Task {

    public func map<O>(mapper: @escaping (R) -> O) -> Task<O> {
        return Task<O> { controller in
            self.perform(on: controller.performQueue, handleOn: controller.handleQueue, then: { (result) in
                switch result {
                case .success(let value):
                    controller.finish(result: mapper(value))
                case .failure(let error):
                    controller.fail(with: error)
                }
            })
        }
    }

    public func then<O>(_ task: @escaping (R) -> Task<O>) -> Task<O> {
        return Task<O> { (controller: Task<O>.Controller<O>) in

            func executeTask<V>(task: Task<V>, onSuccess: @escaping Action<V>) {
                task.perform(on: controller.performQueue, handleOn: controller.handleQueue) { result in
                    switch result {
                    case .success(let value):
                        onSuccess(value)
                    case .failure(let error):
                        controller.fail(with: error)
                    }
                }
            }

            executeTask(task: self) { value in
                let nextTask = task(value)
                executeTask(task: nextTask) { result in
                    controller.finish(result: result)
                }
            }
        }
    }
}

extension Task {
    public func resultOmmited() -> Task<Void> {
        return self.map { _ in }
    }
}

extension Task {
    public func errorOmmited() -> Task<Void> {
        return Task<Void> { controller in
            self.perform(
                on: controller.performQueue,
                handleOn: controller.handleQueue,
                then: { _ in controller.finish(result: ()) }
            )
        }
    }
}
