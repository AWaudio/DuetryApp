/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                            SequencerInstrument
 This file is where all code related the backing track is.

                    Internally-called Functions
 init()
 changeChord()
 
                    Externally-called Functions
 sequencerStartStop()
 changeChord()
 changeScaleChoice()
 changeChordNoteDistribution()
 changeSequencerTempo()
 changeTransposition()
 changeInstrument()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

import AudioKit

open class SequencerInstrument {
    
    var pianoSequencer: AKAppleSequencer
    var synthSequencer: AKAppleSequencer
    var stringsSequencer: AKAppleSequencer
    var guitarSequencer: AKAppleSequencer
    
    let pianoTrack: AKMusicTrack!
    let synthTrack: AKMusicTrack!
    let stringsTrack: AKMusicTrack!
    let guitarTrack: AKMusicTrack!
    
    let pianoMixer: AKMixer!
    let synthMixer: AKMixer!
    let stringsMixer: AKMixer!
    let guitarMixer: AKMixer!
    
    var sequencerOutput: AKNode!
    
    var scaleChoice: Int
    var transposeAmount: Int
    
    var currentChord1 = 0 // These are updated when
    var currentChord2 = 0 // changeChord() is called
    var currentChord3 = 0
    var currentChord4 = 0
    var currentInstrument = 0
    var currentChordNoteDistribution = 0
    
    // Set up chord arrays
    // MIDI notes are for octave 0, correct octave given later when chord is added to sequence
    let chordArrayMajor = [ // Major scale
        [0, 4, 7],      // I
        [2, 5, 9],      // II
        [4, 7, 11],     // III
        [5, 9, 12],     // IV
        [7, 11, 14],    // V
        [9, 12, 16],    // VI
        [11, 14, 17]    // VII
    ]
    
    let chordArrayNatMinor = [ // Nat Minor scale
        [0, 3, 7],      // I
        [2, 5, 9],      // II
        [3, 7, 10],     // III
        [5, 8, 12],     // IV
        [7, 10, 14],    // V
        [8, 12, 15],    // VI
        [10, 14, 17]    // VII
    ]
    
// ~~~~~~~~~~~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~
    
    init() {
        // Set up variables & constants
        let pianoSampler = AKMIDISampler(midiOutputName: nil)
        let synthSampler = AKMIDISampler(midiOutputName: nil)
        let stringsSampler = AKMIDISampler(midiOutputName: nil)
        let guitarSampler = AKMIDISampler(midiOutputName: nil)
        
        scaleChoice = 0
        transposeAmount = 0
        
        pianoSequencer = AKAppleSequencer()
        synthSequencer = AKAppleSequencer()
        stringsSequencer = AKAppleSequencer()
        guitarSequencer = AKAppleSequencer()
        
        pianoTrack = pianoSequencer.newTrack()
        synthTrack = synthSequencer.newTrack()
        stringsTrack = stringsSequencer.newTrack()
        guitarTrack = guitarSequencer.newTrack()
        
        pianoMixer = AKMixer(pianoSampler) // Mixers used for volume control, so that only 1 sampler is audible at a time
        pianoMixer.volume = 1.0
        synthMixer = AKMixer(synthSampler)
        synthMixer.volume = 0.0
        stringsMixer = AKMixer(stringsSampler)
        stringsMixer.volume = 0.0
        guitarMixer = AKMixer(guitarSampler)
        guitarMixer.volume = 0.0
        
        // Load samples
        try? pianoSampler.loadWav("PianoNoteBacking")
        try? synthSampler.loadWav("SynthNoteBacking")
        try? stringsSampler.loadWav("StringsNoteBacking")
        try? guitarSampler.loadWav("GuitarNoteBacking")
        
        // Initialise backing chords
        changeChord(chordPosition: 0, chordChoice: 1)
        changeChord(chordPosition: 1, chordChoice: 5)
        changeChord(chordPosition: 2, chordChoice: 4)
        changeChord(chordPosition: 3, chordChoice: 5)
        
        // Set up sequencers
        pianoSequencer.enableLooping(AKDuration(beats: 4.0))
        pianoSequencer.setTempo(120.0/4.0) // 1/4 speed tempo is used instead of 4 beats per chord because sequencer won't loop with that many beats (good job, Apple)
        pianoSequencer.setGlobalMIDIOutput(pianoSampler.midiIn)
        
        synthSequencer.enableLooping(AKDuration(beats: 4.0))
        synthSequencer.setTempo(120.0/4.0)
        synthSequencer.setGlobalMIDIOutput(synthSampler.midiIn)
        
        stringsSequencer.enableLooping(AKDuration(beats: 4.0))
        stringsSequencer.setTempo(120.0/4.0)
        stringsSequencer.setGlobalMIDIOutput(stringsSampler.midiIn)
        
        guitarSequencer.enableLooping(AKDuration(beats: 4.0))
        guitarSequencer.setTempo(120.0/4.0)
        guitarSequencer.setGlobalMIDIOutput(guitarSampler.midiIn)
        
        // Set output
        let outputMixer = AKMixer(synthMixer, pianoMixer, stringsMixer, guitarMixer)
        sequencerOutput = outputMixer
    }
    
    // This function causes the backing track to start and stop.
    // It is called by sequencerPlayStopPressed() in ViewController when the Play/Stop button
    // to the right of the screen is pressed.
    open func sequencerStartStop() -> Bool {
        if pianoSequencer.isPlaying { // Doesn't matter which sequencer since they always start/stop/etc together
            pianoSequencer.stop()
            synthSequencer.stop()
            stringsSequencer.stop()
            guitarSequencer.stop()
        }
        else {
            pianoSequencer.rewind()
            synthSequencer.rewind()
            stringsSequencer.rewind()
            guitarSequencer.rewind()
            
            pianoSequencer.play()
            synthSequencer.play()
            stringsSequencer.play()
            guitarSequencer.play()
        }
        
        return pianoSequencer.isPlaying // Returns this for updating visuals
    }
    
    // This function updates the MIDI notes in the sequencer by wiping a bar at a time, then writing in new notes.
    // It is called both internally by changeScaleChoice(), changeChordNoteDistribution() and changeTransposition(),
    // and by chordProgPresetLoaded() and a pickerView() function in ViewController.swift.
    open func changeChord(chordPosition: Int, chordChoice: Int) {
        // Update record of current chords (for transposition)
        switch chordPosition {
        case 0:
            currentChord1 = chordChoice
        case 1:
            currentChord2 = chordChoice
        case 2:
            currentChord3 = chordChoice
        case 3:
            currentChord4 = chordChoice
        default:
            currentChord1 = chordChoice
            print("Chord position does not exist - default Chord 1 updated")
        }
        
        // Get MIDI notes of chosen chord
        let chordArrayIndex = chordChoice - 1
        
        let octaveMIDIOffset = 60 // Raw note is at C2
        
        let note1: MIDINoteNumber! // Declare here rather than inside
        let note2: MIDINoteNumber! // switch statement so it is in
        let note3: MIDINoteNumber! // scope of the track.add() code
        
        switch scaleChoice {
        case 0:
            note1 = MIDINoteNumber(chordArrayMajor[chordArrayIndex][0] + octaveMIDIOffset + transposeAmount)
            note2 = MIDINoteNumber(chordArrayMajor[chordArrayIndex][1] + octaveMIDIOffset + transposeAmount)
            note3 = MIDINoteNumber(chordArrayMajor[chordArrayIndex][2] + octaveMIDIOffset + transposeAmount)
        case 1:
            note1 = MIDINoteNumber(chordArrayNatMinor[chordArrayIndex][0] + octaveMIDIOffset + transposeAmount)
            note2 = MIDINoteNumber(chordArrayNatMinor[chordArrayIndex][1] + octaveMIDIOffset + transposeAmount)
            note3 = MIDINoteNumber(chordArrayNatMinor[chordArrayIndex][2] + octaveMIDIOffset + transposeAmount)
        default:
            note1 = MIDINoteNumber(chordArrayMajor[0][0] + octaveMIDIOffset + transposeAmount)
            note2 = MIDINoteNumber(chordArrayMajor[0][1] + octaveMIDIOffset + transposeAmount)
            note3 = MIDINoteNumber(chordArrayMajor[0][2] + octaveMIDIOffset + transposeAmount)
            print("Scale does not exist - default Major I used")
        
        }
        
        // Remove current chord and add new chord
        pianoTrack.clearRange(start: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
        synthTrack.clearRange(start: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
        stringsTrack.clearRange(start: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
        guitarTrack.clearRange(start: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
        
        switch currentChordNoteDistribution {
        case 0: // Held
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            pianoTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            pianoTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            synthTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            synthTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            stringsTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            stringsTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            guitarTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            guitarTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            
        case 1: // Rolled
            pianoTrack?.add(noteNumber: note1, velocity: 100, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.99)) // Sequencer messes up when notes last the full duration
            pianoTrack?.add(noteNumber: note2, velocity: 110, position: AKDuration(beats: Double(chordPosition)+0.03), duration: AKDuration(beats: 0.94))
            pianoTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.06)), duration: AKDuration(beats: 0.91))
         
            synthTrack?.add(noteNumber: note1, velocity: 100, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.99))
            synthTrack?.add(noteNumber: note2, velocity: 110, position: AKDuration(beats: Double(chordPosition)+0.03), duration: AKDuration(beats: 0.94))
            synthTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.06)), duration: AKDuration(beats: 0.91))
         
            stringsTrack?.add(noteNumber: note1, velocity: 100, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.99))
            stringsTrack?.add(noteNumber: note2, velocity: 110, position: AKDuration(beats: Double(chordPosition)+0.03), duration: AKDuration(beats: 0.94))
            stringsTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.06)), duration: AKDuration(beats: 0.91))
            
            guitarTrack?.add(noteNumber: note1, velocity: 100, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.99))
            guitarTrack?.add(noteNumber: note2, velocity: 110, position: AKDuration(beats: Double(chordPosition)+0.03), duration: AKDuration(beats: 0.94))
            guitarTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.06)), duration: AKDuration(beats: 0.91))
            
        case 2: // Broken
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            pianoTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.25), duration: AKDuration(beats: 0.25))
            pianoTrack?.add(noteNumber: note3, velocity: 110, position: AKDuration(beats: Double(chordPosition+0.5)), duration: AKDuration(beats: 0.25))
            pianoTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.75)), duration: AKDuration(beats: 0.25))
            
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            synthTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.25), duration: AKDuration(beats: 0.25))
            synthTrack?.add(noteNumber: note3, velocity: 110, position: AKDuration(beats: Double(chordPosition+0.5)), duration: AKDuration(beats: 0.25))
            synthTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.75)), duration: AKDuration(beats: 0.25))
            
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            stringsTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.25), duration: AKDuration(beats: 0.25))
            stringsTrack?.add(noteNumber: note3, velocity: 110, position: AKDuration(beats: Double(chordPosition+0.5)), duration: AKDuration(beats: 0.25))
            stringsTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.75)), duration: AKDuration(beats: 0.25))
            
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            guitarTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.25), duration: AKDuration(beats: 0.25))
            guitarTrack?.add(noteNumber: note3, velocity: 110, position: AKDuration(beats: Double(chordPosition+0.5)), duration: AKDuration(beats: 0.25))
            guitarTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.75)), duration: AKDuration(beats: 0.25))
            
        case 3: // Arpeggiated
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            pianoTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.125), duration: AKDuration(beats: 0.125))
            pianoTrack?.add(noteNumber: note3, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.25)), duration: AKDuration(beats: 0.125))
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.375)), duration: AKDuration(beats: 0.375))
            pianoTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.5)), duration: AKDuration(beats: 0.125))
            pianoTrack?.add(noteNumber: note3, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.625), duration: AKDuration(beats: 0.125))
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.75)), duration: AKDuration(beats: 0.25))
            pianoTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.875)), duration: AKDuration(beats: 0.125))
            
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            synthTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.125), duration: AKDuration(beats: 0.125))
            synthTrack?.add(noteNumber: note3, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.25)), duration: AKDuration(beats: 0.125))
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.375)), duration: AKDuration(beats: 0.375))
            synthTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.5)), duration: AKDuration(beats: 0.125))
            synthTrack?.add(noteNumber: note3, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.625), duration: AKDuration(beats: 0.125))
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.75)), duration: AKDuration(beats: 0.25))
            synthTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.875)), duration: AKDuration(beats: 0.125))
            
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            stringsTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.125), duration: AKDuration(beats: 0.125))
            stringsTrack?.add(noteNumber: note3, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.25)), duration: AKDuration(beats: 0.125))
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.375)), duration: AKDuration(beats: 0.375))
            stringsTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.5)), duration: AKDuration(beats: 0.125))
            stringsTrack?.add(noteNumber: note3, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.625), duration: AKDuration(beats: 0.125))
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.75)), duration: AKDuration(beats: 0.25))
            stringsTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.875)), duration: AKDuration(beats: 0.125))
            
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            guitarTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.125), duration: AKDuration(beats: 0.125))
            guitarTrack?.add(noteNumber: note3, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.25)), duration: AKDuration(beats: 0.125))
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.375)), duration: AKDuration(beats: 0.375))
            guitarTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.5)), duration: AKDuration(beats: 0.125))
            guitarTrack?.add(noteNumber: note3, velocity: 100, position: AKDuration(beats: Double(chordPosition)+0.625), duration: AKDuration(beats: 0.125))
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition+0.75)), duration: AKDuration(beats: 0.25))
            guitarTrack?.add(noteNumber: note2, velocity: 100, position: AKDuration(beats: Double(chordPosition+0.875)), duration: AKDuration(beats: 0.125))
            
        case 4: // Repeated
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            pianoTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            pianoTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            pianoTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            pianoTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            pianoTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            pianoTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            synthTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            synthTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            synthTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            synthTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            synthTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            synthTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            stringsTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            stringsTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            stringsTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            stringsTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            stringsTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            stringsTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            guitarTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            guitarTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 0.375))
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            guitarTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            guitarTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.375), duration: AKDuration(beats: 0.375))
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            guitarTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            guitarTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)+0.75), duration: AKDuration(beats: 0.25))
            
        default:
            pianoTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            pianoTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            pianoTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            
            synthTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            synthTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            synthTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            
            stringsTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            stringsTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            stringsTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            
            guitarTrack?.add(noteNumber: note1, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            guitarTrack?.add(noteNumber: note2, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
            guitarTrack?.add(noteNumber: note3, velocity: 127, position: AKDuration(beats: Double(chordPosition)), duration: AKDuration(beats: 1))
        
            print("Chord note distribution does not exist - choice 0 used as default")
        }
        
    }
    
    // This function changes the type of scale that the backing track is set to.
    // It is called by changeScaleChoice() in ViewController.swift when the stepper just above
    // the BPM slider is changed, to the right of the screen.
    open func changeScaleChoice(newScaleType: Int) {
        scaleChoice = newScaleType
        
        // Re-make chords with new scale
        changeChord(chordPosition: 0, chordChoice: currentChord1)
        changeChord(chordPosition: 1, chordChoice: currentChord2)
        changeChord(chordPosition: 2, chordChoice: currentChord3)
        changeChord(chordPosition: 3, chordChoice: currentChord4)
    }
    
    // This function changes the way the backing track plays chords.
    // It is called by chordNoteDistributionChanged() in ViewController.swift when the stepper in
    // the middle of the screen, underneath the chord pickerview, is pressed.
    open func changeChordNoteDistribution(newDistribution: Int) {
        currentChordNoteDistribution = newDistribution
        
        // Re-make chords with new distribution
        changeChord(chordPosition: 0, chordChoice: currentChord1)
        changeChord(chordPosition: 1, chordChoice: currentChord2)
        changeChord(chordPosition: 2, chordChoice: currentChord3)
        changeChord(chordPosition: 3, chordChoice: currentChord4)
    }
    
    // This function changes the tempo of the backing track.
    // It is called by tempoSliderChanged() in ViewController.swift when the BPM slider
    // to the right of the screen is moved.
    open func changeSequencerTempo(newTempo: Double) {
        pianoSequencer.setTempo(newTempo/4.0) // For explanation of /4.0 division, see init()
        synthSequencer.setTempo(newTempo/4.0)
        stringsSequencer.setTempo(newTempo/4.0)
        guitarSequencer.setTempo(newTempo/4.0)
    }
    
    // This function changes the root note offset of the backing track.
    // It is called by tranposeStepperChanged() in ViewController.swift when the root note
    // stepper (default 'C') to the right of the screen is pressed.
    open func changeTransposition(newTransposition: Int) {
        transposeAmount = newTransposition
        
        // Re-make chords with new transposition
        changeChord(chordPosition: 0, chordChoice: currentChord1)
        changeChord(chordPosition: 1, chordChoice: currentChord2)
        changeChord(chordPosition: 2, chordChoice: currentChord3)
        changeChord(chordPosition: 3, chordChoice: currentChord4)
    }
    
    // This function changes which instrument track is audible for the backing track.
    // It is called by instrumentChanged() in ViewController.swift when the stepper to
    // the bottom right of the screen is pressed.
    open func changeInstrument(newInstrument: Int) {
        switch newInstrument {
        case 0: // Piano
            pianoMixer.volume = 1.0
            synthMixer.volume = 0.0
            stringsMixer.volume = 0.0
            guitarMixer.volume = 0.0
        case 1: // Synth
            pianoMixer.volume = 0.0
            synthMixer.volume = 1.0
            stringsMixer.volume = 0.0
            guitarMixer.volume = 0.0
        case 2: // Strings
            pianoMixer.volume = 0.0
            synthMixer.volume = 0.0
            stringsMixer.volume = 1.0
            guitarMixer.volume = 0.0
        case 3: // Guitar
            pianoMixer.volume = 0.0
            synthMixer.volume = 0.0
            stringsMixer.volume = 0.0
            guitarMixer.volume = 1.0
        default:
            pianoMixer.volume = 1.0
            synthMixer.volume = 0.0
            stringsMixer.volume = 0.0
            guitarMixer.volume = 0.0
            print("Sampler instrument does not exist - piano used as default")
        }
    }
}
