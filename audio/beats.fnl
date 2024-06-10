(local rhythm (fennel.dofile "audio/rhythm.fnl"))
(local ticSound (love.audio.newSource "assets/tic.wav" :static))
(local tocSound (love.audio.newSource "assets/toc.wav" :static))

(var beats [])
(var bSize 0)
(var currBeat -1)

(fn updateBeats [beatsSize ticB tocB]
    (while (> (length beats) 0)
        (table.remove beats)
    )
    (for [i 1 beatsSize]
        (table.insert beats 0)
    )
    (each [index value (ipairs ticB)]
        (tset beats value 1)
    )
    (each [index value (ipairs tocB)]
        (tset beats value 2)
    )
    (set bSize beatsSize)
    (set currBeat (- bSize 1))
)

(lambda init [beatsSize ticB tocB bpm offset ?songLoc ?songVol]
    (updateBeats beatsSize ticB tocB)
    (rhythm.init bpm offset ?songLoc ?songVol)
)

(fn update [dt]
    (when (rhythm.update dt)
        (set currBeat (% (+ currBeat 1) bSize))
        (when (= (. beats (+ 1 currBeat)) 1)
            (ticSound:stop)
            (ticSound:play)
        )
        (when (= (. beats (+ 1 currBeat)) 2)
            (tocSound:stop)
            (tocSound:play)
        )
        (= currBeat (- bSize 1))
    )
)

(fn drawDebug []
    (rhythm:drawDebug)
    (love.graphics.print "Beats:" 300 25)
    (each [index value (ipairs beats)]
        (love.graphics.print value (+ 350 (* index 10)) 25)
    )
)

(fn getBeatTime [index]
    (let [trans (if (<= currBeat index) (- index currBeat) (- bSize (- currBeat index)))]
        (rhythm.getUpcomingBeatTime trans)
    )
)

(fn getCurrentAudioTime []
    (rhythm.getCurrentAudioTime)
)

(fn setNextBeats [beatsSize newBeatsTic newBeatsToc]
    (updateBeats beatsSize newBeatsTic newBeatsToc)
)

(fn stop []
    (rhythm.stop)
)

{
    : drawDebug
    : update
    : init
    : getBeatTime
    : getCurrentAudioTime
    : setNextBeats
    : stop
}