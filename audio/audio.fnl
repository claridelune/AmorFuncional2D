(local beats (fennel.dofile "audio/beats.fnl"))
(local windowPerfect 0.07)
(local windowGreat 0.1)
(local windowOk 0.13)

(var debug1 0)
(var debug2 0)
(var debug3 0)

(var config false)

(var targets [])
(var currentTarget 0)
(var currentTargetTime -1)

(lambda init [numBeats ticToc bpm iniOffset debugg ?musicLoc ?musicVol]
  (let [tocBeats []]
    (each [index value (ipairs ticToc)]
      (table.insert tocBeats (+ value numBeats))
    )
    (beats.init (* 2 numBeats) ticToc tocBeats bpm iniOffset ?musicLoc ?musicVol)
    (set targets tocBeats)
  )
  (set config debugg)
  (set currentTarget 0)
  (set currentTargetTime
    (if (> (length targets) 0)
      (beats.getBeatTime (. targets (+ 1 currentTarget)))
      -1
    )
  )

  (when (not (. _G :offsetInput))
    (tset _G :offsetInput 0)
  )
)

(fn advanceTarget []
  (if (= (length targets) 0)
    (set currentTargetTime -1)
    (= (length targets) 1)
    (set currentTargetTime (+ currentTargetTime (beats.getBeatTimeComplete)))
    (do
      (set currentTarget (% (+ currentTarget 1) (length targets)))
      (set currentTargetTime (beats.getBeatTime (. targets (+ 1 currentTarget))))
    )
  )
)

(fn update [dt]
  [(if (and (and (not= currentTargetTime -1) (< currentTargetTime (- (+ (beats.getCurrentAudioTime) (. _G :offsetInput)) windowOk))) (not config))
    (do (advanceTarget) (set debug3 (+ debug3 1)) 1)
    0
  )
  (let [bb (beats.update dt)]
    (when (and config (= bb 1))
      (advanceTarget)
    )
    bb
  )]
  ;(let [bb (beats.update dt)]
  ;  [(if (and (not= currentTargetTime -1) (< currentTargetTime (- (beats.getCurrentAudioTime) windowOk)))
  ;    (do (advanceTarget) 1)
  ;    0
  ;  )
  ;  bb]
  ;)
)

(fn drawDebug []
  (love.graphics.print "Button Pressed Time:" 600 25)
  (love.graphics.print debug1 750 25)
  (love.graphics.print "Correct Time: " 600 50)
  (love.graphics.print debug2 750 50)
  (love.graphics.print "NextTime: " 900 50)
  (love.graphics.print currentTargetTime 1000 50)
  (when (> (length targets) 0)
    (love.graphics.print "Target: " 900 25)
    ;(love.graphics.print (. targets (+ currentTarget 1)) 950 25)
    (love.graphics.print (+ currentTarget 1) 950 25)
  )
  (love.graphics.print "Timeouts: " 900 75)
  (love.graphics.print debug3 1000 75)
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
  (let [ctt (beats.getCurrentAudioTime)]
    (set debug1 (+ ctt (. _G :offsetInput)))
    (set debug2 currentTargetTime)
    (- currentTargetTime ctt)
  )
)

(fn changeBeats [numBeats ticToc]
  (let [tocBeats [] updateTarget (not= currentTarget (- (length targets) 1))]
    (each [index value (ipairs ticToc)]
      (table.insert tocBeats (+ value numBeats))
    )
    (beats.setNextBeats (* 2 numBeats) ticToc tocBeats)
    (set targets tocBeats)
    (set currentTarget -1)
    (when (and (not= (length targets) 0) (or updateTarget (= currentTargetTime -1)))
      (let [potential (beats.getBeatTime (. targets 1))]
        (set currentTarget 0)
        (set currentTargetTime potential)
      )
    )
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
