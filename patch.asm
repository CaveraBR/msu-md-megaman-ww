; Megaman - The Wily Wars (E) [f3] (SRAM Save by MottZilla).bin
; SMPS Z80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRODUCTION = 1

; I/O
HW_version		EQU	$A10001					; hardware version in low nibble
											; bit 6 is PAL (50Hz) if set, NTSC (60Hz) if clear
											; region flags in bits 7 and 6:
											;         USA NTSC = $80
											;         Asia PAL = $C0
											;         Japan NTSC = $00
											;         Europe PAL = $C0
											
; MSU-MD vars
MCD_STAT		EQU $A12020					; 0-ready, 1-init, 2-cmd busy
MCD_CMD			EQU $A12010
MCD_ARG 		EQU $A12011
MCD_CMD_CK 		EQU $A1201F


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		org $4
		dc.l 	ENTRY_POINT					; custom entry point for redirecting
		
		org 	$100
		dc.b 	'SEGA MEGASD     '
		
		org 	$1A4						; ROM_END
		dc.l 	$003FFFFF					; Overwrite with 32 MBIT size
		
		org 	$1F0 						; Region setting
		dc.b 	'JUE'

		org 	$228						; original entry point, after reset-checks ($200 present in the header)
Game
		
		org 	$6E2D4						; hijack this
		jsr 	CustomPlaySound
		rts



		org		$1FFBA0
MSUDRV
		incbin	"msu-drv.bin"
		
		align 	2

ENTRY_POINT
		tst.w 	$00A10008  					; Test mystery reset (expansion port reset?)
		bne Main          					; Branch if Not Equal (to zero) - to Main
		tst.w 	$00A1000C  					; Test reset button
		bne Main          					; Branch if Not Equal (to zero) - to Main
Main
		move.b 	$00A10001,d0      			; Move Megadrive hardware version to d0
		andi.b 	#$0F,d0           			; The version is stored in last four bits, so mask it with 0F
		beq 	Skip                  		; If version is equal to 0, skip TMSS signature
		move.l 	#'SEGA',$00A14000 			; Move the string "SEGA" to 0xA14000
Skip
		btst 	#$6,(HW_version).l 			; Check for PAL or NTSC, 0=60Hz, 1=50Hz
		bne 	jump_lockout				; branch if != 0
		jsr 	audio_init
		jmp 	Game
jump_lockout
		jmp 	lockout



audio_init
        jsr     MSUDRV
        nop

        if PRODUCTION
        
        tst.b   d0                          ; if 1: no CD Hardware found
        bne     audio_init_fail             ; Return without setting CD enabled
        
        endif

ready_init
        tst.b   MCD_STAT
        bne.s   ready_init
        move.w  #($1500|255),MCD_CMD        ; Set CD Volume to MAX
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
audio_init_fail
        jmp     lockout
        
        align   2
		
CustomPlaySound
ready
		tst.b 	MCD_STAT
		bne.s 	ready 						; Wait for Driver ready to receive cmd
		jsr 	find_track
		rts 								; Return to regular game code



find_track
		cmp.b	#$00,d0						; Mega Man 1: Cutman Stage
		beq		play_track_1
		cmp.b	#$01,d0						; Mega Man 1: Gutsman Stage
		beq		play_track_2
		cmp.b	#$02,d0						; Mega Man 1: Iceman Stage
		beq		play_track_3
		cmp.b	#$03,d0						; Mega Man 1: Bombman Stage
		beq		play_track_4
		cmp.b	#$04,d0						; Mega Man 1: Fireman Stage
		beq		play_track_5
		cmp.b	#$05,d0						; Mega Man 1: Elecman Stage
		beq		play_track_6
		cmp.b	#$06,d0						; Mega Man 1: Dr. Wily Stage 1
		beq		play_track_7
		cmp.b	#$07,d0						; Mega Man 1: Dr. Wily Stage 2
		beq		play_track_8
		cmp.b	#$08,d0						; Mega Man 1: Stage Select
		beq		play_track_9
		cmp.b	#$09,d0						; Mega Man 1: Game Start
		beq		play_track_10
		cmp.b	#$0A,d0						; Mega Man 1: Boss Theme
		beq		play_track_11
		cmp.b	#$0B,d0						; Mega Man 1: Stage Clear
		beq		play_track_12
		cmp.b	#$0C,d0						; Mega Man 1: Game Over
		beq		play_track_13
		cmp.b	#$0D,d0						; Mega Man 1: Dr. Wily Stage Boss
		beq		play_track_14
		cmp.b	#$0E,d0						; Mega Man 1: Ending Theme
		beq		play_track_15
		cmp.b	#$0F,d0						; Mega Man 2: Opening Theme
		beq		play_track_16
		cmp.b	#$10,d0						; Mega Man 2: Title Theme
		beq		play_track_17
		cmp.b	#$11,d0						; Mega Man 2: Password
		beq		play_track_18
		cmp.b	#$12,d0						; Mega Man 2: Game Start
		beq		play_track_19
		cmp.b	#$13,d0						; Mega Man 2: Stage Clear
		beq		play_track_20
		cmp.b	#$14,d0						; Mega Man 2: Bubbleman Stage
		beq		play_track_21
		cmp.b	#$15,d0						; Mega Man 2: Airman Stage
		beq		play_track_22
		cmp.b	#$16,d0						; Mega Man 2: Quickman Stage
		beq		play_track_23
		cmp.b	#$17,d0						; Mega Man 2: Heatman Stage
		beq		play_track_24
		cmp.b	#$18,d0						; Mega Man 2: Woodman Stage
		beq		play_track_25
		cmp.b	#$19,d0						; Mega Man 2: Metalman Stage
		beq		play_track_26
		cmp.b	#$1A,d0						; Mega Man 2: Flashman Stage
		beq		play_track_27
		cmp.b	#$1B,d0						; Mega Man 2: Crashman Stage
		beq		play_track_28
		cmp.b	#$1C,d0						; Mega Man 2: Dr. Wily Stage 1
		beq		play_track_29
		cmp.b	#$1D,d0						; Mega Man 2: Dr. Wily Stage 2
		beq		play_track_30
		cmp.b	#$1E,d0						; Mega Man 2: Stage Select
		beq		play_track_31
		cmp.b	#$1F,d0						; Mega Man 2: Game Over
		beq		play_track_32
		cmp.b	#$20,d0						; Mega Man 2: Dr. Wily Map
		beq		play_track_33
		cmp.b	#$21,d0						; Mega Man 2: Boss Theme
		beq		play_track_34
		cmp.b	#$22,d0						; Mega Man 2: All Stages Clear
		beq		play_track_35
		cmp.b	#$23,d0						; Mega Man 2: New Weapon
		beq		play_track_36
		cmp.b	#$24,d0						; Mega Man 2: Ending Theme
		beq		play_track_37
		cmp.b	#$25,d0						; Mega Man 2: Staff Roll
		beq		play_track_38
		cmp.b	#$26,d0						; Mega Man 3: Title Theme
		beq		play_track_39
		cmp.b	#$27,d0						; Mega Man 3: Protomans Whistle
		beq		play_track_40
		cmp.b	#$28,d0						; Mega Man 3: Sparkman Stage
		beq		play_track_41
		cmp.b	#$29,d0						; Mega Man 3: Snakeman Stage
		beq		play_track_42
		cmp.b	#$2A,d0						; Mega Man 3: Needleman Stage
		beq		play_track_43
		cmp.b	#$2B,d0						; Mega Man 3: Hardman Stage
		beq		play_track_44
		cmp.b	#$2C,d0						; Mega Man 3: Topman Stage
		beq		play_track_45
		cmp.b	#$2D,d0						; Mega Man 3: Geminiman Stage
		beq		play_track_46
		cmp.b	#$2E,d0						; Mega Man 3: Magnetman Stage
		beq		play_track_47
		cmp.b	#$2F,d0						; Mega Man 3: Shadowman Stage
		beq		play_track_48
		cmp.b	#$30,d0						; Mega Man 3: Dr. Wily Stage 1
		beq		play_track_49
		cmp.b	#$31,d0						; Mega Man 3: Dr. Wily Stage 2
		beq		play_track_50
		cmp.b	#$32,d0						; Mega Man 3: Dr. Wily Stage 3
		beq		play_track_51
		cmp.b	#$33,d0						; Mega Man 3: Stage Select
		beq		play_track_52
		cmp.b	#$34,d0						; Mega Man 3: Game Start
		beq		play_track_53
		cmp.b	#$35,d0						; Mega Man 3: Password
		beq		play_track_54
		cmp.b	#$36,d0						; Mega Man 3: New Weapon
		beq		play_track_55
		cmp.b	#$37,d0						; Mega Man 3: Boss Theme
		beq		play_track_56
		cmp.b	#$38,d0						; Mega Man 3: Stage Clear
		beq		play_track_57
		cmp.b	#$39,d0						; Mega Man 3: Ending Theme
		beq		play_track_58
		cmp.b	#$3A,d0						; Mega Man 3: Dr. Wily Map
		beq		play_track_59
		cmp.b	#$3B,d0						; Mega Man 3: Dr. Wily Boss Theme
		beq		play_track_60
		cmp.b	#$3C,d0						; Mega Man 3: Staff Roll
		beq		play_track_61
		cmp.b	#$3D,d0						; Introduction
		beq		play_track_62
		cmp.b	#$3E,d0						; Title Theme
		beq		play_track_63
		cmp.b	#$3F,d0						; Game Select
		beq		play_track_64
		cmp.b	#$40,d0						; Wilys Tower: Buster Rod-G Stage
		beq		play_track_65
		cmp.b	#$41,d0						; Wilys Tower: Mega Water-S Stage
		beq		play_track_66
		cmp.b	#$42,d0						; Wilys Tower: Hyper Storm-H Stage
		beq		play_track_67
		cmp.b	#$43,d0						; Wilys Tower: Wilys Tower Stage 1
		beq		play_track_68
		cmp.b	#$44,d0						; Wilys Tower: Wilys Tower Stage 2
		beq		play_track_69
		cmp.b	#$45,d0						; Wilys Tower: Wilys Tower Stage 3
		beq		play_track_70
		cmp.b	#$46,d0						; Wilys Tower: All Stages Clear
		beq		play_track_71
		cmp.b	#$47,d0						; Wilys Tower: Boss Theme
		beq		play_track_72
		cmp.b	#$48,d0						; Wilys Tower: New Weapon
		beq		play_track_73
		cmp.b	#$49,d0						; Wilys Tower: Game Start
		beq		play_track_74
		cmp.b	#$4A,d0						; Wilys Tower: Game Over
		beq		play_track_75
		cmp.b	#$4B,d0						; Wilys Tower: Stage Clear
		beq		play_track_76
		cmp.b	#$4C,d0						; Wilys Tower: Light Lab
		beq		play_track_77
		cmp.b	#$4D,d0						; Wilys Tower: Stage Select
		beq		play_track_78
		cmp.b	#$4E,d0						; Wilys Tower: Wilys Tower Map
		beq		play_track_79
		cmp.b	#$4F,d0						; Wilys Tower: Wilys Tower Stage 4
		beq		play_track_80
		cmp.b	#$50,d0						; Wilys Tower: Ending Theme
		beq		play_track_81
		cmp.b	#$51,d0						; (not in sound test) Capcom Logo
		beq		play_track_82
		cmp.b	#$52,d0						; (not in sound test) ??
		beq		play_track_83
		rts


play_track_1								; Mega Man 1: Cutman Stage
		move.w	#($1100|1),MCD_CMD			; send cmd: play track #1, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_2								; Mega Man 1: Gutsman Stage
		move.w	#($1100|2),MCD_CMD			; send cmd: play track #2, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_3								; Mega Man 1: Iceman Stage
		move.w	#($1100|3),MCD_CMD			; send cmd: play track #3, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_4								; Mega Man 1: Bombman Stage
		move.w	#($1100|4),MCD_CMD			; send cmd: play track #4, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_5								; Mega Man 1: Fireman Stage
		move.w	#($1100|5),MCD_CMD			; send cmd: play track #5, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_6								; Mega Man 1: Elecman Stage
		move.w	#($1100|6),MCD_CMD			; send cmd: play track #6, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_7								; Mega Man 1: Dr. Wily Stage 1
		move.w	#($1100|7),MCD_CMD			; send cmd: play track #7, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_8								; Mega Man 1: Dr. Wily Stage 2
		move.w	#($1100|8),MCD_CMD			; send cmd: play track #8, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_9								; Mega Man 1: Stage Select
		move.w	#($1100|9),MCD_CMD			; send cmd: play track #9, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_10								; Mega Man 1: Game Start
		move.w	#($1100|10),MCD_CMD			; send cmd: play track #10, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_11								; Mega Man 1: Boss Theme
		move.w	#($1100|11),MCD_CMD			; send cmd: play track #11, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_12								; Mega Man 1: Stage Clear
		move.w	#($1100|12),MCD_CMD			; send cmd: play track #12, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_13								; Mega Man 1: Game Over
		move.w	#($1100|13),MCD_CMD			; send cmd: play track #13, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_14								; Mega Man 1: Dr. Wily Stage Boss
		move.w	#($1100|14),MCD_CMD			; send cmd: play track #14, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_15								; Mega Man 1: Ending Theme
		move.w	#($1100|15),MCD_CMD			; send cmd: play track #15, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_16								; Mega Man 2: Opening Theme
		move.w	#($1100|16),MCD_CMD			; send cmd: play track #16, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_17								; Mega Man 2: Title Theme
		move.w	#($1100|17),MCD_CMD			; send cmd: play track #17, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_18								; Mega Man 2: Password
		move.w	#($1100|18),MCD_CMD			; send cmd: play track #18, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_19								; Mega Man 2: Game Start
		move.w	#($1100|19),MCD_CMD			; send cmd: play track #19, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_20								; Mega Man 2: Stage Clear
		move.w	#($1100|20),MCD_CMD			; send cmd: play track #20, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_21								; Mega Man 2: Bubbleman Stage
		move.w	#($1100|21),MCD_CMD			; send cmd: play track #21, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_22								; Mega Man 2: Airman Stage
		move.w	#($1100|22),MCD_CMD			; send cmd: play track #22, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_23								; Mega Man 2: Quickman Stage
		move.w	#($1100|23),MCD_CMD			; send cmd: play track #23, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_24								; Mega Man 2: Heatman Stage
		move.w	#($1100|24),MCD_CMD			; send cmd: play track #24, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_25								; Mega Man 2: Woodman Stage
		move.w	#($1100|25),MCD_CMD			; send cmd: play track #25, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_26								; Mega Man 2: Metalman Stage
		move.w	#($1100|26),MCD_CMD			; send cmd: play track #26, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_27								; Mega Man 2: Flashman Stage
		move.w	#($1100|27),MCD_CMD			; send cmd: play track #27, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_28								; Mega Man 2: Crashman Stage
		move.w	#($1100|28),MCD_CMD			; send cmd: play track #28, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_29								; Mega Man 2: Dr. Wily Stage 1
		move.w	#($1100|29),MCD_CMD			; send cmd: play track #29, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_30								; Mega Man 2: Dr. Wily Stage 2
		move.w	#($1100|30),MCD_CMD			; send cmd: play track #30, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_31								; Mega Man 2: Stage Select
		move.w	#($1100|31),MCD_CMD			; send cmd: play track #31, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_32								; Mega Man 2: Game Over
		move.w	#($1100|32),MCD_CMD			; send cmd: play track #32, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_33								; Mega Man 2: Dr. Wily Map
		move.w	#($1100|33),MCD_CMD			; send cmd: play track #33, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_34								; Mega Man 2: Boss Theme
		move.w	#($1100|34),MCD_CMD			; send cmd: play track #34, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_35								; Mega Man 2: All Stages Clear
		move.w	#($1100|35),MCD_CMD			; send cmd: play track #35, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_36								; Mega Man 2: New Weapon
		move.w	#($1100|36),MCD_CMD			; send cmd: play track #36, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_37								; Mega Man 2: Ending Theme
		move.w	#($1100|37),MCD_CMD			; send cmd: play track #37, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_38								; Mega Man 2: Staff Roll
		move.w	#($1100|38),MCD_CMD			; send cmd: play track #38, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_39								; Mega Man 3: Title Theme
		move.w	#($1100|39),MCD_CMD			; send cmd: play track #39, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_40								; Mega Man 3: Protomans Whistle
		move.w	#($1100|40),MCD_CMD			; send cmd: play track #40, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_41								; Mega Man 3: Sparkman Stage
		move.w	#($1100|41),MCD_CMD			; send cmd: play track #41, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_42								; Mega Man 3: Snakeman Stage
		move.w	#($1100|42),MCD_CMD			; send cmd: play track #42, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_43								; Mega Man 3: Needleman Stage
		move.w	#($1100|43),MCD_CMD			; send cmd: play track #43, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_44								; Mega Man 3: Hardman Stage
		move.w	#($1100|44),MCD_CMD			; send cmd: play track #44, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_45								; Mega Man 3: Topman Stage
		move.w	#($1100|45),MCD_CMD			; send cmd: play track #45, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_46								; Mega Man 3: Geminiman Stage
		move.w	#($1100|46),MCD_CMD			; send cmd: play track #46, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_47								; Mega Man 3: Magnetman Stage
		move.w	#($1100|47),MCD_CMD			; send cmd: play track #47, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_48								; Mega Man 3: Shadowman Stage
		move.w	#($1100|48),MCD_CMD			; send cmd: play track #48, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_49								; Mega Man 3: Dr. Wily Stage 1
		move.w	#($1100|49),MCD_CMD			; send cmd: play track #49, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_50								; Mega Man 3: Dr. Wily Stage 2
		move.w	#($1100|50),MCD_CMD			; send cmd: play track #50, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_51								; Mega Man 3: Dr. Wily Stage 3
		move.w	#($1100|51),MCD_CMD			; send cmd: play track #51, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_52								; Mega Man 3: Stage Select
		move.w	#($1100|52),MCD_CMD			; send cmd: play track #52, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_53								; Mega Man 3: Game Start
		move.w	#($1100|53),MCD_CMD			; send cmd: play track #53, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_54								; Mega Man 3: Password
		move.w	#($1100|54),MCD_CMD			; send cmd: play track #54, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_55								; Mega Man 3: New Weapon
		move.w	#($1100|55),MCD_CMD			; send cmd: play track #55, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_56								; Mega Man 3: Boss Theme
		move.w	#($1100|56),MCD_CMD			; send cmd: play track #56, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_57								; Mega Man 3: Stage Clear
		move.w	#($1100|57),MCD_CMD			; send cmd: play track #57, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_58								; Mega Man 3: Ending Theme
		move.w	#($1100|58),MCD_CMD			; send cmd: play track #58, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_59								; Mega Man 3: Dr. Wily Map
		move.w	#($1100|59),MCD_CMD			; send cmd: play track #59, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_60								; Mega Man 3: Dr. Wily Boss Theme
		move.w	#($1100|60),MCD_CMD			; send cmd: play track #60, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_61								; Mega Man 3: Staff Roll
		move.w	#($1100|61),MCD_CMD			; send cmd: play track #61, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_62								; Introduction
		move.w	#($1100|62),MCD_CMD			; send cmd: play track #62, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_63								; Title Theme
		move.w	#($1100|63),MCD_CMD			; send cmd: play track #63, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_64								; Game Select
		move.w	#($1100|64),MCD_CMD			; send cmd: play track #64, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_65								; Wilys Tower: Buster Rod-G Stage
		move.w	#($1100|65),MCD_CMD			; send cmd: play track #65, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_66								; Wilys Tower: Mega Water-S Stage
		move.w	#($1100|66),MCD_CMD			; send cmd: play track #66, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_67								; Wilys Tower: Hyper Storm-H Stage
		move.w	#($1100|67),MCD_CMD			; send cmd: play track #67, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_68								; Wilys Tower: Wilys Tower Stage 1
		move.w	#($1100|68),MCD_CMD			; send cmd: play track #68, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_69								; Wilys Tower: Wilys Tower Stage 2
		move.w	#($1100|69),MCD_CMD			; send cmd: play track #69, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_70								; Wilys Tower: Wilys Tower Stage 3
		move.w	#($1100|70),MCD_CMD			; send cmd: play track #70, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_71								; Wilys Tower: All Stages Clear
		move.w	#($1100|71),MCD_CMD			; send cmd: play track #71, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_72								; Wilys Tower: Boss Theme
		move.w	#($1100|72),MCD_CMD			; send cmd: play track #72, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_73								; Wilys Tower: New Weapon
		move.w	#($1100|73),MCD_CMD			; send cmd: play track #73, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_74								; Wilys Tower: Game Start
		move.w	#($1100|74),MCD_CMD			; send cmd: play track #74, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_75								; Wilys Tower: Game Over
		move.w	#($1100|75),MCD_CMD			; send cmd: play track #75, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_76								; Wilys Tower: Stage Clear
		move.w	#($1100|76),MCD_CMD			; send cmd: play track #76, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_77								; Wilys Tower: Light Lab
		move.w	#($1100|77),MCD_CMD			; send cmd: play track #77, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_78								; Wilys Tower: Stage Select
		move.w	#($1100|78),MCD_CMD			; send cmd: play track #78, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_79								; Wilys Tower: Wilys Tower Map
		move.w	#($1100|79),MCD_CMD			; send cmd: play track #79, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_80								; Wilys Tower: Wilys Tower Stage 4
		move.w	#($1100|80),MCD_CMD			; send cmd: play track #80, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_81								; Wilys Tower: Ending Theme
		move.w	#($1100|81),MCD_CMD			; send cmd: play track #81, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_82								; (not in sound test) Capcom Logo
		move.w	#($1100|82),MCD_CMD			; send cmd: play track #82, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts
play_track_83								; (not in sound test) ??
		move.w	#($1100|83),MCD_CMD			; send cmd: play track #83, no loop
		addq.b	#1,MCD_CMD_CK				; Increment command clock
		rts

		align	2							; insert GFX and code for lockout screen
lockout
		incbin 	"msuLockout.bin"		
