/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                            UserSamplerInstrument
 This file is where all code related to the user instrument is.

                    Internally-called Functions
 init()
 choosePlayer()
 
                    Externally-called Functions
 changeTransposition()
 changeScaleChoice()
 playNote()
 stopNote()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

import AudioKit

open class AudioSampler {
    
    var playerPianoSampleFsharp3v127: AKAudioPlayer
    var playerPianoSampleG3v127: AKAudioPlayer
    var playerPianoSampleGsharp3v127: AKAudioPlayer
    var playerPianoSampleA3v127: AKAudioPlayer
    var playerPianoSampleAsharp3v127: AKAudioPlayer
    var playerPianoSampleB3v127: AKAudioPlayer
    var playerPianoSampleC4v127: AKAudioPlayer
    var playerPianoSampleCsharp4v127: AKAudioPlayer
    var playerPianoSampleD4v127: AKAudioPlayer
    var playerPianoSampleDsharp4v127: AKAudioPlayer
    var playerPianoSampleE4v127: AKAudioPlayer
    var playerPianoSampleF4v127: AKAudioPlayer
    var playerPianoSampleFsharp4v127: AKAudioPlayer
    var playerPianoSampleG4v127: AKAudioPlayer
    var playerPianoSampleGsharp4v127: AKAudioPlayer
    var playerPianoSampleA4v127: AKAudioPlayer
    var playerPianoSampleAsharp4v127: AKAudioPlayer
    var playerPianoSampleB4v127: AKAudioPlayer
    var playerPianoSampleC5v127: AKAudioPlayer
    var playerPianoSampleCsharp5v127: AKAudioPlayer
    var playerPianoSampleD5v127: AKAudioPlayer
    var playerPianoSampleDsharp5v127: AKAudioPlayer
    var playerPianoSampleE5v127: AKAudioPlayer
    var playerPianoSampleF5v127: AKAudioPlayer
    
    var playerSynthSampleFsharp3v127: AKAudioPlayer
    var playerSynthSampleG3v127: AKAudioPlayer
    var playerSynthSampleGsharp3v127: AKAudioPlayer
    var playerSynthSampleA3v127: AKAudioPlayer
    var playerSynthSampleAsharp3v127: AKAudioPlayer
    var playerSynthSampleB3v127: AKAudioPlayer
    var playerSynthSampleC4v127: AKAudioPlayer
    var playerSynthSampleCsharp4v127: AKAudioPlayer
    var playerSynthSampleD4v127: AKAudioPlayer
    var playerSynthSampleDsharp4v127: AKAudioPlayer
    var playerSynthSampleE4v127: AKAudioPlayer
    var playerSynthSampleF4v127: AKAudioPlayer
    var playerSynthSampleFsharp4v127: AKAudioPlayer
    var playerSynthSampleG4v127: AKAudioPlayer
    var playerSynthSampleGsharp4v127: AKAudioPlayer
    var playerSynthSampleA4v127: AKAudioPlayer
    var playerSynthSampleAsharp4v127: AKAudioPlayer
    var playerSynthSampleB4v127: AKAudioPlayer
    var playerSynthSampleC5v127: AKAudioPlayer
    var playerSynthSampleCsharp5v127: AKAudioPlayer
    var playerSynthSampleD5v127: AKAudioPlayer
    var playerSynthSampleDsharp5v127: AKAudioPlayer
    var playerSynthSampleE5v127: AKAudioPlayer
    var playerSynthSampleF5v127: AKAudioPlayer
    
    var playerStringsSampleFsharp3v127: AKAudioPlayer
    var playerStringsSampleG3v127: AKAudioPlayer
    var playerStringsSampleGsharp3v127: AKAudioPlayer
    var playerStringsSampleA3v127: AKAudioPlayer
    var playerStringsSampleAsharp3v127: AKAudioPlayer
    var playerStringsSampleB3v127: AKAudioPlayer
    var playerStringsSampleC4v127: AKAudioPlayer
    var playerStringsSampleCsharp4v127: AKAudioPlayer
    var playerStringsSampleD4v127: AKAudioPlayer
    var playerStringsSampleDsharp4v127: AKAudioPlayer
    var playerStringsSampleE4v127: AKAudioPlayer
    var playerStringsSampleF4v127: AKAudioPlayer
    var playerStringsSampleFsharp4v127: AKAudioPlayer
    var playerStringsSampleG4v127: AKAudioPlayer
    var playerStringsSampleGsharp4v127: AKAudioPlayer
    var playerStringsSampleA4v127: AKAudioPlayer
    var playerStringsSampleAsharp4v127: AKAudioPlayer
    var playerStringsSampleB4v127: AKAudioPlayer
    var playerStringsSampleC5v127: AKAudioPlayer
    var playerStringsSampleCsharp5v127: AKAudioPlayer
    var playerStringsSampleD5v127: AKAudioPlayer
    var playerStringsSampleDsharp5v127: AKAudioPlayer
    var playerStringsSampleE5v127: AKAudioPlayer
    var playerStringsSampleF5v127: AKAudioPlayer
    
    var playerGuitarSampleFsharp3v127: AKAudioPlayer
    var playerGuitarSampleG3v127: AKAudioPlayer
    var playerGuitarSampleGsharp3v127: AKAudioPlayer
    var playerGuitarSampleA3v127: AKAudioPlayer
    var playerGuitarSampleAsharp3v127: AKAudioPlayer
    var playerGuitarSampleB3v127: AKAudioPlayer
    var playerGuitarSampleC4v127: AKAudioPlayer
    var playerGuitarSampleCsharp4v127: AKAudioPlayer
    var playerGuitarSampleD4v127: AKAudioPlayer
    var playerGuitarSampleDsharp4v127: AKAudioPlayer
    var playerGuitarSampleE4v127: AKAudioPlayer
    var playerGuitarSampleF4v127: AKAudioPlayer
    var playerGuitarSampleFsharp4v127: AKAudioPlayer
    var playerGuitarSampleG4v127: AKAudioPlayer
    var playerGuitarSampleGsharp4v127: AKAudioPlayer
    var playerGuitarSampleA4v127: AKAudioPlayer
    var playerGuitarSampleAsharp4v127: AKAudioPlayer
    var playerGuitarSampleB4v127: AKAudioPlayer
    var playerGuitarSampleC5v127: AKAudioPlayer
    var playerGuitarSampleCsharp5v127: AKAudioPlayer
    var playerGuitarSampleD5v127: AKAudioPlayer
    var playerGuitarSampleDsharp5v127: AKAudioPlayer
    var playerGuitarSampleE5v127: AKAudioPlayer
    var playerGuitarSampleF5v127: AKAudioPlayer
    
    var samplerOutput: AKNode!
    
    var scaleChoice: Int
    var transposeAmount: Int
    
// ~~~~~~~~~~~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~
    
    init () {
        // Set up variables & constants
        scaleChoice = 0
        transposeAmount = 0
        
        let pianoSampleFsharp3v127 = try! AKAudioFile(readFileName: "PianoUserFsharp3v127.wav", baseDir: .resources)
        let pianoSampleG3v127 = try! AKAudioFile(readFileName: "PianoUserG3v127.wav", baseDir: .resources)
        let pianoSampleGsharp3v127 = try! AKAudioFile(readFileName: "PianoUserGsharp3v127.wav", baseDir: .resources)
        let pianoSampleA3v127 = try! AKAudioFile(readFileName: "PianoUserA3v127.wav", baseDir: .resources)
        let pianoSampleAsharp3v127 = try! AKAudioFile(readFileName: "PianoUserAsharp3v127.wav", baseDir: .resources)
        let pianoSampleB3v127 = try! AKAudioFile(readFileName: "PianoUserB3v127.wav", baseDir: .resources)
        let pianoSampleC4v127 = try! AKAudioFile(readFileName: "PianoUserC4v127.wav", baseDir: .resources)
        let pianoSampleCsharp4v127 = try! AKAudioFile(readFileName: "PianoUserCsharp4v127.wav", baseDir: .resources)
        let pianoSampleD4v127 = try! AKAudioFile(readFileName: "PianoUserD4v127.wav", baseDir: .resources)
        let pianoSampleDsharp4v127 = try! AKAudioFile(readFileName: "PianoUserDsharp4v127.wav", baseDir: .resources)
        let pianoSampleE4v127 = try! AKAudioFile(readFileName: "PianoUserE4v127.wav", baseDir: .resources)
        let pianoSampleF4v127 = try! AKAudioFile(readFileName: "PianoUserF4v127.wav", baseDir: .resources)
        let pianoSampleFsharp4v127 = try! AKAudioFile(readFileName: "PianoUserFsharp4v127.wav", baseDir: .resources)
        let pianoSampleG4v127 = try! AKAudioFile(readFileName: "PianoUserG4v127.wav", baseDir: .resources)
        let pianoSampleGsharp4v127 = try! AKAudioFile(readFileName: "PianoUserGsharp4v127.wav", baseDir: .resources)
        let pianoSampleA4v127 = try! AKAudioFile(readFileName: "PianoUserA4v127.wav", baseDir: .resources)
        let pianoSampleAsharp4v127 = try! AKAudioFile(readFileName: "PianoUserAsharp4v127.wav", baseDir: .resources)
        let pianoSampleB4v127 = try! AKAudioFile(readFileName: "PianoUserB4v127.wav", baseDir: .resources)
        let pianoSampleC5v127 = try! AKAudioFile(readFileName: "PianoUserC5v127.wav", baseDir: .resources)
        let pianoSampleCsharp5v127 = try! AKAudioFile(readFileName: "PianoUserCsharp5v127.wav", baseDir: .resources)
        let pianoSampleD5v127 = try! AKAudioFile(readFileName: "PianoUserD5v127.wav", baseDir: .resources)
        let pianoSampleDsharp5v127 = try! AKAudioFile(readFileName: "PianoUserDsharp5v127.wav", baseDir: .resources)
        let pianoSampleE5v127 = try! AKAudioFile(readFileName: "PianoUserE5v127.wav", baseDir: .resources)
        let pianoSampleF5v127 = try! AKAudioFile(readFileName: "PianoUserF5v127.wav", baseDir: .resources)
        
        let synthSampleFsharp3v127 = try! AKAudioFile(readFileName: "SynthUserFsharp3v127.wav", baseDir: .resources)
        let synthSampleG3v127 = try! AKAudioFile(readFileName: "SynthUserG3v127.wav", baseDir: .resources)
        let synthSampleGsharp3v127 = try! AKAudioFile(readFileName: "SynthUserGsharp3v127.wav", baseDir: .resources)
        let synthSampleA3v127 = try! AKAudioFile(readFileName: "SynthUserA3v127.wav", baseDir: .resources)
        let synthSampleAsharp3v127 = try! AKAudioFile(readFileName: "SynthUserAsharp3v127.wav", baseDir: .resources)
        let synthSampleB3v127 = try! AKAudioFile(readFileName: "SynthUserB3v127.wav", baseDir: .resources)
        let synthSampleC4v127 = try! AKAudioFile(readFileName: "SynthUserC4v127.wav", baseDir: .resources)
        let synthSampleCsharp4v127 = try! AKAudioFile(readFileName: "SynthUserCsharp4v127.wav", baseDir: .resources)
        let synthSampleD4v127 = try! AKAudioFile(readFileName: "SynthUserD4v127.wav", baseDir: .resources)
        let synthSampleDsharp4v127 = try! AKAudioFile(readFileName: "SynthUserDsharp4v127.wav", baseDir: .resources)
        let synthSampleE4v127 = try! AKAudioFile(readFileName: "SynthUserE4v127.wav", baseDir: .resources)
        let synthSampleF4v127 = try! AKAudioFile(readFileName: "SynthUserF4v127.wav", baseDir: .resources)
        let synthSampleFsharp4v127 = try! AKAudioFile(readFileName: "SynthUserFsharp4v127.wav", baseDir: .resources)
        let synthSampleG4v127 = try! AKAudioFile(readFileName: "SynthUserG4v127.wav", baseDir: .resources)
        let synthSampleGsharp4v127 = try! AKAudioFile(readFileName: "SynthUserGsharp4v127.wav", baseDir: .resources)
        let synthSampleA4v127 = try! AKAudioFile(readFileName: "SynthUserA4v127.wav", baseDir: .resources)
        let synthSampleAsharp4v127 = try! AKAudioFile(readFileName: "SynthUserAsharp4v127.wav", baseDir: .resources)
        let synthSampleB4v127 = try! AKAudioFile(readFileName: "SynthUserB4v127.wav", baseDir: .resources)
        let synthSampleC5v127 = try! AKAudioFile(readFileName: "SynthUserC5v127.wav", baseDir: .resources)
        let synthSampleCsharp5v127 = try! AKAudioFile(readFileName: "SynthUserCsharp5v127.wav", baseDir: .resources)
        let synthSampleD5v127 = try! AKAudioFile(readFileName: "SynthUserD5v127.wav", baseDir: .resources)
        let synthSampleDsharp5v127 = try! AKAudioFile(readFileName: "SynthUserDsharp5v127.wav", baseDir: .resources)
        let synthSampleE5v127 = try! AKAudioFile(readFileName: "SynthUserE5v127.wav", baseDir: .resources)
        let synthSampleF5v127 = try! AKAudioFile(readFileName: "SynthUserF5v127.wav", baseDir: .resources)
        
        let stringsSampleFsharp3v127 = try! AKAudioFile(readFileName: "StringsUserFsharp3v127.wav", baseDir: .resources)
        let stringsSampleG3v127 = try! AKAudioFile(readFileName: "StringsUserG3v127.wav", baseDir: .resources)
        let stringsSampleGsharp3v127 = try! AKAudioFile(readFileName: "StringsUserGsharp3v127.wav", baseDir: .resources)
        let stringsSampleA3v127 = try! AKAudioFile(readFileName: "StringsUserA3v127.wav", baseDir: .resources)
        let stringsSampleAsharp3v127 = try! AKAudioFile(readFileName: "StringsUserAsharp3v127.wav", baseDir: .resources)
        let stringsSampleB3v127 = try! AKAudioFile(readFileName: "StringsUserB3v127.wav", baseDir: .resources)
        let stringsSampleC4v127 = try! AKAudioFile(readFileName: "StringsUserC4v127.wav", baseDir: .resources)
        let stringsSampleCsharp4v127 = try! AKAudioFile(readFileName: "StringsUserCsharp4v127.wav", baseDir: .resources)
        let stringsSampleD4v127 = try! AKAudioFile(readFileName: "StringsUserD4v127.wav", baseDir: .resources)
        let stringsSampleDsharp4v127 = try! AKAudioFile(readFileName: "StringsUserDsharp4v127.wav", baseDir: .resources)
        let stringsSampleE4v127 = try! AKAudioFile(readFileName: "StringsUserE4v127.wav", baseDir: .resources)
        let stringsSampleF4v127 = try! AKAudioFile(readFileName: "StringsUserF4v127.wav", baseDir: .resources)
        let stringsSampleFsharp4v127 = try! AKAudioFile(readFileName: "StringsUserFsharp4v127.wav", baseDir: .resources)
        let stringsSampleG4v127 = try! AKAudioFile(readFileName: "StringsUserG4v127.wav", baseDir: .resources)
        let stringsSampleGsharp4v127 = try! AKAudioFile(readFileName: "StringsUserGsharp4v127.wav", baseDir: .resources)
        let stringsSampleA4v127 = try! AKAudioFile(readFileName: "StringsUserA4v127.wav", baseDir: .resources)
        let stringsSampleAsharp4v127 = try! AKAudioFile(readFileName: "StringsUserAsharp4v127.wav", baseDir: .resources)
        let stringsSampleB4v127 = try! AKAudioFile(readFileName: "StringsUserB4v127.wav", baseDir: .resources)
        let stringsSampleC5v127 = try! AKAudioFile(readFileName: "StringsUserC5v127.wav", baseDir: .resources)
        let stringsSampleCsharp5v127 = try! AKAudioFile(readFileName: "StringsUserCsharp5v127.wav", baseDir: .resources)
        let stringsSampleD5v127 = try! AKAudioFile(readFileName: "StringsUserD5v127.wav", baseDir: .resources)
        let stringsSampleDsharp5v127 = try! AKAudioFile(readFileName: "StringsUserDsharp5v127.wav", baseDir: .resources)
        let stringsSampleE5v127 = try! AKAudioFile(readFileName: "StringsUserE5v127.wav", baseDir: .resources)
        let stringsSampleF5v127 = try! AKAudioFile(readFileName: "StringsUserF5v127.wav", baseDir: .resources)
        
        let guitarSampleFsharp3v127 = try! AKAudioFile(readFileName: "GuitarUserFsharp3v127.wav", baseDir: .resources)
        let guitarSampleG3v127 = try! AKAudioFile(readFileName: "GuitarUserG3v127.wav", baseDir: .resources)
        let guitarSampleGsharp3v127 = try! AKAudioFile(readFileName: "GuitarUserGsharp3v127.wav", baseDir: .resources)
        let guitarSampleA3v127 = try! AKAudioFile(readFileName: "GuitarUserA3v127.wav", baseDir: .resources)
        let guitarSampleAsharp3v127 = try! AKAudioFile(readFileName: "GuitarUserAsharp3v127.wav", baseDir: .resources)
        let guitarSampleB3v127 = try! AKAudioFile(readFileName: "GuitarUserB3v127.wav", baseDir: .resources)
        let guitarSampleC4v127 = try! AKAudioFile(readFileName: "GuitarUserC4v127.wav", baseDir: .resources)
        let guitarSampleCsharp4v127 = try! AKAudioFile(readFileName: "GuitarUserCsharp4v127.wav", baseDir: .resources)
        let guitarSampleD4v127 = try! AKAudioFile(readFileName: "GuitarUserD4v127.wav", baseDir: .resources)
        let guitarSampleDsharp4v127 = try! AKAudioFile(readFileName: "GuitarUserDsharp4v127.wav", baseDir: .resources)
        let guitarSampleE4v127 = try! AKAudioFile(readFileName: "GuitarUserE4v127.wav", baseDir: .resources)
        let guitarSampleF4v127 = try! AKAudioFile(readFileName: "GuitarUserF4v127.wav", baseDir: .resources)
        let guitarSampleFsharp4v127 = try! AKAudioFile(readFileName: "GuitarUserFsharp4v127.wav", baseDir: .resources)
        let guitarSampleG4v127 = try! AKAudioFile(readFileName: "GuitarUserG4v127.wav", baseDir: .resources)
        let guitarSampleGsharp4v127 = try! AKAudioFile(readFileName: "GuitarUserGsharp4v127.wav", baseDir: .resources)
        let guitarSampleA4v127 = try! AKAudioFile(readFileName: "GuitarUserA4v127.wav", baseDir: .resources)
        let guitarSampleAsharp4v127 = try! AKAudioFile(readFileName: "GuitarUserAsharp4v127.wav", baseDir: .resources)
        let guitarSampleB4v127 = try! AKAudioFile(readFileName: "GuitarUserB4v127.wav", baseDir: .resources)
        let guitarSampleC5v127 = try! AKAudioFile(readFileName: "GuitarUserC5v127.wav", baseDir: .resources)
        let guitarSampleCsharp5v127 = try! AKAudioFile(readFileName: "GuitarUserCsharp5v127.wav", baseDir: .resources)
        let guitarSampleD5v127 = try! AKAudioFile(readFileName: "GuitarUserD5v127.wav", baseDir: .resources)
        let guitarSampleDsharp5v127 = try! AKAudioFile(readFileName: "GuitarUserDsharp5v127.wav", baseDir: .resources)
        let guitarSampleE5v127 = try! AKAudioFile(readFileName: "GuitarUserE5v127.wav", baseDir: .resources)
        let guitarSampleF5v127 = try! AKAudioFile(readFileName: "GuitarUserF5v127.wav", baseDir: .resources)
        
        // Attach players
        playerPianoSampleFsharp3v127 = try! AKAudioPlayer(file: pianoSampleFsharp3v127)
        playerPianoSampleG3v127 = try! AKAudioPlayer(file: pianoSampleG3v127)
        playerPianoSampleGsharp3v127 = try! AKAudioPlayer(file: pianoSampleGsharp3v127)
        playerPianoSampleA3v127 = try! AKAudioPlayer(file: pianoSampleA3v127)
        playerPianoSampleAsharp3v127 = try! AKAudioPlayer(file: pianoSampleAsharp3v127)
        playerPianoSampleB3v127 = try! AKAudioPlayer(file: pianoSampleB3v127)
        playerPianoSampleC4v127 = try! AKAudioPlayer(file: pianoSampleC4v127)
        playerPianoSampleCsharp4v127 = try! AKAudioPlayer(file: pianoSampleCsharp4v127)
        playerPianoSampleD4v127 = try! AKAudioPlayer(file: pianoSampleD4v127)
        playerPianoSampleDsharp4v127 = try! AKAudioPlayer(file: pianoSampleDsharp4v127)
        playerPianoSampleE4v127 = try! AKAudioPlayer(file: pianoSampleE4v127)
        playerPianoSampleF4v127 = try! AKAudioPlayer(file: pianoSampleF4v127)
        playerPianoSampleFsharp4v127 = try! AKAudioPlayer(file: pianoSampleFsharp4v127)
        playerPianoSampleG4v127 = try! AKAudioPlayer(file: pianoSampleG4v127)
        playerPianoSampleGsharp4v127 = try! AKAudioPlayer(file: pianoSampleGsharp4v127)
        playerPianoSampleA4v127 = try! AKAudioPlayer(file: pianoSampleA4v127)
        playerPianoSampleAsharp4v127 = try! AKAudioPlayer(file: pianoSampleAsharp4v127)
        playerPianoSampleB4v127 = try! AKAudioPlayer(file: pianoSampleB4v127)
        playerPianoSampleC5v127 = try! AKAudioPlayer(file: pianoSampleC5v127)
        playerPianoSampleCsharp5v127 = try! AKAudioPlayer(file: pianoSampleCsharp5v127)
        playerPianoSampleD5v127 = try! AKAudioPlayer(file: pianoSampleD5v127)
        playerPianoSampleDsharp5v127 = try! AKAudioPlayer(file: pianoSampleDsharp5v127)
        playerPianoSampleE5v127 = try! AKAudioPlayer(file: pianoSampleE5v127)
        playerPianoSampleF5v127 = try! AKAudioPlayer(file: pianoSampleF5v127)
        
        playerSynthSampleFsharp3v127 = try! AKAudioPlayer(file: synthSampleFsharp3v127)
        playerSynthSampleG3v127 = try! AKAudioPlayer(file: synthSampleG3v127)
        playerSynthSampleGsharp3v127 = try! AKAudioPlayer(file: synthSampleGsharp3v127)
        playerSynthSampleA3v127 = try! AKAudioPlayer(file: synthSampleA3v127)
        playerSynthSampleAsharp3v127 = try! AKAudioPlayer(file: synthSampleAsharp3v127)
        playerSynthSampleB3v127 = try! AKAudioPlayer(file: synthSampleB3v127)
        playerSynthSampleC4v127 = try! AKAudioPlayer(file: synthSampleC4v127)
        playerSynthSampleCsharp4v127 = try! AKAudioPlayer(file: synthSampleCsharp4v127)
        playerSynthSampleD4v127 = try! AKAudioPlayer(file: synthSampleD4v127)
        playerSynthSampleDsharp4v127 = try! AKAudioPlayer(file: synthSampleDsharp4v127)
        playerSynthSampleE4v127 = try! AKAudioPlayer(file: synthSampleE4v127)
        playerSynthSampleF4v127 = try! AKAudioPlayer(file: synthSampleF4v127)
        playerSynthSampleFsharp4v127 = try! AKAudioPlayer(file: synthSampleFsharp4v127)
        playerSynthSampleG4v127 = try! AKAudioPlayer(file: synthSampleG4v127)
        playerSynthSampleGsharp4v127 = try! AKAudioPlayer(file: synthSampleGsharp4v127)
        playerSynthSampleA4v127 = try! AKAudioPlayer(file: synthSampleA4v127)
        playerSynthSampleAsharp4v127 = try! AKAudioPlayer(file: synthSampleAsharp4v127)
        playerSynthSampleB4v127 = try! AKAudioPlayer(file: synthSampleB4v127)
        playerSynthSampleC5v127 = try! AKAudioPlayer(file: synthSampleC5v127)
        playerSynthSampleCsharp5v127 = try! AKAudioPlayer(file: synthSampleCsharp5v127)
        playerSynthSampleD5v127 = try! AKAudioPlayer(file: synthSampleD5v127)
        playerSynthSampleDsharp5v127 = try! AKAudioPlayer(file: synthSampleDsharp5v127)
        playerSynthSampleE5v127 = try! AKAudioPlayer(file: synthSampleE5v127)
        playerSynthSampleF5v127 = try! AKAudioPlayer(file: synthSampleF5v127)
        
        playerStringsSampleFsharp3v127 = try! AKAudioPlayer(file: stringsSampleFsharp3v127)
        playerStringsSampleG3v127 = try! AKAudioPlayer(file: stringsSampleG3v127)
        playerStringsSampleGsharp3v127 = try! AKAudioPlayer(file: stringsSampleGsharp3v127)
        playerStringsSampleA3v127 = try! AKAudioPlayer(file: stringsSampleA3v127)
        playerStringsSampleAsharp3v127 = try! AKAudioPlayer(file: stringsSampleAsharp3v127)
        playerStringsSampleB3v127 = try! AKAudioPlayer(file: stringsSampleB3v127)
        playerStringsSampleC4v127 = try! AKAudioPlayer(file: stringsSampleC4v127)
        playerStringsSampleCsharp4v127 = try! AKAudioPlayer(file: stringsSampleCsharp4v127)
        playerStringsSampleD4v127 = try! AKAudioPlayer(file: stringsSampleD4v127)
        playerStringsSampleDsharp4v127 = try! AKAudioPlayer(file: stringsSampleDsharp4v127)
        playerStringsSampleE4v127 = try! AKAudioPlayer(file: stringsSampleE4v127)
        playerStringsSampleF4v127 = try! AKAudioPlayer(file: stringsSampleF4v127)
        playerStringsSampleFsharp4v127 = try! AKAudioPlayer(file: stringsSampleFsharp4v127)
        playerStringsSampleG4v127 = try! AKAudioPlayer(file: stringsSampleG4v127)
        playerStringsSampleGsharp4v127 = try! AKAudioPlayer(file: stringsSampleGsharp4v127)
        playerStringsSampleA4v127 = try! AKAudioPlayer(file: stringsSampleA4v127)
        playerStringsSampleAsharp4v127 = try! AKAudioPlayer(file: stringsSampleAsharp4v127)
        playerStringsSampleB4v127 = try! AKAudioPlayer(file: stringsSampleB4v127)
        playerStringsSampleC5v127 = try! AKAudioPlayer(file: stringsSampleC5v127)
        playerStringsSampleCsharp5v127 = try! AKAudioPlayer(file: stringsSampleCsharp5v127)
        playerStringsSampleD5v127 = try! AKAudioPlayer(file: stringsSampleD5v127)
        playerStringsSampleDsharp5v127 = try! AKAudioPlayer(file: stringsSampleDsharp5v127)
        playerStringsSampleE5v127 = try! AKAudioPlayer(file: stringsSampleE5v127)
        playerStringsSampleF5v127 = try! AKAudioPlayer(file: stringsSampleF5v127)
        
        playerGuitarSampleFsharp3v127 = try! AKAudioPlayer(file: guitarSampleFsharp3v127)
        playerGuitarSampleG3v127 = try! AKAudioPlayer(file: guitarSampleG3v127)
        playerGuitarSampleGsharp3v127 = try! AKAudioPlayer(file: guitarSampleGsharp3v127)
        playerGuitarSampleA3v127 = try! AKAudioPlayer(file: guitarSampleA3v127)
        playerGuitarSampleAsharp3v127 = try! AKAudioPlayer(file: guitarSampleAsharp3v127)
        playerGuitarSampleB3v127 = try! AKAudioPlayer(file: guitarSampleB3v127)
        playerGuitarSampleC4v127 = try! AKAudioPlayer(file: guitarSampleC4v127)
        playerGuitarSampleCsharp4v127 = try! AKAudioPlayer(file: guitarSampleCsharp4v127)
        playerGuitarSampleD4v127 = try! AKAudioPlayer(file: guitarSampleD4v127)
        playerGuitarSampleDsharp4v127 = try! AKAudioPlayer(file: guitarSampleDsharp4v127)
        playerGuitarSampleE4v127 = try! AKAudioPlayer(file: guitarSampleE4v127)
        playerGuitarSampleF4v127 = try! AKAudioPlayer(file: guitarSampleF4v127)
        playerGuitarSampleFsharp4v127 = try! AKAudioPlayer(file: guitarSampleFsharp4v127)
        playerGuitarSampleG4v127 = try! AKAudioPlayer(file: guitarSampleG4v127)
        playerGuitarSampleGsharp4v127 = try! AKAudioPlayer(file: guitarSampleGsharp4v127)
        playerGuitarSampleA4v127 = try! AKAudioPlayer(file: guitarSampleA4v127)
        playerGuitarSampleAsharp4v127 = try! AKAudioPlayer(file: guitarSampleAsharp4v127)
        playerGuitarSampleB4v127 = try! AKAudioPlayer(file: guitarSampleB4v127)
        playerGuitarSampleC5v127 = try! AKAudioPlayer(file: guitarSampleC5v127)
        playerGuitarSampleCsharp5v127 = try! AKAudioPlayer(file: guitarSampleCsharp5v127)
        playerGuitarSampleD5v127 = try! AKAudioPlayer(file: guitarSampleD5v127)
        playerGuitarSampleDsharp5v127 = try! AKAudioPlayer(file: guitarSampleDsharp5v127)
        playerGuitarSampleE5v127 = try! AKAudioPlayer(file: guitarSampleE5v127)
        playerGuitarSampleF5v127 = try! AKAudioPlayer(file: guitarSampleF5v127)
        
        // Instruments are split into different mixers just to make the code easier to follow
        let pianoMixer = AKMixer(playerPianoSampleFsharp3v127, playerPianoSampleG3v127, playerPianoSampleGsharp3v127, playerPianoSampleA3v127, playerPianoSampleAsharp3v127, playerPianoSampleB3v127, playerPianoSampleC4v127, playerPianoSampleCsharp4v127, playerPianoSampleD4v127, playerPianoSampleDsharp4v127, playerPianoSampleE4v127, playerPianoSampleF4v127, playerPianoSampleFsharp4v127, playerPianoSampleG4v127, playerPianoSampleGsharp4v127, playerPianoSampleA4v127, playerPianoSampleAsharp4v127, playerPianoSampleB4v127, playerPianoSampleC5v127, playerPianoSampleCsharp5v127, playerPianoSampleD5v127, playerPianoSampleDsharp5v127, playerPianoSampleE5v127, playerPianoSampleF5v127)
        
        let synthMixer = AKMixer(playerSynthSampleFsharp3v127, playerSynthSampleG3v127, playerSynthSampleGsharp3v127, playerSynthSampleA3v127, playerSynthSampleAsharp3v127, playerSynthSampleB3v127, playerSynthSampleC4v127, playerSynthSampleCsharp4v127, playerSynthSampleD4v127, playerSynthSampleDsharp4v127, playerSynthSampleE4v127, playerSynthSampleF4v127, playerSynthSampleFsharp4v127, playerSynthSampleG4v127, playerSynthSampleGsharp4v127, playerSynthSampleA4v127, playerSynthSampleAsharp4v127, playerSynthSampleB4v127, playerSynthSampleC5v127, playerSynthSampleCsharp5v127, playerSynthSampleD5v127, playerSynthSampleDsharp5v127, playerSynthSampleE5v127, playerSynthSampleF5v127)
        
        let stringsMixer = AKMixer(playerStringsSampleFsharp3v127, playerStringsSampleG3v127, playerStringsSampleGsharp3v127, playerStringsSampleA3v127, playerStringsSampleAsharp3v127, playerStringsSampleB3v127, playerStringsSampleC4v127, playerStringsSampleCsharp4v127, playerStringsSampleD4v127, playerStringsSampleDsharp4v127, playerStringsSampleE4v127, playerStringsSampleF4v127, playerStringsSampleFsharp4v127, playerStringsSampleG4v127, playerStringsSampleGsharp4v127, playerStringsSampleA4v127, playerStringsSampleAsharp4v127, playerStringsSampleB4v127, playerStringsSampleC5v127, playerStringsSampleCsharp5v127, playerStringsSampleD5v127, playerStringsSampleDsharp5v127, playerStringsSampleE5v127, playerStringsSampleF5v127)
        
        let guitarMixer = AKMixer(playerGuitarSampleFsharp3v127, playerGuitarSampleG3v127, playerGuitarSampleGsharp3v127, playerGuitarSampleA3v127, playerGuitarSampleAsharp3v127, playerGuitarSampleB3v127, playerGuitarSampleC4v127, playerGuitarSampleCsharp4v127, playerGuitarSampleD4v127, playerGuitarSampleDsharp4v127, playerGuitarSampleE4v127, playerGuitarSampleF4v127, playerGuitarSampleFsharp4v127, playerGuitarSampleG4v127, playerGuitarSampleGsharp4v127, playerGuitarSampleA4v127, playerGuitarSampleAsharp4v127, playerGuitarSampleB4v127, playerGuitarSampleC5v127, playerGuitarSampleCsharp5v127, playerGuitarSampleD5v127, playerGuitarSampleDsharp5v127, playerGuitarSampleE5v127, playerGuitarSampleF5v127)
        
        // Set output
        let outputMixer = AKMixer(pianoMixer, synthMixer, stringsMixer, guitarMixer)
        samplerOutput = outputMixer
    }
    
    // This function updates the root note offset used by choosePlayer().
    // It is called by tranposeStepperChanged() in ViewController.swift when the root note
    // stepper (default 'C') to the right of the screen is pressed.
    open func changeTransposition(newTransposition: Int) {
        transposeAmount = newTransposition
    }
    
    // This function updates the scale type used by choosePlayer()
    // It is called by changeScaleChoice() in ViewController when the stepper just above the BPM slider
    // is changed, to the right of the screen.
    open func changeScaleChoice(newScaleType: Int) {
        scaleChoice = newScaleType
    }
    
    // This function triggers a sample to play, according to choosePlayer().
    // It is called by userNoteOn() in ViewController.swift when the user plays a note on either buttons or keyboard.
    open func playNote(noteOfScale: Int, instrument: Int, userInputIsButtons: Bool) {
        let chosenPlayer = choosePlayer(noteOfScale: noteOfScale, instrument: instrument, userInputIsButtons: userInputIsButtons)
        chosenPlayer.play()
    }
    
    // This function stops a sample playing that was previous triggered to play.
    // It is called by userNoteOff() and userNoteOffOutsideButton() in ViewController.swift when
    // the user stops playing a note on either buttons or keyboard.
    open func stopNote(noteOfScale: Int, instrument: Int, userInputIsButtons: Bool) {
        let chosenPlayer = choosePlayer(noteOfScale: noteOfScale, instrument: instrument, userInputIsButtons: userInputIsButtons)
        chosenPlayer.stop()
    }
    
    // This function calculates which sample should be selected when the user plays/stops playing a note.
    // It is called internally by playNote() and stopNote().
    func choosePlayer(noteOfScale: Int, instrument: Int, userInputIsButtons: Bool) -> AKAudioPlayer{
        
        var noteChosen = noteOfScale
        let instrumentChosen = instrument
        
        // Calculate note to play
        if userInputIsButtons {
            switch scaleChoice {
            case 0: // Major Scale
                switch noteOfScale {
                case 1: noteChosen = 0
                case 2: noteChosen = 2
                case 3: noteChosen = 4
                case 4: noteChosen = 5
                case 5: noteChosen = 7
                case 6: noteChosen = 9
                case 7: noteChosen = 11
                case 8: noteChosen = 12
                default:
                    noteChosen = 0
                    print("User note does not exist - default root note used")
                }
            case 1: // Natural minor scale
                switch noteOfScale {
                case 1: noteChosen = 0
                case 2: noteChosen = 2
                case 3: noteChosen = 3
                case 4: noteChosen = 5
                case 5: noteChosen = 7
                case 6: noteChosen = 8
                case 7: noteChosen = 10
                case 8: noteChosen = 12
                default:
                    noteChosen = 0
                    print("User note does not exist - default root note used")
                }
            default: // Major scale as default
                switch noteOfScale {
                case 1: noteChosen = 0
                case 2: noteChosen = 2
                case 3: noteChosen = 4
                case 4: noteChosen = 5
                case 5: noteChosen = 7
                case 6: noteChosen = 9
                case 7: noteChosen = 11
                case 8: noteChosen = 12
                default:
                    noteChosen = 0
                    print("Something has gone very wrong with the note choice")
                }
            }
            noteChosen += transposeAmount + 60 // At 60, raw note is played (C4)
        }
        else { // User input is keyboard
            noteChosen = noteOfScale + 60
        }
        
        // Get note in player
        var chosenPlayer: AKAudioPlayer
        switch instrumentChosen {
        case 0: // Piano
            switch noteChosen {
            case 54: chosenPlayer = playerPianoSampleFsharp3v127
            case 55: chosenPlayer = playerPianoSampleG3v127
            case 56: chosenPlayer = playerPianoSampleGsharp3v127
            case 57: chosenPlayer = playerPianoSampleA3v127
            case 58: chosenPlayer = playerPianoSampleAsharp3v127
            case 59: chosenPlayer = playerPianoSampleB3v127
            case 60: chosenPlayer = playerPianoSampleC4v127
            case 61: chosenPlayer = playerPianoSampleCsharp4v127
            case 62: chosenPlayer = playerPianoSampleD4v127
            case 63: chosenPlayer = playerPianoSampleDsharp4v127
            case 64: chosenPlayer = playerPianoSampleE4v127
            case 65: chosenPlayer = playerPianoSampleF4v127
            case 66: chosenPlayer = playerPianoSampleFsharp4v127
            case 67: chosenPlayer = playerPianoSampleG4v127
            case 68: chosenPlayer = playerPianoSampleGsharp4v127
            case 69: chosenPlayer = playerPianoSampleA4v127
            case 70: chosenPlayer = playerPianoSampleAsharp4v127
            case 71: chosenPlayer = playerPianoSampleB4v127
            case 72: chosenPlayer = playerPianoSampleC5v127
            case 73: chosenPlayer = playerPianoSampleCsharp5v127
            case 74: chosenPlayer = playerPianoSampleD5v127
            case 75: chosenPlayer = playerPianoSampleDsharp5v127
            case 76: chosenPlayer = playerPianoSampleE5v127
            case 77: chosenPlayer = playerPianoSampleF5v127
                
            default: chosenPlayer = playerPianoSampleC4v127
                print("Default player C4 v127 chosen (piano)")
            }
        case 1: // Synth
            switch noteChosen {
            case 54: chosenPlayer = playerSynthSampleFsharp3v127
            case 55: chosenPlayer = playerSynthSampleG3v127
            case 56: chosenPlayer = playerSynthSampleGsharp3v127
            case 57: chosenPlayer = playerSynthSampleA3v127
            case 58: chosenPlayer = playerSynthSampleAsharp3v127
            case 59: chosenPlayer = playerSynthSampleB3v127
            case 60: chosenPlayer = playerSynthSampleC4v127
            case 61: chosenPlayer = playerSynthSampleCsharp4v127
            case 62: chosenPlayer = playerSynthSampleD4v127
            case 63: chosenPlayer = playerSynthSampleDsharp4v127
            case 64: chosenPlayer = playerSynthSampleE4v127
            case 65: chosenPlayer = playerSynthSampleF4v127
            case 66: chosenPlayer = playerSynthSampleFsharp4v127
            case 67: chosenPlayer = playerSynthSampleG4v127
            case 68: chosenPlayer = playerSynthSampleGsharp4v127
            case 69: chosenPlayer = playerSynthSampleA4v127
            case 70: chosenPlayer = playerSynthSampleAsharp4v127
            case 71: chosenPlayer = playerSynthSampleB4v127
            case 72: chosenPlayer = playerSynthSampleC5v127
            case 73: chosenPlayer = playerSynthSampleCsharp5v127
            case 74: chosenPlayer = playerSynthSampleD5v127
            case 75: chosenPlayer = playerSynthSampleDsharp5v127
            case 76: chosenPlayer = playerSynthSampleE5v127
            case 77: chosenPlayer = playerSynthSampleF5v127
                
            default: chosenPlayer = playerSynthSampleC4v127
                print("Default player C4 v127 chosen (synth)")
            }
        case 2: // Strings
            switch noteChosen {
            case 54: chosenPlayer = playerStringsSampleFsharp3v127
            case 55: chosenPlayer = playerStringsSampleG3v127
            case 56: chosenPlayer = playerStringsSampleGsharp3v127
            case 57: chosenPlayer = playerStringsSampleA3v127
            case 58: chosenPlayer = playerStringsSampleAsharp3v127
            case 59: chosenPlayer = playerStringsSampleB3v127
            case 60: chosenPlayer = playerStringsSampleC4v127
            case 61: chosenPlayer = playerStringsSampleCsharp4v127
            case 62: chosenPlayer = playerStringsSampleD4v127
            case 63: chosenPlayer = playerStringsSampleDsharp4v127
            case 64: chosenPlayer = playerStringsSampleE4v127
            case 65: chosenPlayer = playerStringsSampleF4v127
            case 66: chosenPlayer = playerStringsSampleFsharp4v127
            case 67: chosenPlayer = playerStringsSampleG4v127
            case 68: chosenPlayer = playerStringsSampleGsharp4v127
            case 69: chosenPlayer = playerStringsSampleA4v127
            case 70: chosenPlayer = playerStringsSampleAsharp4v127
            case 71: chosenPlayer = playerStringsSampleB4v127
            case 72: chosenPlayer = playerStringsSampleC5v127
            case 73: chosenPlayer = playerStringsSampleCsharp5v127
            case 74: chosenPlayer = playerStringsSampleD5v127
            case 75: chosenPlayer = playerStringsSampleDsharp5v127
            case 76: chosenPlayer = playerStringsSampleE5v127
            case 77: chosenPlayer = playerStringsSampleF5v127
                
            default: chosenPlayer = playerStringsSampleC4v127
                print("Default player C4 v127 chosen (strings)")
            }
        case 3: // Guitar
            switch noteChosen {
            case 54: chosenPlayer = playerGuitarSampleFsharp3v127
            case 55: chosenPlayer = playerGuitarSampleG3v127
            case 56: chosenPlayer = playerGuitarSampleGsharp3v127
            case 57: chosenPlayer = playerGuitarSampleA3v127
            case 58: chosenPlayer = playerGuitarSampleAsharp3v127
            case 59: chosenPlayer = playerGuitarSampleB3v127
            case 60: chosenPlayer = playerGuitarSampleC4v127
            case 61: chosenPlayer = playerGuitarSampleCsharp4v127
            case 62: chosenPlayer = playerGuitarSampleD4v127
            case 63: chosenPlayer = playerGuitarSampleDsharp4v127
            case 64: chosenPlayer = playerGuitarSampleE4v127
            case 65: chosenPlayer = playerGuitarSampleF4v127
            case 66: chosenPlayer = playerGuitarSampleFsharp4v127
            case 67: chosenPlayer = playerGuitarSampleG4v127
            case 68: chosenPlayer = playerGuitarSampleGsharp4v127
            case 69: chosenPlayer = playerGuitarSampleA4v127
            case 70: chosenPlayer = playerGuitarSampleAsharp4v127
            case 71: chosenPlayer = playerGuitarSampleB4v127
            case 72: chosenPlayer = playerGuitarSampleC5v127
            case 73: chosenPlayer = playerGuitarSampleCsharp5v127
            case 74: chosenPlayer = playerGuitarSampleD5v127
            case 75: chosenPlayer = playerGuitarSampleDsharp5v127
            case 76: chosenPlayer = playerGuitarSampleE5v127
            case 77: chosenPlayer = playerGuitarSampleF5v127
                
            default: chosenPlayer = playerGuitarSampleC4v127
                print("Default player C4 v127 chosen (guitar)")
            }
        default: chosenPlayer = playerPianoSampleC4v127
            print("Something has gone VERY wrong with the player choice")
        }
        
        return chosenPlayer
    }
}
