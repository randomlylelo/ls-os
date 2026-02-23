bits 16                 ; Tell NASM this is 16-bit code
; What is 16 bit code, it can run on a 32 bit CPU.
org 0x7c00              ; Tell NASM to start outputting stuff at offset 0x7c00
; why this magic number. probs from the manual that the bootloader 
; what does org do

; what do these labels mean? what is boot, .loop? halt?
boot:
    mov si, hello       ; Point si register to the 'hello' string
; hello is more than 2 bytes (16 bits), is it just the address of "hello" fn below? how does assmebly compile here.; why to si?
    mov ah, 0x0e        ; 0x0e means 'Write Character in TTY mode' BIOS function
; 
.loop:
    lodsb               ; Load byte from address ds:si into al, increment si
    or al, al           ; Is al == 0 (null terminator)?
    jz .try             ; If zero, jump to halt
    int 0x10            ; Call BIOS interrupt 0x10 (Video Services)
    jmp .loop           ; Repeat the loop

.try:
    mov si, hello
    jmp .loop

;    cli                 ; Clear interrupt flag
;    hlt                 ; Halt execution

hello:
    db "Hello shresth!", 0 ; The string to print, ending with a null terminator

times 510 - ($-$$) db 0 ; Pad remaining bytes with zeroes until 510 bytes
; What is $ - $$? $ is our current pointer, $$ is the previous?
dw 0xaa55               ; Magic bootloader number (marks the sector as bootable)
