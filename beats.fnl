(local rhythm (fennel.dofile "rhythm.fnl"))
(local ticSound (love.audio.newSource "assets/tic.wav" :static))
(local tocSound (love.audio.newSource "assets/toc.wav" :static))

(var beats [0 0 0 0 0 0 0 0])
(var currBeat -1)

(lambda init [ticB tocB bpm offset ?songId]
    (each [index value (ipairs ticB)]
        (tset beats value 1)
    )
    (each [index value (ipairs tocB)]
        (tset beats value 2)
    )
    (rhythm.init bpm offset ?songId)
)

(fn update [dt]
    (when (rhythm.update dt)
        (set currBeat (% (+ currBeat 1) 8))
        (when (= (. beats (+ 1 currBeat)) 1)
            (ticSound:stop)
            (ticSound:play)
        )
        (when (= (. beats (+ 1 currBeat)) 2)
            (tocSound:stop)
            (tocSound:play)
        )
    )
)

(fn draw []
    (rhythm:draw)
    (each [index value (ipairs beats)]
        (love.graphics.print value (+ 100 (* index 10)) 300)
    )
)

(fn get2Beats []
    [currBeat (+ 1 currBeat)]
)

(fn get2CorrectTimes []
    (rhythm.get2CorrectTimes)
)

(fn getCurrentAudioTime []
    (rhythm.getCurrentAudioTime)
)

{
    : draw
    : update
    : init
    : draw
    : get2Beats
    : get2CorrectTimes
    : getCurrentAudioTime
}