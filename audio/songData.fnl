(local songData
    [
        [
            [4 [4]]
            [4 [4]]
            [4 [4]]
            [4 [4]]
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
    ]
)

(local songNames
    [
        :MandatoryOvertime.mp3
    ]
)

(local songBPMs
    [
        188
    ]
)

(local songVolumes
    [
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