
; Proyecto: Keygen Basico
; Materia: Lenguajes de Interfaz
; Arquitectura: x86-64 Windows
; Funcion: Sumar los valores ASCII del nombre y aplicar XOR 0ABCDh.

extrn GetStdHandle:proc
extrn ReadConsoleA:proc
extrn WriteConsoleA:proc
extrn ExitProcess:proc

.data
    prompt          db "Escribe tu nombre (maximo 64 caracteres): "
    prompt_len      equ $ - prompt

    msg_empty       db 13,10,"Error: el nombre no puede estar vacio.",13,10
    msg_empty_len   equ $ - msg_empty

    msg_long        db 13,10,"Error: el nombre no puede superar 64 caracteres.",13,10
    msg_long_len    equ $ - msg_long

    msg_result      db 13,10,"Key generado: "
    msg_result_len  equ $ - msg_result

    newline         db 13,10
    newline_len     equ $ - newline

    input_buffer    db 68 dup(0)
    hex_buffer      db 16 dup(0)

    chars_read      dd 0
    chars_written   dd 0
    input_length    dq 0
    ascii_sum       dq 0
    key_value       dq 0
    stdin_handle    dq 0
    stdout_handle   dq 0

    hex_digits      db "0123456789ABCDEF"

.code
main proc
    sub rsp, 28h

    ; Obtener el identificador de la consola de salida.
    mov ecx, -11
    call GetStdHandle
    mov qword ptr [stdout_handle], rax

    ; Obtener el identificador de la consola de entrada.
    mov ecx, -10
    call GetStdHandle
    mov qword ptr [stdin_handle], rax

    ; Mostrar el mensaje para solicitar el nombre.
    mov rcx, qword ptr [stdout_handle]
    lea rdx, prompt
    mov r8d, prompt_len
    lea r9, chars_written
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    ; Leer hasta 67 caracteres para detectar entradas demasiado largas.
    mov rcx, qword ptr [stdin_handle]
    lea rdx, input_buffer
    mov r8d, 67
    lea r9, chars_read
    mov qword ptr [rsp+20h], 0
    call ReadConsoleA

    ; Calcular la longitud leida.
    mov eax, dword ptr [chars_read]
    mov qword ptr [input_length], rax

    ; Eliminar CR y LF si ReadConsoleA los incluyo.
    cmp rax, 2
    jb check_length
    mov r10, rax
    sub r10, 2
    lea r11, input_buffer
    cmp byte ptr [r11+r10], 13
    jne check_length
    cmp byte ptr [r11+r10+1], 10
    jne check_length
    mov qword ptr [input_length], r10

check_length:
    ; Rechazar nombres vacios.
    mov rax, qword ptr [input_length]
    test rax, rax
    jnz check_too_long

    mov rcx, qword ptr [stdout_handle]
    lea rdx, msg_empty
    mov r8d, msg_empty_len
    lea r9, chars_written
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    mov ecx, 1
    call ExitProcess

check_too_long:
    ; Rechazar nombres mayores a 64 caracteres.
    cmp qword ptr [input_length], 64
    jbe calculate_sum

    mov rcx, qword ptr [stdout_handle]
    lea rdx, msg_long
    mov r8d, msg_long_len
    lea r9, chars_written
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    mov ecx, 1
    call ExitProcess

calculate_sum:
    ; Sumar los valores ASCII de cada caracter.
    lea rsi, input_buffer
    mov rcx, qword ptr [input_length]
    xor rax, rax

sum_loop:
    test rcx, rcx
    jz sum_done

    movzx rdx, byte ptr [rsi]
    add rax, rdx
    inc rsi
    dec rcx
    jmp sum_loop

sum_done:
    mov qword ptr [ascii_sum], rax

    ; Aplicar XOR con 0ABCDh para generar la clave.
    xor rax, 0ABCDh
    mov qword ptr [key_value], rax

    ; Mostrar el encabezado del resultado.
    mov rcx, qword ptr [stdout_handle]
    lea rdx, msg_result
    mov r8d, msg_result_len
    lea r9, chars_written
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    ; Convertir la clave a 16 digitos hexadecimales.
    mov rax, qword ptr [key_value]
    lea rdi, hex_buffer
    mov ecx, 16

hex_loop:
    mov rdx, rax
    shr rdx, 60
    and edx, 0Fh

    lea rsi, hex_digits
    mov dl, byte ptr [rsi+rdx]
    mov byte ptr [rdi], dl

    shl rax, 4
    inc rdi
    dec ecx
    jnz hex_loop

    ; Escribir los 16 digitos hexadecimales.
    mov rcx, qword ptr [stdout_handle]
    lea rdx, hex_buffer
    mov r8d, 16
    lea r9, chars_written
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    ; Salto de linea final.
    mov rcx, qword ptr [stdout_handle]
    lea rdx, newline
    mov r8d, newline_len
    lea r9, chars_written
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    xor ecx, ecx
    call ExitProcess

main endp
end

