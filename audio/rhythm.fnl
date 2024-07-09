(var lastBeat 0)
(var bpm 0)
(var beatDur 0)
(var music nil)
(var musicStart 0)
(var started false)

(lambda init [bpmm offset ?songLoc ?songVol]
    (when ?songLoc
        (set music (love.audio.newSource ?songLoc :stream))
        (when ?songVol
            (music:setVolume ?songVol)
        )
    )
    (set musicStart (+ (love.timer.getTime) offset))
    (set bpm bpmm)
    (set beatDur (/ 60 bpm))
    (set lastBeat (- 0 beatDur))
)

(fn getCurrentAudioTime []
    (if (and music started)
        (* (music:tell :seconds) (music:getPitch))
        (- (love.timer.getTime) musicStart)
    )
)

(fn update [dt]
    (when (and (and (not started) music) (>= (love.timer.getTime) musicStart))
        (music:play)
        (set started true)
    )
    (let [currTime (getCurrentAudioTime)
        newBeat? (>= currTime (+ lastBeat beatDur))]
        (when newBeat?
            (set lastBeat (+ lastBeat beatDur))
        )
        newBeat?
    )
)

(fn drawDebug []
    (love.graphics.print "Last Beat:" 50 25)
    (love.graphics.print lastBeat 150 25)
    (love.graphics.print "Beat Duration:" 50 50)
    (love.graphics.print beatDur 150 50)
)

(fn getUpcomingBeatTime [upcoming]
    (+ lastBeat (* upcoming beatDur))
)

(fn getBeatDuration []
    beatDur
)

(fn stop []
    (when music
        (music:stop)
    )
    (set music nil)
    (set started false)
)

(fn audioFinished []
    (if music
        (and (not (music:isPlaying)) started)
        ;(and (music:isPlaying) started)
        false
    )
)

{
    : update
    : init
    : drawDebug
    : getUpcomingBeatTime
    : getCurrentAudioTime
    : getBeatDuration
    : audioFinished
    : stop
}