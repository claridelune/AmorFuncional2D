(local songData
    [
        [
            [4 [2]]
            [4 [2]]
            [4 [2]]
            [4 [2]]
            [4 [1 3]]
            [4 [1 3]]
            [4 [1 3]]
            [4 [1 3]]
            [4 [2 4]]
            [4 [2 4]]
            [4 [2 4]]
            [4 [2 4]]
            [8 [1 3 5 8]]
            [8 [1 3 5 8]]
            [1 []]
        ]
        [
            [4 [2 4]]
            [4 [2 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [2 4]]
            [4 [2 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [2 4]]
            [4 [2 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [2 4]]
            [4 [2 4]]
            [1 []]
        ]
        [
            [4 [2 4]]
            [4 [2 4]]
            [8 [1 2 4 6]]
            [8 [1 2 3 4 5 6 7 8]]
            [8 [1 2 5 6 7 8]]
            [8 [5 7]]
            [8 [1 2 4 6]]
            [8 [1 2 4 6]]
            [8 [1 2 5 7]]
            [1 []]
        ]
        [
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [4 [1 2 3 4]]
            [1 []]
        ]
    ]
)

(local songNames
    [
        :MandatoryOvertime.mp3
        :march.mp3
        :OnMyWay.wav
        :A7-Eb7-Dmajor7.mp3
    ]
)

(local songBPMs
    [
        188
        120
        150.75
        140
    ]
)

(local songVolumes
    [
        0.3
        0.1
        0.4
        0.3
    ]
)

(fn getBeats [song bar]
    (. (. songData song) bar)
)

(fn getSongTitle [song]
    (.. :assets/ (. songNames song))
)

(fn getSongBPM [song]
    (. songBPMs song)
)

(fn getSongVolume [song]
    (. songVolumes song)
)

{
    : getBeats
    : getSongTitle
    : getSongBPM
    : getSongVolume
}
