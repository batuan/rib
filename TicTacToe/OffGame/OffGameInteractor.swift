//
//  OffGameInteractor.swift
//  TicTacToe
//
//  Created by Thai Ba Tuan on 6/21/19.
//  Copyright © 2019 Uber. All rights reserved.
//

import RIBs
import RxSwift

protocol OffGameRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OffGamePresentable: Presentable {
    var listener: OffGamePresentableListener? { get set }
    func set(score: Score)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol OffGameListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func startTicTacToe()
}

final class OffGameInteractor: PresentableInteractor<OffGamePresentable>, OffGameInteractable, OffGamePresentableListener {
    func startGame() {
        listener?.startTicTacToe()
    }
    

    weak var router: OffGameRouting?
    weak var listener: OffGameListener?

    private let scoreStream: ScoreStream

    init(presenter: OffGamePresentable,
         scoreStream: ScoreStream) {
        self.scoreStream = scoreStream
        super.init(presenter: presenter)
        presenter.listener = self
    }
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        updateScore()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func updateScore() {
        scoreStream.score
            .subscribe(
                onNext: { (score: Score) in
                    self.presenter.set(score: score)
            }
            )
            .disposeOnDeactivate(interactor: self)
    }
}
