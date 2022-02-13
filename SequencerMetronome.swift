/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                            SequencerMetronome
 This file is where all code related to the metronome click track is.

                        Internally-called Functions
 init()
 callbackOnBeat()
 
                        Externally-called Functions
 metronomeStartStop()
 changeMetronomeTempo()
                        
                        NOTE ABOUT THIS METRONOME:
 For some reason, when it is toggled on/off (via the metronome button) while the sequencer
 is running, the metronome fades in when turned on, and plays an extra beat before turning off.
 This is likely due to a lower level problem with the sequencer node, rather than an issue with
 this code - validated by the module co-ordinator.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

import AudioKit

open class SequencerMetronome {
    
    let viewController: ViewController!
    
    var metronome: AKAppleSequencer!
    var callbackInstrument: AKMIDICallbackInstrument!
    
    let clickTrack: AKMusicTrack!
    let callbackTrack: AKMusicTrack!
    
    var metronomeOutput: AKNode!
    var callbackOutput: AKNode!
    
    var numCallbacks = 0
    var numBar = 0
    
// ~~~~~~~~~~~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~
    
    init(a: ViewController) { // Passes a reference to the ViewController for the callback function
        // Set up variables & constants
        viewController = a
        
        let sampler = AKMIDISampler(midiOutputName: nil)
        
        metronome = AKAppleSequencer()
        clickTrack = metronome.newTrack()
        
        callbackInstrument = AKMIDICallbackInstrument(midiInputName: "metronomeCallback")
        callbackTrack = metronome.newTrack()
        callbackInstrument.callback = callbackOnBeat
        
        // Load sample
        try? sampler.loadWav("MetronomeClick")
        
        // Create MIDI click track
        clickTrack?.add(noteNumber: 67, velocity: 127, position: AKDuration(beats: 0), duration: AKDuration(beats: 0.25))
        clickTrack?.add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0.25), duration: AKDuration(beats: 0.25))
        clickTrack?.add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0.5), duration: AKDuration(beats: 0.25))
        clickTrack?.add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0.75), duration: AKDuration(beats: 0.25))
        
        // Create callbacks
        callbackTrack?.add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0), duration: AKDuration(beats: 0.25))
        callbackTrack?.add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0.25), duration: AKDuration(beats: 0.25))
        callbackTrack?.add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0.5), duration: AKDuration(beats: 0.25))
        callbackTrack?.add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0.75), duration: AKDuration(beats: 0.25))
        
        // Set up sequencer                                 // For explanation of 1 beat duration
        metronome.enableLooping(AKDuration(beats: 1.0))     // instead of 4, and explanation of /4.0
        metronome.setTempo(120.0/4.0)                       // division, see init() of SequencerInstrument
        
        // Set MIDI & audio outputs
        clickTrack.setMIDIOutput(sampler.midiIn) // For audio
        callbackTrack.setMIDIOutput(callbackInstrument.midiIn) // To trigger callbacks
        
        metronomeOutput = sampler
    }
    
    // This function calls callbackFromMetronome() in ViewController.swift, causing a chord
    // to be highlighted depending on the bar number.
    // It is called by callbackInstrument every time a MIDI note is played in the callbackTrack (which is every beat).
    func callbackOnBeat(a: UInt8, b: MIDINoteNumber, c: MIDIVelocity) -> () {
        if (a == 144) {  // if noteOn
            numCallbacks += 1
            
            if numCallbacks % 4 == 0 { // if 1st beat of each bar
                numBar += 1
                
                viewController.callbackFromMetronome(currentBar: Int(numBar % 4))
            }
        }
         
    }
    
    // This function causes the metronome sequencer to run/stop - although the click is only audible
    // when metronomeToggled() in ViewController.swift is called to unmute it.
    // It is called by sequencerPlayStopPressed() in ViewController.swift when the Play/Stop button
    // to the right of the screen is pressed.
    open func metronomeStartStop() {
        if metronome.isPlaying {
            metronome.stop()
        }
        else {
            numCallbacks = -1 // So that the 1st beat will be 0
            numBar = -1 // So that the 1st bar will be 0
            
            metronome.rewind()
            metronome.play()
        }
    }
    
    // This function changes the tempo of the metronome click track, to stay in time with the backing track.
    // It is called by tempoSliderChanged() in ViewController.swift when the BPM slider to the right of the screen is moved.
    open func changeMetronomeTempo(newTempo: Double) {
        metronome.setTempo(newTempo/4.0) // For explanation of /4.0 division, see init() of SequencerInstrument
    }
}
