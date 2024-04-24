//
//  MyTmer.swift
//  GachMap
//
//  Created by 이수현 on 4/24/24.
//

import Foundation

class MyTimer : ObservableObject {
    var timer: Timer?
    @Published var seconds = 0

    // 타이머 시작
    func startTimer() {
        // 타이머가 이미 실행 중인 경우 중복 실행 방지
        if timer == nil || !(timer!.isValid) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        seconds = 0
        timer = nil
    }
    
    @objc func timerFired() {
        // 이 메서드는 타이머가 동작할 때마다 호출됩니다.
        seconds += 1
        print("타이머 동작 중! 경과 시간: \(seconds) 초")
    }
}
