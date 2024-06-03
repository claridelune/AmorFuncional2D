(local songs [])
(var lastBeat 0)
(var bpm 0)
(var beatDur 0)
(var songPos 0)
(var music nil)
(var musicStart 0)
(var started false)
(var startedTime 0)

(lambda init [bpmm offset ?songId]
    (when ?songId
        (set music (love.audio.newSource (. songs ?songId) :stream))
    )
    (set startedTime (love.timer.getTime))
    (set musicStart (+ (love.timer.getTime) offset))
    (set lastBeat (- musicStart beatDur))
    (set bpm bpmm)
    (set beatDur (/ 60 bpm))
)

(fn getCurrentAudioTime []
    (if (and music started)
        (* (music:tell :seconds) (music:getPitch))
        (- (love.timer.getTime) musicStart)
    )
)

(fn update [dt]
    (when (and (and (not started) music) (>= (- (love.timer.getTime) startedTime) musicStart))
        (music:play)
        (set started true)
    )
    (let [currTime (getCurrentAudioTime)
        newBeat? (>= currTime (+ lastBeat beatDur))]
        (set songPos currTime)
        (when newBeat?
            (set lastBeat (+ lastBeat beatDur))
        )
        newBeat?
    )
)

(fn draw []
    (love.graphics.print lastBeat 100 200)
    (love.graphics.print beatDur 200 200)
    (love.graphics.print (love.timer.getTime) 300 200)
)

(fn get2CorrectTimes []
    [lastBeat (+ lastBeat beatDur)]
)

{
    : bpm
    : beatDur
    : update
    : init
    : draw
    : get2CorrectTimes
    : getCurrentAudioTime
}