!RegControl = $F1
!RegDSPAddress = $F2 
!RegDSPValue = $F3
!RegAPUPort0 = $F4
!RegAPUPort1 = $F5
!RegAPUPort2 = $F6
!RegAPUPort3 = $F7
!RegRegularMemory = $F8
!RegTimer0 = $FA
!RegTimer1 = $FB
!RegTimer2 = $FC
!RegCounter0 = $FD
!RegCounter1 = $FE
!RegCounter2 = $FF

org $0000

SPC700Scratch: skip 16

namespace SPC700MusicChannels
    Octave: skip 8
    
    TunningLowByte: skip 8
    CurrentDurationLowByte: skip 8
    TotalDurationLowByte: skip 8
    DefaultDurationLowByte: skip 8
    CurrentPointerLowByte: skip 8
    ResetPointerLowByte: skip 8
    LoopPointerLowByte: skip 8
    NestedLoopPointerLowByte: skip 8

    TunningHighByte: skip 8
    CurrentDurationHighByte: skip 8
    TotalDurationHighByte: skip 8
    DefaultDurationHighByte: skip 8
    CurrentPointerHighByte: skip 8
    ResetPointerHighByte: skip 8
    LoopPointerHighByte: skip 8
    NestedLoopPointerHighByte: skip 8
namespace off

struct SPC700Mirrors
    .MainVolumeLeft: skip 1
    .MainVolumeRight: skip 1
    .KeyOn: skip 1
    .KeyOff: skip 1
    .PitchModulationEnable: skip 1
    .NoiseEnable: skip 1
    .EchoEnable: skip 1
    .FirEnable: skip 1
    .FirFilterCoefficients: skip 8
    .EchoVolumeLeft: skip 1
    .EchoVolumeRight: skip 1
    .EchoBufferAddress: skip 1
    .EchoDelay: skip 1
    .EchoFeedback: skip 1
    .SampleEndRead: skip 1
    .DSPFlags: skip 1
endstruct 
skip sizeof(SPC700Mirrors)

struct EngineVariables
    .MainVolume: skip 1
    .MusicEnable: skip 1
    .SoundEffectEnable: skip 1
    .MusicVolume: skip 1
    .SoundEffectVolume: skip 1
    .MusicTickCounter: skip 1
    .MusicTempo: skip 1
    .MusicTableAddress: skip 1
    .SoundEffectTableAddress: skip 1
    .CommandTableAddress: skip 1
endstruct
skip sizeof(EngineVariables)
