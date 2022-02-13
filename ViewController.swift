
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ OVERVIEW OF APP - MVC MODEL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//             |                                                                                          //
// Models      |   SequencerInstrument     SequencerMetronome      UserSamplerInstrument       FXEngine   //
//             |            ^                      ^_______          _______^                     ^       //
//             |            |                              v        v                             |       //
// Controller  |            -------------------------->  ViewController  <-------------------------       //
//             |                                               ^v                                         //
// View        |                                        Main (Storyboard)                                 //
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//


/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                            VIEWCONTROLLER
 This file is where all code related to user input and visuals onscreen is.

                    Internally-called Functions
 viewDidLoad()
 changeTheme()
 1 of the pickerview() functions
 
                        User Input Functions
 sequencerPlayStopPressed()
 tempoSliderChanged()
 tranposeStepperChanged()
 changeScaleChoice()
 chordProgPresetChanged()
 chordProgPresetLoaded()
 chordNoteDistributionChanged()
 instrumentChanged()
 userNoteOn()
 userNoteOff()
 userNoteOffOutsideButton()
 tutorialsOpenedOrShut()
 tutorialChoiceChanged()
 userInputChanged()
 metronomeToggled()
 settingsOpenedOrShut()
 changeOutputLevel()
 changeBalance()
 changeSpaceAmount()
 changeSpaceSize()
 themeStepperPressed()
 Most of the pickerview() functions
 
                    Externally-called Functions
 callbackFromMetronome()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */



import UIKit
import AudioKit

class ViewController: UIViewController {

    // Outlets
    @IBOutlet var rootNoteLabel: UILabel!
    @IBOutlet var scaleLabel: UILabel!
    @IBOutlet var tempoLabel: UILabel!
    @IBOutlet var chordProgPresetsLabel: UILabel!
    @IBOutlet var spaceLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var balanceBackingLabel: UILabel!
    @IBOutlet var balanceSoloLabel: UILabel!
    @IBOutlet var outputLevelLabel: UILabel!
    @IBOutlet var themeLabel: UILabel!
    @IBOutlet var themeTypeLabel: UILabel!
    
    @IBOutlet var mainBackgroundCool: UIImageView!
    @IBOutlet var mainBackgroundWarm: UIImageView!
    @IBOutlet var mainBackgroundLeafy: UIImageView!
    @IBOutlet var playButtonImage: UIImageView!
    @IBOutlet var stopButtonImage: UIImageView!
    @IBOutlet var tutorialsImage: UIImageView!
    @IBOutlet var settingsImage: UIImageView!
    @IBOutlet var keyboardImage: UIImageView!
    @IBOutlet var buttonsImage: UIImageView!
    @IBOutlet var metronomeImage: UIImageView!
    @IBOutlet var highlightFirstChordImage: UIImageView!
    @IBOutlet var highlightSecondChordImage: UIImageView!
    @IBOutlet var highlightThirdChordImage: UIImageView!
    @IBOutlet var highlightFourthChordImage: UIImageView!
    @IBOutlet var settingsBackgroundImage: UIImageView!
    @IBOutlet var chordBrokenImage: UIImageView!
    @IBOutlet var chordHeldImage: UIImageView!
    @IBOutlet var chordArpeggiatedImage: UIImageView!
    @IBOutlet var chordRolledImage: UIImageView!
    @IBOutlet var chordRepeatedImage: UIImageView!
    @IBOutlet var pianoImage: UIImageView! // Source: https://www.flaticon.com/free-icon/piano-top-view_26304
    @IBOutlet var synthImage: UIImageView! // Source: https://thenounproject.com/term/keytar/55439/
    @IBOutlet var stringsImage: UIImageView! // Source: https://en.wikipedia.org/wiki/File:Violin_icon_for_userboxes.svg
    @IBOutlet var guitarImage: UIImageView! // Source: https://www.freeiconspng.com/images/guitar-icon-png
    @IBOutlet var tutorial1Image: UIImageView!
    @IBOutlet var tutorial2Image: UIImageView!
    @IBOutlet var tutorial3Image: UIImageView!
    @IBOutlet var tutorial4Image: UIImageView!
    @IBOutlet var tutorial5Image: UIImageView!
    @IBOutlet var tutorial6Image: UIImageView!
    @IBOutlet var tutorial7Image: UIImageView!
    @IBOutlet var tutorial8Image: UIImageView!
    @IBOutlet var tutorial9Image: UIImageView!
    @IBOutlet var tutorial10Image: UIImageView!
    @IBOutlet var tutorial11Image: UIImageView!
    @IBOutlet var tutorial12Image: UIImageView!
    @IBOutlet var tutorial13Image: UIImageView!
    @IBOutlet var tutorial14Image: UIImageView!
    @IBOutlet var tutorial15Image: UIImageView!
    @IBOutlet var tutorial16Image: UIImageView!
    @IBOutlet var tutorial17Image: UIImageView!
    
    @IBOutlet var chordProgPresetStepper: UIStepper!
    @IBOutlet var transposeStepper: UIStepper!
    @IBOutlet var scaleTypeStepper: UIStepper!
    @IBOutlet var instrumentStepper: UIStepper!
    @IBOutlet var themeStepper: UIStepper!
    @IBOutlet var tutorialsStepper: UIStepper!
    
    @IBOutlet var tempoSlider: UISlider!
    @IBOutlet var outputLevelSlider: UISlider!
    @IBOutlet var levelBalanceSlider: UISlider!
    @IBOutlet var spaceAmountSlider: UISlider!
    
    @IBOutlet var spaceSizeSegmentedControl: UISegmentedControl!
    
    @IBOutlet var chordChoicePickerView: UIPickerView!
    
    @IBOutlet var settingsVisibleButton: UIButton!
    @IBOutlet var loadChordPresetButton: UIButton!
    @IBOutlet var userButton1: UIButton!
    @IBOutlet var userButton2: UIButton!
    @IBOutlet var userButton3: UIButton!
    @IBOutlet var userButton4: UIButton!
    @IBOutlet var userButton5: UIButton!
    @IBOutlet var userButton6: UIButton!
    @IBOutlet var userButton7: UIButton!
    @IBOutlet var userButton8: UIButton!
    @IBOutlet var userKeyboardKey1: UIButton!
    @IBOutlet var userKeyboardKey2: UIButton!
    @IBOutlet var userKeyboardKey3: UIButton!
    @IBOutlet var userKeyboardKey4: UIButton!
    @IBOutlet var userKeyboardKey5: UIButton!
    @IBOutlet var userKeyboardKey6: UIButton!
    @IBOutlet var userKeyboardKey7: UIButton!
    @IBOutlet var userKeyboardKey8: UIButton!
    @IBOutlet var userKeyboardKey9: UIButton!
    @IBOutlet var userKeyboardKey10: UIButton!
    @IBOutlet var userKeyboardKey11: UIButton!
    @IBOutlet var userKeyboardKey12: UIButton!
    @IBOutlet var userKeyboardKey13: UIButton!
    
    // Varables & constants
    var sequencer: SequencerInstrument!
    var metronome: SequencerMetronome!
    var userSampler: AudioSampler!
    var fx: FXEngine!
    var sequencerMixer: AKMixer!
    var userSamplerMixer: AKMixer!
    var instrumentMixer: AKMixer!
    var metronomeMixer: AKMixer!
    var outputMixer: AKMixer!
    var outputLimiter: AKPeakLimiter!
    
    var currentChord1: Int!
    var currentChord2: Int!
    var currentChord3: Int!
    var currentChord4: Int!
    var currentInstrument: Int!
    var currentScale: Int!
    
    var tutorialsAreVisible: Bool!
    var settingsAreVisible: Bool!
    var metronomeIsOn: Bool!
    var userInputIsButtons: Bool!
    
    var userInput: String!

    // Arrays
    let themeArray = ["Cool", "Warm", "Leafy"]
    
    let rootNoteArray = ["C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"] // Not all indices are used, but transposition can be extended in either direction if wanted due to them being here
    
    let scaleArray = ["Major", "Nat Minor"]
    
    let majorChordProgPresetsArray = [
        "I-V-vi-IV", // Pop 1
        "I-IV-V-IV", // Pop 2
        "I-vi-iii-vii", // Pop 3
        "vi-IV-I-V", // Pop 4
        "I-IV-I-V", // Blues
        "I-VI-IV-V", // 50s
        "I-iii-IV-V", // Ballad
        "I-vii-vi-V", // Spanish
        "ii-V-I-I" // Jazz
    ]
    let minorChordProgPresetsArray = [
        "i-v-VI-iv", // Pop 1
        "i-iv-v-iv", // Pop 2
        "i-VI-III-VII", // Pop 3
        "VI-iv-i-v", // Pop 4
        "i-iv-i-v", // Blues
        "i-VI-iv-v", // 50s
        "i-III-iv-v", // Ballad
        "i-VII-VI-v", // Spanish
        "ii-v-i-i" // Jazz
    ]
    
    let chordNumChoicesForPickerview = [1, 2, 3, 4, 5, 6, 7]
    
    let majorRomanNumeralArray = ["I", "ii", "iii", "IV", "V", "vi", "vii"]
    let minorRomanNumeralArray = ["i", "ii", "III", "iv", "v", "VI", "VII"]
    
// ~~~~~~~~~~~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up pickerview
        chordChoicePickerView.delegate = self
        chordChoicePickerView.dataSource = self
        
        // Initialise values
        currentChord1 = 1 // Pop 1
        currentChord2 = 5
        currentChord3 = 6
        currentChord4 = 4
        
        currentInstrument = 0

        currentScale = 0
        
        chordChoicePickerView.selectRow(currentChord1-1, inComponent: 0, animated: true)
        chordChoicePickerView.selectRow(currentChord2-1, inComponent: 1, animated: true)
        chordChoicePickerView.selectRow(currentChord3-1, inComponent: 2, animated: true)
        chordChoicePickerView.selectRow(currentChord4-1, inComponent: 3, animated: true)
        
        tutorialsAreVisible = false
        settingsAreVisible = false
        metronomeIsOn = false
        userInputIsButtons = true
        
        userInput = "Buttons"
        
        spaceSizeSegmentedControl.selectedSegmentIndex = 1
        
        tempoSlider.setValue(120.0, animated: false) // On my iPhone the slider does not get initialised to the correct position without this line

        // Initialise visuals
        changeTheme(newTheme: 0)
        
        userButton1.setTitle(majorRomanNumeralArray[0], for: .normal)
        userButton2.setTitle(majorRomanNumeralArray[1], for: .normal)
        userButton3.setTitle(majorRomanNumeralArray[2], for: .normal)
        userButton4.setTitle(majorRomanNumeralArray[3], for: .normal)
        userButton5.setTitle(majorRomanNumeralArray[4], for: .normal)
        userButton6.setTitle(majorRomanNumeralArray[5], for: .normal)
        userButton7.setTitle(majorRomanNumeralArray[6], for: .normal)
        userButton8.setTitle("I", for: .normal) // Array doesn't hold this value because it is used for the pickerview
        
        let userButtonColour = UIColor.darkGray  // Colours are set here because
        userButton1.tintColor = userButtonColour // they otherwise stay as default
        userButton2.tintColor = userButtonColour // blue until triggered
        userButton3.tintColor = userButtonColour
        userButton4.tintColor = userButtonColour
        userButton5.tintColor = userButtonColour
        userButton6.tintColor = userButtonColour
        userButton7.tintColor = userButtonColour
        userButton8.tintColor = userButtonColour
        
        let userKeyboardWhiteKeysColour = UIColor.white
        userKeyboardKey1.tintColor = userKeyboardWhiteKeysColour
        userKeyboardKey3.tintColor = userKeyboardWhiteKeysColour
        userKeyboardKey5.tintColor = userKeyboardWhiteKeysColour
        userKeyboardKey6.tintColor = userKeyboardWhiteKeysColour
        userKeyboardKey8.tintColor = userKeyboardWhiteKeysColour
        userKeyboardKey10.tintColor = userKeyboardWhiteKeysColour
        userKeyboardKey12.tintColor = userKeyboardWhiteKeysColour
        userKeyboardKey13.tintColor = userKeyboardWhiteKeysColour
        
        let userKeyboardBlackKeysColour = UIColor.darkGray
        userKeyboardKey2.tintColor = userKeyboardBlackKeysColour
        userKeyboardKey4.tintColor = userKeyboardBlackKeysColour
        userKeyboardKey7.tintColor = userKeyboardBlackKeysColour
        userKeyboardKey9.tintColor = userKeyboardBlackKeysColour
        userKeyboardKey11.tintColor = userKeyboardBlackKeysColour
        
        chordChoicePickerView.tintColor = UIColor.darkGray
        loadChordPresetButton.tintColor = UIColor.darkGray
        
        chordHeldImage.isHidden = false
        chordRolledImage.isHidden = true
        chordBrokenImage.isHidden = true
        chordArpeggiatedImage.isHidden = true
        chordRepeatedImage.isHidden = true
        
        buttonsImage.isHidden = true
        highlightFirstChordImage.isHidden = true
        highlightSecondChordImage.isHidden = true
        highlightThirdChordImage.isHidden = true
        highlightFourthChordImage.isHidden = true
        mainBackgroundWarm.isHidden = true
        
        userKeyboardKey1.isHidden = true
        userKeyboardKey2.isHidden = true
        userKeyboardKey3.isHidden = true
        userKeyboardKey4.isHidden = true
        userKeyboardKey5.isHidden = true
        userKeyboardKey6.isHidden = true
        userKeyboardKey7.isHidden = true
        userKeyboardKey8.isHidden = true
        userKeyboardKey9.isHidden = true
        userKeyboardKey10.isHidden = true
        userKeyboardKey11.isHidden = true
        userKeyboardKey12.isHidden = true
        userKeyboardKey13.isHidden = true
        
        settingsBackgroundImage.alpha = 0.0
        outputLevelSlider.isHidden = true
        levelBalanceSlider.isHidden = true
        spaceAmountSlider.isHidden = true
        spaceSizeSegmentedControl.isHidden = true
        themeStepper.isHidden = true
        
        outputLevelLabel.isHidden = true
        balanceLabel.isHidden = true
        balanceBackingLabel.isHidden = true
        balanceSoloLabel.isHidden = true
        spaceLabel.isHidden = true
        themeLabel.isHidden = true
        themeTypeLabel.isHidden = true
        
        synthImage.isHidden = true
        stringsImage.isHidden = true
        guitarImage.isHidden = true
        
        tutorialsStepper.isHidden = true
        tutorial1Image.isHidden = true
        tutorial2Image.isHidden = true
        tutorial3Image.isHidden = true
        tutorial4Image.isHidden = true
        tutorial5Image.isHidden = true
        tutorial6Image.isHidden = true
        tutorial7Image.isHidden = true
        tutorial8Image.isHidden = true
        tutorial9Image.isHidden = true
        tutorial10Image.isHidden = true
        tutorial11Image.isHidden = true
        tutorial12Image.isHidden = true
        tutorial13Image.isHidden = true
        tutorial14Image.isHidden = true
        tutorial15Image.isHidden = true
        tutorial16Image.isHidden = true
        tutorial17Image.isHidden = true
        
        // Routings
        sequencer = SequencerInstrument()
        sequencerMixer = AKMixer(sequencer.sequencerOutput) // For volume contol
        sequencerMixer.volume = 0.5
        
        userSampler = AudioSampler()
        userSamplerMixer = AKMixer(userSampler.samplerOutput) // For volume contol
        userSamplerMixer.volume = 0.5
        
        instrumentMixer = AKMixer(sequencerMixer, userSamplerMixer)
        
        fx = FXEngine(input: instrumentMixer)
        
        metronome = SequencerMetronome(a: self)
        metronomeMixer = AKMixer(metronome.metronomeOutput)
        metronomeMixer.volume = 0.0
        
        outputMixer = AKMixer(fx.fxOutput, metronomeMixer)
        outputMixer.volume = 0.8
        
        outputLimiter = AKPeakLimiter(outputMixer)
        
        AKManager.output = outputLimiter
        try!AKManager.start()
        
        outputLimiter.preGain = 6.0 // Boost output to make up for the balance control's lowering of the instruments' volumes
    }
    
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~ MID SCREEN FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
// ~~~~~~~~~~~~~~~~~~~~~~ Sequencer general functions ~~~~~~~~~~~~~~~~~~~~~~
    
    // This function causes a chord to be highlighted depending on the bar number.
    // It is called by callbackOnBeat() in SequencerMetronome.swift on every new bar.
    open func callbackFromMetronome(currentBar: Int) {
        // Highlight current chord
        DispatchQueue.main.async { // This allows UIButton property to be changed from outside ViewController
            switch currentBar {
            case 0:
                self.highlightFirstChordImage.isHidden = false
                self.highlightSecondChordImage.isHidden = true
                self.highlightThirdChordImage.isHidden = true
                self.highlightFourthChordImage.isHidden = true
            case 1:
                self.highlightFirstChordImage.isHidden = true
                self.highlightSecondChordImage.isHidden = false
                self.highlightThirdChordImage.isHidden = true
                self.highlightFourthChordImage.isHidden = true
            case 2:
                self.highlightFirstChordImage.isHidden = true
                self.highlightSecondChordImage.isHidden = true
                self.highlightThirdChordImage.isHidden = false
                self.highlightFourthChordImage.isHidden = true
            case 3:
                self.highlightFirstChordImage.isHidden = true
                self.highlightSecondChordImage.isHidden = true
                self.highlightThirdChordImage.isHidden = true
                self.highlightFourthChordImage.isHidden = false
            default:
                self.highlightFirstChordImage.isHidden = false
                self.highlightSecondChordImage.isHidden = true
                self.highlightThirdChordImage.isHidden = true
                self.highlightFourthChordImage.isHidden = true
                print("Current beat does not exist. First beat used as default")
            }
        }
    }
    
    // This function causes the backing track and metronome click track to start and stop, and updates visuals accordingly.
    // It is called when the Play/Stop button to the right of the screen is pressed.
    @IBAction func sequencerPlayStopPressed(_ sender: UIButton) {
        metronome.metronomeStartStop()
        let seqIsPlaying = sequencer.sequencerStartStop() // Will be used for highlighting current chord
        
        // Update visuals
        if seqIsPlaying {
            playButtonImage.tintColor = UIColor.green
            stopButtonImage.tintColor = UIColor.black
        }
        else {
            playButtonImage.tintColor = UIColor.black
            stopButtonImage.tintColor = UIColor.red
            
            highlightFirstChordImage.isHidden = true
            highlightSecondChordImage.isHidden = true
            highlightThirdChordImage.isHidden = true
            highlightFourthChordImage.isHidden = true
        }
    }
    
    // This function changes the tempo of the backing track and metronome click track, and changes the delay FX time to stay in sync with them.
    // It is called when the BPM slider to the right of the screen is moved.
    @IBAction func tempoSliderChanged(_ sender: UISlider) {
        sequencer.changeSequencerTempo(newTempo: Double(sender.value))
        metronome.changeMetronomeTempo(newTempo: Double(sender.value))
        fx.changeDelayTime(newTempo: Double(sender.value))
        
        tempoLabel.text = "BPM: " + String(Int(sender.value))
    }
    
    // This function causes the backing track and the user instrument buttons to change pitch to a different root note.
    // It is called when the root note stepper (default 'C') to the right of the screen is pressed.
    @IBAction func tranposeStepperChanged(_ sender: UIStepper) {
        sequencer.changeTransposition(newTransposition: Int(sender.value))
        userSampler.changeTransposition(newTransposition: Int(sender.value))
        
        rootNoteLabel.text = rootNoteArray[Int(sender.value) + 11] // 0 transposition = index 11 (C)
    }
    
    // This function changes the type of scale that the backing track and user instrument buttons are set to, and updates visuals
    // so that Major chords are in uppercase and Minor chords are in lowercase.
    // It is called when the stepper just above the BPM slider is changed, to the right of the screen.
    @IBAction func changeScaleChoice(_ sender: UIStepper) {
        currentScale = Int(sender.value)
        
        sequencer.changeScaleChoice(newScaleType: Int(sender.value))
        userSampler.changeScaleChoice(newScaleType: Int(sender.value))
        
        // Update visuals
        scaleLabel.text = scaleArray[Int(sender.value)]
        chordChoicePickerView.dataSource = self
        
        if currentScale == 0 {
            chordProgPresetsLabel.text = majorChordProgPresetsArray[Int(chordProgPresetStepper.value)]
            
            userButton1.setTitle(majorRomanNumeralArray[0], for: .normal)
            userButton2.setTitle(majorRomanNumeralArray[1], for: .normal)
            userButton3.setTitle(majorRomanNumeralArray[2], for: .normal)
            userButton4.setTitle(majorRomanNumeralArray[3], for: .normal)
            userButton5.setTitle(majorRomanNumeralArray[4], for: .normal)
            userButton6.setTitle(majorRomanNumeralArray[5], for: .normal)
            userButton7.setTitle(majorRomanNumeralArray[6], for: .normal)
            userButton8.setTitle("I", for: .normal) // See init() for why I haven't just extended the above array
        }
        else {
            chordProgPresetsLabel.text = minorChordProgPresetsArray[Int(chordProgPresetStepper.value)]
            
            userButton1.setTitle(minorRomanNumeralArray[0], for: .normal)
            userButton2.setTitle(minorRomanNumeralArray[1], for: .normal)
            userButton3.setTitle(minorRomanNumeralArray[2], for: .normal)
            userButton4.setTitle(minorRomanNumeralArray[3], for: .normal)
            userButton5.setTitle(minorRomanNumeralArray[4], for: .normal)
            userButton6.setTitle(minorRomanNumeralArray[5], for: .normal)
            userButton7.setTitle(minorRomanNumeralArray[6], for: .normal)
            userButton8.setTitle("i", for: .normal)
        }
    }
    
// ~~~~~~~~~~~~~~~~~~~~~~ Sequencer chord functions (more in PickerView below) ~~~~~~~~~~~~~~~~~~~~~~
    
    // This function changes which chord progression preset is ready to be loaded for when 'Load' is pressed.
    // It is called when the stepper to the far left of the screen is pressed.
    @IBAction func chordProgPresetChanged(_ sender: UIStepper) {
        // Visual only - preset has not yet been loaded
        if currentScale == 0 {
        chordProgPresetsLabel.text = majorChordProgPresetsArray[Int(chordProgPresetStepper.value)]
        }
        else {
            chordProgPresetsLabel.text = minorChordProgPresetsArray[Int(chordProgPresetStepper.value)]
        }
    }
    
    // This function causes the currently chosen chord progression to be loaded into the backing track, and updates
    // the chords in the pickerview accordingly.
    // It is called when the 'Load' button to the left of the screen is pressed.
    @IBAction func chordProgPresetLoaded(_ sender: UIButton) {
        // Get & set chords
        let firstChord: Int
        let secondChord: Int
        let thirdChord: Int
        let fourthChord: Int
        
        switch chordProgPresetStepper.value {
        case 0: // Pop 1
            firstChord = 1
            secondChord = 5
            thirdChord = 6
            fourthChord = 4
        case 1: // Pop 2
            firstChord = 1
            secondChord = 4
            thirdChord = 5
            fourthChord = 4
        case 2: // Pop 3
            firstChord = 1
            secondChord = 6
            thirdChord = 3
            fourthChord = 7
        case 3: // Pop 4
            firstChord = 6
            secondChord = 4
            thirdChord = 1
            fourthChord = 5
        case 4: // Blues
            firstChord = 1
            secondChord = 4
            thirdChord = 1
            fourthChord = 5
        case 5: // 50s
            firstChord = 1
            secondChord = 6
            thirdChord = 4
            fourthChord = 5
        case 6: // Ballad
            firstChord = 1
            secondChord = 3
            thirdChord = 4
            fourthChord = 5
        case 7: // Spanish
            firstChord = 1
            secondChord = 7
            thirdChord = 6
            fourthChord = 5
        case 8: // Jazz
            firstChord = 2
            secondChord = 5
            thirdChord = 1
            fourthChord = 1
        default:
            firstChord = 1
            secondChord = 5
            thirdChord = 6
            fourthChord = 4
            print("Chord progression does not exist - Pop 1 used as default")
        }
        
        sequencer.changeChord(chordPosition: 0, chordChoice: firstChord)
        sequencer.changeChord(chordPosition: 1, chordChoice: secondChord)
        sequencer.changeChord(chordPosition: 2, chordChoice: thirdChord)
        sequencer.changeChord(chordPosition: 3, chordChoice: fourthChord)
        
        // Update variables and pickerview
        currentChord1 = firstChord
        currentChord2 = secondChord
        currentChord3 = thirdChord
        currentChord4 = fourthChord
        
        chordChoicePickerView.selectRow(currentChord1-1, inComponent: 0, animated: true)
        chordChoicePickerView.selectRow(currentChord2-1, inComponent: 1, animated: true)
        chordChoicePickerView.selectRow(currentChord3-1, inComponent: 2, animated: true)
        chordChoicePickerView.selectRow(currentChord4-1, inComponent: 3, animated: true)
        
        // Update labels
        chordProgPresetsLabel.textColor = UIColor.black
    }
    
    // This function changes the way the backing track plays chords, by rewriting the MIDI notes in the sequencer
    // in SequencerInstrument.swift, and updates the image to its left accordingly.
    // It is called when the stepper in the middle of the screen, underneath the chord pickerview, is pressed.
    @IBAction func chordNoteDistributionChanged(_ sender: UIStepper) {
        sequencer.changeChordNoteDistribution(newDistribution: Int(sender.value))
        
        switch Int(sender.value) {
        case 0: // Held
            chordHeldImage.isHidden = false
            chordRolledImage.isHidden = true
            chordBrokenImage.isHidden = true
            chordArpeggiatedImage.isHidden = true
            chordRepeatedImage.isHidden = true
        case 1: // Rolled
            chordHeldImage.isHidden = true
            chordRolledImage.isHidden = false
            chordBrokenImage.isHidden = true
            chordArpeggiatedImage.isHidden = true
            chordRepeatedImage.isHidden = true
        case 2: // Broken
            chordHeldImage.isHidden = true
            chordRolledImage.isHidden = true
            chordBrokenImage.isHidden = false
            chordArpeggiatedImage.isHidden = true
            chordRepeatedImage.isHidden = true
        case 3: // Arpeggiated
            chordHeldImage.isHidden = true
            chordRolledImage.isHidden = true
            chordBrokenImage.isHidden = true
            chordArpeggiatedImage.isHidden = false
            chordRepeatedImage.isHidden = true
        case 4: // Repeated
            chordHeldImage.isHidden = true
            chordRolledImage.isHidden = true
            chordBrokenImage.isHidden = true
            chordArpeggiatedImage.isHidden = true
            chordRepeatedImage.isHidden = false
        default:
            chordHeldImage.isHidden = false
            chordRolledImage.isHidden = true
            chordBrokenImage.isHidden = true
            chordArpeggiatedImage.isHidden = true
            chordRepeatedImage.isHidden = true
            print("Chord note distribution does not exist - held used as default")
        }
    }
    
    
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~ LOWER SCREEN FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // This function changes the samples used by the user instrument and backing track, and updates the instrument image accordingly.
    // It is called when the stepper to the bottom right of the screen is pressed.
    @IBAction func instrumentChanged(_ sender: UIStepper) {
        currentInstrument = Int(sender.value)
        sequencer.changeInstrument(newInstrument: currentInstrument)
        
        switch currentInstrument {
        case 0: // Piano
            pianoImage.isHidden = false
            synthImage.isHidden = true
            stringsImage.isHidden = true
            guitarImage.isHidden = true
        case 1: // Synth
            pianoImage.isHidden = true
            synthImage.isHidden = false
            stringsImage.isHidden = true
            guitarImage.isHidden = true
        case 2: // Strings
            pianoImage.isHidden = true
            synthImage.isHidden = true
            stringsImage.isHidden = false
            guitarImage.isHidden = true
        case 3: // Guitar
            pianoImage.isHidden = true
            synthImage.isHidden = true
            stringsImage.isHidden = true
            guitarImage.isHidden = false
        default:
            pianoImage.isHidden = false
            synthImage.isHidden = true
            stringsImage.isHidden = true
            guitarImage.isHidden = true
            print("Instrument image does not exist - piano image used as default")
        }
        
    }
    
    // This function triggers a sample in UserSamplerInstrument.swift.
    // It is called when the user plays a note on either buttons or keyboard.
    @IBAction func userNoteOn(_ sender: UIButton) {
        userSampler.playNote(noteOfScale: sender.tag, instrument: currentInstrument, userInputIsButtons: userInputIsButtons)
    }
    
    // This function stops a sample in UserSamplerInstrument.swift from playing.
    // It is called when the user stops pressing a note on either buttons or keyboard, inside the button/key.
    @IBAction func userNoteOff(_ sender: UIButton) {
        userSampler.stopNote(noteOfScale: sender.tag, instrument: currentInstrument, userInputIsButtons: userInputIsButtons)
    }
    
    // This function stops a sample in UserSamplerInstrument.swift playing.
    // It is called when the user stops pressing a note on either buttons or keyboard, outside the button/key.
    @IBAction func userNoteOffOutsideButton(_ sender: UIButton) {
        userSampler.stopNote(noteOfScale: sender.tag, instrument: currentInstrument, userInputIsButtons: userInputIsButtons)
    }
    

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~ ALL SETTINGS FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // This function causes the tutorial overlay images to be turned on or off - if Settings is open, it is
    // closed so that the correct stuff is visible onscreen for the first part of the tutorial.
    // It is called when the 'Info' icon in the top right of the screen is pressed.
    @IBAction func tutorialsOpenedOrShut(_ sender: UIButton) {
        if tutorialsAreVisible {
            tutorialsStepper.isHidden = true
            tutorialsAreVisible = false
            tutorialsImage.tintColor = UIColor.black
            
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        }
        else {
            tutorialsStepper.value = 0.0
            tutorialsStepper.isHidden = false
            tutorialsAreVisible = true
            tutorialsImage.tintColor = UIColor.green
            
            tutorial1Image.isHidden = false
            
            // Hide settings so that the correct stuff is visible onscreen for the tutorials
            settingsBackgroundImage.alpha = 0.0
            outputLevelSlider.isHidden = true
            levelBalanceSlider.isHidden = true
            spaceAmountSlider.isHidden = true
            spaceSizeSegmentedControl.isHidden = true
            themeStepper.isHidden = true
            
            outputLevelLabel.isHidden = true
            balanceLabel.isHidden = true
            balanceBackingLabel.isHidden = true
            balanceSoloLabel.isHidden = true
            spaceLabel.isHidden = true
            themeLabel.isHidden = true
            themeTypeLabel.isHidden = true
            
            settingsAreVisible = false
            settingsImage.tintColor = UIColor.black
        }
    }
    
    // This function changes the currently visible tutorial overlay image, allowing the user to step
    // through the tutorials.
    // It is called when the stepper in the top right of the tutorial overlays is pressed.
    @IBAction func tutorialChoiceChanged(_ sender: UIStepper) {
        switch Int(sender.value) {
        case 0:
            tutorial1Image.isHidden = false
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 1:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = false
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 2:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = false
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 3:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = false
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 4:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = false
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 5:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = false
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 6:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = false
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 7:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = false
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 8:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = false
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 9:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = false
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 10:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = false
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 11:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = false
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
            
            // Hide settings so that moving backwards through the tutorial will not mess up what is visible onscreen
            settingsBackgroundImage.alpha = 0.0
            outputLevelSlider.isHidden = true
            levelBalanceSlider.isHidden = true
            spaceAmountSlider.isHidden = true
            spaceSizeSegmentedControl.isHidden = true
            themeStepper.isHidden = true
            
            outputLevelLabel.isHidden = true
            balanceLabel.isHidden = true
            balanceBackingLabel.isHidden = true
            balanceSoloLabel.isHidden = true
            spaceLabel.isHidden = true
            themeLabel.isHidden = true
            themeTypeLabel.isHidden = true
            
            settingsAreVisible = false
            settingsImage.tintColor = UIColor.black
        case 12:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = false
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 13:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = false
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 14:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = false
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
        case 15:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = false
            tutorial17Image.isHidden = true
        case 16:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = false
        default:
            tutorial1Image.isHidden = true
            tutorial2Image.isHidden = true
            tutorial3Image.isHidden = true
            tutorial4Image.isHidden = true
            tutorial5Image.isHidden = true
            tutorial6Image.isHidden = true
            tutorial7Image.isHidden = true
            tutorial8Image.isHidden = true
            tutorial9Image.isHidden = true
            tutorial10Image.isHidden = true
            tutorial11Image.isHidden = true
            tutorial12Image.isHidden = true
            tutorial13Image.isHidden = true
            tutorial14Image.isHidden = true
            tutorial15Image.isHidden = true
            tutorial16Image.isHidden = true
            tutorial17Image.isHidden = true
            print("Tutorial does not exist - all tutorials hidden as default")
        }
    }
    
    // This function toggles whether the user instrument is played by buttons or a keyboard.
    // It is called when the keyboard/buttons icon at the top of the screen is pressed.
    @IBAction func userInputChanged(_ sender: UIButton) {
        if userInput == "Buttons" {
            userButton1.isHidden = true
            userButton2.isHidden = true
            userButton3.isHidden = true
            userButton4.isHidden = true
            userButton5.isHidden = true
            userButton6.isHidden = true
            userButton7.isHidden = true
            userButton8.isHidden = true
            userKeyboardKey1.isHidden = false
            userKeyboardKey2.isHidden = false
            userKeyboardKey3.isHidden = false
            userKeyboardKey4.isHidden = false
            userKeyboardKey5.isHidden = false
            userKeyboardKey6.isHidden = false
            userKeyboardKey7.isHidden = false
            userKeyboardKey8.isHidden = false
            userKeyboardKey9.isHidden = false
            userKeyboardKey10.isHidden = false
            userKeyboardKey11.isHidden = false
            userKeyboardKey12.isHidden = false
            userKeyboardKey13.isHidden = false
            
            keyboardImage.isHidden = true
            buttonsImage.isHidden = false

            userInput = "Keyboard"
            userInputIsButtons = false
        }
        else {
            userButton1.isHidden = false
            userButton2.isHidden = false
            userButton3.isHidden = false
            userButton4.isHidden = false
            userButton5.isHidden = false
            userButton6.isHidden = false
            userButton7.isHidden = false
            userButton8.isHidden = false
            userKeyboardKey1.isHidden = true
            userKeyboardKey2.isHidden = true
            userKeyboardKey3.isHidden = true
            userKeyboardKey4.isHidden = true
            userKeyboardKey5.isHidden = true
            userKeyboardKey6.isHidden = true
            userKeyboardKey7.isHidden = true
            userKeyboardKey8.isHidden = true
            userKeyboardKey9.isHidden = true
            userKeyboardKey10.isHidden = true
            userKeyboardKey11.isHidden = true
            userKeyboardKey12.isHidden = true
            userKeyboardKey13.isHidden = true
            
            keyboardImage.isHidden = false
            buttonsImage.isHidden = true
            
            userInput = "Buttons"
            userInputIsButtons = true
        }
    }
    
    // This function unmutes the metronome click track (which is always playing alongside the
    // sequencer), giving the impression it has been turned on.
    // It is called when the metronome icon at the top of the screen is pressed.
    @IBAction func metronomeToggled(_ sender: UIButton) {
        if metronomeIsOn {
            metronomeMixer.volume = 0.0
            metronomeImage.tintColor = UIColor.black
            metronomeIsOn = false
        }
        else {
            metronomeMixer.volume = 0.5
            metronomeImage.tintColor = UIColor.green
            metronomeIsOn = true
        }
    }
    
    // This function toggles the settings overlay between being hidden and visible.
    // It is called when the gear icon at the top of the screen is pressed.
    @IBAction func settingsOpenedOrShut(_ sender: UIButton) {
        if settingsAreVisible {
            settingsBackgroundImage.alpha = 0.0
            outputLevelSlider.isHidden = true
            levelBalanceSlider.isHidden = true
            spaceAmountSlider.isHidden = true
            spaceSizeSegmentedControl.isHidden = true
            themeStepper.isHidden = true
            
            outputLevelLabel.isHidden = true
            balanceLabel.isHidden = true
            balanceBackingLabel.isHidden = true
            balanceSoloLabel.isHidden = true
            spaceLabel.isHidden = true
            themeLabel.isHidden = true
            themeTypeLabel.isHidden = true
            
            settingsAreVisible = false
            settingsImage.tintColor = UIColor.black
        }
        else {
            settingsBackgroundImage.alpha = 1.0
            outputLevelSlider.isHidden = false
            levelBalanceSlider.isHidden = false
            spaceAmountSlider.isHidden = false
            spaceSizeSegmentedControl.isHidden = false
            themeStepper.isHidden = false
            
            outputLevelLabel.isHidden = false
            balanceLabel.isHidden = false
            balanceBackingLabel.isHidden = false
            balanceSoloLabel.isHidden = false
            spaceLabel.isHidden = false
            themeLabel.isHidden = false
            themeTypeLabel.isHidden = false
            
            settingsAreVisible = true
            settingsImage.tintColor = UIColor.green
        }
    }
    
    // This function sets the final output level of Duetry.
    // It is called when the Output slider in Settings is changed.
    @IBAction func changeOutputLevel(_ sender: UISlider) {
        outputMixer.volume = Double(sender.value)
    }
    
    // This function changes the volume balance of the backing track against the user instrument.
    // It is called when the Balance slider in Settings is changed.
    @IBAction func changeBalance(_ sender: UISlider) {
        sequencerMixer.volume = 1.0-Double(sender.value)
        userSamplerMixer.volume = Double(sender.value)
    }
    
    // This function changes the reverb mix, delay mix, and delay feedback in the FXEngine.swift file.
    // It is called when the Space slider in Settings is changed.
    @IBAction func changeSpaceAmount(_ sender: UISlider) {
        fx.changeSpaceAmount(newAmount: Double(sender.value))
    }
    
    // This function changes the reverb preset and delay time in the FXEngine.swift file.
    // It is called when either 'Small', 'Medium', or 'Big' underneath the Space slider in Settings is selected.
    @IBAction func changeSpaceSize(_ sender: UISegmentedControl) {
        fx.changeSpaceSize(newSize: sender.selectedSegmentIndex)
    }
    
    // This function calls changeTheme() internally - it is set up this way so that changeTheme() can
    // also be accessed by init().
    // It is called when the Theme stepper in Settings is pressed.
    @IBAction func themeStepperPressed(_ sender: UIStepper) {
        changeTheme(newTheme: Int(sender.value))
    }
    
    // This function changes the background image and colour palette of sliders in Duetry.
    // It is called internally by themeStepperPressed().
    func changeTheme(newTheme: Int) {
        let chosenTheme = newTheme
        var tintColour: UIColor!
        
        switch chosenTheme {
        case 0: // Cool
            mainBackgroundCool.isHidden = false
            mainBackgroundWarm.isHidden = true
            mainBackgroundLeafy.isHidden = true
            
            tintColour = UIColor.systemBlue
            levelBalanceSlider.maximumTrackTintColor = UIColor.systemTeal
        case 1: // Warm
            mainBackgroundCool.isHidden = true
            mainBackgroundWarm.isHidden = false
            mainBackgroundLeafy.isHidden = true
            
            tintColour = UIColor.systemOrange
            levelBalanceSlider.maximumTrackTintColor = UIColor.systemYellow
        case 2: // Leafy
            mainBackgroundCool.isHidden = true
            mainBackgroundWarm.isHidden = true
            mainBackgroundLeafy.isHidden = false
            
            tintColour = UIColor.systemGreen
            levelBalanceSlider.maximumTrackTintColor = UIColor(red: 0.75, green: 1.0, blue: 0.7, alpha:1.0)
        default:
            mainBackgroundCool.isHidden = false
            mainBackgroundWarm.isHidden = true
            mainBackgroundLeafy.isHidden = true
            
            tintColour = UIColor.systemBlue
            levelBalanceSlider.maximumTrackTintColor = UIColor.systemTeal
            
            print("Theme does not exist. 'Cool' used as default.")
        }
        spaceAmountSlider.tintColor = tintColour
        levelBalanceSlider.tintColor = tintColour
        outputLevelSlider.tintColor = tintColour
        tempoSlider.tintColor = tintColour
        
        themeTypeLabel.text = themeArray[chosenTheme]
    }
}


// ~~~~~~~~~~~~~~~~~~~~~~ CHORD PICKERVIEW FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // These 2 functions intitialise the chord pickerview (in the middle of the screen).
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4 // Number of chords in progression
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7 // Number of chord options
    }
    
    // This function changes the chords loaded into the sequencer in the SequencerInstrument.swift file.
    // It is called when any chord in the chord pickerview (in the middle of the screen) is changed by the user.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sequencer.changeChord(chordPosition: component, chordChoice: chordNumChoicesForPickerview[row])
        
        // Change prog preset label colour to show preset has been changed
        chordProgPresetsLabel.textColor = UIColor.red
    }
    
    // This function changes whether chords are lowercase or uppercase in the chord pickerview.
    // It is called internally by changeScaleChoice().
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
        
            if currentScale == 0 {
                label.text =  majorRomanNumeralArray[row]
            }
            else {
                label.text =  minorRomanNumeralArray[row]
            }
        
            label.font = UIFont (name: "Helvetica Neue", size: 26) // System font is a pain to get so I'm using another
            label.textAlignment = .center
            label.textColor = UIColor.black
            return label
        }
    
    
}
    

