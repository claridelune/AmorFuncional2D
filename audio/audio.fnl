(local beats (fennel.dofile "audio/beats.fnl"))
(local windowPerfect 0.05)
(local windowGreat 0.075)
(local windowOk 0.1)

(var debug1 0)
(var debug2 0)

(var targets [])
(var currentTarget 0)
(var currentTargetTime 0)

(lambda init [numBeats ticToc bpm iniOffset ?musicLoc ?musicVol]
  (let [tocBeats []]
    (each [index value (ipairs ticToc)]
      (table.insert tocBeats (+ value numBeats))
    )
    (beats.init (* 2 numBeats) ticToc tocBeats bpm iniOffset ?musicLoc ?musicVol)
    (set targets tocBeats)
  )
  (set currentTarget 0)
  (when (> (length targets) 0)
    (set currentTargetTime (beats.getBeatTime (. targets (+ 1 currentTarget))))
  )
  (when (not (. _G :offsetInput))
    (tset _G :offsetInput 0)
  )
)

(fn advanceTarget []
  (set currentTarget (% (+ currentTarget 1) (length targets)))
  (set currentTargetTime (beats.getBeatTime (. targets (+ 1 currentTarget))))
)

(fn update [dt]
  (when (and (> (length targets) 0) (< currentTargetTime (- (beats.getCurrentAudioTime) windowOk)))
    (advanceTarget)
  )
  (beats.update dt)
)

(fn drawDebug []
  (love.graphics.print "Button Pressed Time:" 500 25)
  (love.graphics.print debug1 650 25)
  (love.graphics.print "Correct Time: " 500 50)
  (love.graphics.print debug2 650 50)
  (beats.drawDebug)
)

(fn checkBeatState []
  (let [currTime (+ (beats.getCurrentAudioTime) (. _G :offsetInput))]
    (set debug1 currTime)
    (set debug2 currentTargetTime)
    (if
      (and (<= (- currentTargetTime windowPerfect) currTime) (<= currTime (+ currentTargetTime windowPerfect)))
        3
      (and (<= (- currentTargetTime windowGreat) currTime) (<= currTime (+ currentTargetTime windowGreat)))
        2
      (and (<= (- currentTargetTime windowOk) currTime) (<= currTime (+ currentTargetTime windowOk)))
        1
      0
    )
  )
)

(fn getBeatDiff []
  (- currentTargetTime (beats.getCurrentAudioTime))
)

(fn changeBeats [numBeats ticToc]
  (let [tocBeats []]
    (each [index value (ipairs ticToc)]
      (table.insert tocBeats (+ value numBeats))
    )
    (beats.setNextBeats (* 2 numBeats) ticToc tocBeats)
    (set targets tocBeats)
  )
  (set currentTarget 0)
  (when (> (length targets) 0)
    (set currentTargetTime (beats.getBeatTime (. targets (+ 1 currentTarget))))
  )
)

(fn stop []
  (beats.stop)
)

{
  : init
  : advanceTarget
  : update
  : drawDebug
  : checkBeatState
  : getBeatDiff
  : changeBeats
  : stop
}
