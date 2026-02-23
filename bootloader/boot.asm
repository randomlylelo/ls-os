bits 16                 ; Tell NASM this is 16-bit code
org 0x7c00              ; Tell NASM to start outputting stuff at offset 0x7c00

boot:
    mov si, hello       ; Point si register to the 'hello' string
    mov ah, 0x0e        ; 0x0e means 'Write Character in TTY mode' BIOS function
.loop:
    lodsb               ; Load byte from address ds:si into al, increment si
    or al, al           ; Is al == 0 (null terminator)?
    jz halt             ; If zero, jump to halt
    int 0x10            ; Call BIOS interrupt 0x10 (Video Services)
    jmp .loop           ; Repeat the loop

halt:
    cli                 ; Clear interrupt flag
    hlt                 ; Halt execution

hello:
    db "Hello world!", 0 ; The string to print, ending with a null terminator

times 510 - ($-$$) db 0 ; Pad remaining bytes with zeroes until 510 bytes
dw 0xaa55               ; Magic bootloader number (marks the sector as bootable)
