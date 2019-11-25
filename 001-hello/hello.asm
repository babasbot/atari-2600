; hello.asm
; A program that initializes the system and puts some colors on the TV.
	processor 6502

; Defines the Code segment, 4K Atari 2600 ROMs usually start at address $F000

	seg Code  ; defines the Code segmet
	org $f000 ; start code at $f000

; A typical thing to do on the VCS is to initialize several flags
; and registers when the cartridge starts or is reset.
; We have to make sure that the stack pointer starts at $FF which will
; give the stack as much room as possible if we use subroutines.

Start	sei		; disable interrupts
	cld		; disable BCD math mode
	ldx #$ff 	; init stack pointer to $FF
	txs 		; transfer X register to S register

; We want to make sure the memory and the hardware is reset to a known state,
; since in the "real world", it will be in a random state.
; This sets the entire zero page region ($00-$FF) to zero, which includes the
; entire TIA register space and the entire RAM space.

	lda #0 		; set the A register to zero
	ldx #$fd	; set the X register to #$ff
ZeroZP	sta $0,X	; store the A register at address ($0 + X)
	dex		; decrement X by one
	bne ZeroZP	; branch until X is zero

; Sets the $09 register (Color-Luminance Background) to $5E (pink).

	lda #$5E	; load the $5E value (pink) into the A register
	sta $09		; store A into the Color-Luminance Background register

; Tells the CPU to return to the Start label and run everything again.

	jmp Start

; Fills the ROM size to 4k and tells the 6502 where aour program starts.

	org $fffc
	.word Start	; reset vector at $fffc
	.word Start	; interrupt vector at $fffc
