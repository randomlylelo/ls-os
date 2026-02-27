bits 16                 ; Tell NASM this is 16-bit code
; Q: What is 16 bit code, it can run on a 32 bit CPU.
org 0x7c00              ; Tell NASM to start outputting stuff at offset 0x7c00
; Q: why this magic number. probs from the manual that the bootloader 
; Q: what does org do

; Q: what do these labels mean? what is boot, .loop? halt?
bob:
    mov si, hello       ; Point si register to the 'hello' string
; Q: hello is more than 2 bytes (16 bits), is it just the address of "hello" fn below? how does assmebly compile here.; why to si?
    mov ah, 0x0e        ; 0x0e means 'Write Character in TTY mode' BIOS function

.loop:
    lodsb               ; Load byte from address ds:si into al, increment si
    or al, al           ; Is al == 0 (null terminator)?
    jz .try             ; If zero, jump to halt
    int 0x10            ; Call BIOS interrupt 0x10 (Video Services)
    jmp .loop           ; Repeat the loop

.try:
    mov si, hello
    jmp .loop

;halt:
;    cli                 ; Clear interrupt flag
;    hlt                 ; Halt execution
; Q: originally was halt:, but couldn't jump back to .loop

hello:
    db "Hello shresth!", 0 ; The string to print, ending with a null terminator

times 510 - ($-$$) db 0 ; Pad remaining bytes with zeroes until 510 bytes
; Q: What is $ - $$? $ is our current pointer, $$ is the previous?
dw 0xaa55               ; Magic bootloader number (marks the sector as bootable)

; 02/22/26
; NEXT STEP IS TO ENABLE PROTECTED MODE