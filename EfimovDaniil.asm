format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        strArrayItem  db 'Enter [%d]=', 0
        strScanInt   db '%d', 0
        strArraySize   db 'Length of array: ', 0
        strNumber   db 'Enter number ', 0
        strIncorrectSize db 'Array length is incorrect= %d', 10, 0
        strInput  db '[%d]=%d', 10, 0

        tmp          dd ?
        tmpStack     dd ?
        vec          rd 100
        num          dd 0
        arr_size     dd 0
        i            dd ?

section '.code' code readable executable
start:

        call VectorInput


        call VectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

VectorInput:

        push strArraySize
        call [printf]
        add esp, 4

        push arr_size
        push strScanInt
        call [scanf]
        add esp, 8

        push strNumber
        call [printf]
        add esp, 4

        push num
        push strScanInt
        call [scanf]
        add esp, 8


        mov eax, [arr_size]
        cmp eax, 0
        jg  getVector

        push arr_size
        push strIncorrectSize
        call [printf]
        push 0
        call [ExitProcess]

getVector:
        xor ecx, ecx
        mov ebx, vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [arr_size]
        jge endInputVector

        mov [i], ecx
        push ecx
        push strArrayItem
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret

VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx
        xor eax, eax
        xor edx, edx
        mov ebx, vec
putVecLoop:
        cmp ecx, [arr_size]
        je endOutputVector

        xor eax, eax
        xor edx, edx
        mov eax, [ebx]
        div [num]

        cmp edx, 0
        je Method


        dec [arr_size]
        add ebx, 4
        jmp putVecLoop

Method:
        mov [tmp], ebx
        mov [i], ecx

        push dword [ebx]
        push ecx
        push strInput
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop

endOutputVector:
        mov esp, [tmpStack]
        ret
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'