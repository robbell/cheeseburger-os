ORG 0                   ; Set origin
BITS 16

jmp 0x7c0:start         ; Set start procedure address

start:
    cli                 ; Clear interrupts
    mov ax, 0x7c0       
    mov ds, ax          ; Move into data segment
    mov es, ax          ; Move into extra segment
    mov ax, 0x00
    mov ss, ax          ; Set stack segment
    mov sp, 0x7c00      ; Set stack pointer
    sti                 ; Re-enable interrupts

    mov si, message     ; Move address of message into si register
    call print          ; Call print procedure
    jmp $               ; Loop forever

print:
    mov bx, 0           ; Set page to 0
.loop:
    lodsb               ; Load character at address SI into AL and increment SI
    cmp al, 0           ; Compare AL register to null terminator
    je .done            ; Jump to done if comparison is true
    call print_char     ; Call print_char procedure
    jmp .loop           ; Jump to loop beginning
.done:
    ret                 ; Return from procedure

print_char:
    mov ah, 0eh         ; Set display character command for 0x10
    int 0x10            ; Perform BIOS interrupt
    ret                 ; Return from procedure

message: db 'Hello, World!', 0

times 510-($ - $$) db 0 ; Pad remaining bytes with zeroes
dw 0xAA55               ; Add boot signature

; List of interrupts http://www.ctyme.com/intr/rb-0106.htm