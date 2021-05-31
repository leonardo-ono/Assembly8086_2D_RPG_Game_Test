pilha   SEGMENT STACK 'STACK'
        DB 100h DUP (?)
pilha   ENDS

dadoA   SEGMENT PARA 'DATA'
        include BACK.asm
dadoA   ENDS

dadoB   SEGMENT PARA 'DATA'
        include conv.asm
        x       dw 0
        y       dw 0
        T       dW 0
dadoB   ENDS

dadoC   SEGMENT PARA 'DATA'
auxpag  DB 64000 DUP (215)        
dadoC   ENDS

codib   SEGMENT PARA 'CODE'
        ASSUME ES:dadoC, CS:codib

mostra_tela     PROC FAR
                PUSH    AX
                PUSH    BX
                PUSH    CX
                PUSH    DX
                PUSH    DS
                PUSH    ES
                        
                MOV DX,0A000h
                MOV DS,DX
                MOV DX,dadoC
                MOV ES,DX
                MOV BX,0
repete_mt:
                MOV     AL,ES:[BX]
                MOV     DS:[BX],AL
                INC     BX
                CMP     BX,64001
                JNZ     repete_mt

                POP     ES
                POP     DS
                POP     DX
                POP     CX
                POP     BX
                POP     AX
                RETF
mostra_tela     ENDP

codib   ENDS

codig   SEGMENT PARA 'CODE'
        ASSUME CS:codig, SS:pilha, DS:dadoC

        JMP inicio_rpg
        include aj_pal

; *** AJUSTE INICIAL

inicio_rpg:

                MOV     AH,0
                MOV     AL,13h
                INT     10h
                MOV     DX,dadoC
                MOV     DS,DX
               mov     bl,12
                call    aj_pal

; *** BACKGROUND

comeca_anim:
                ASSUME  ES:dadoA
                MOV     DX,dadoA
                MOV     ES,DX

                MOV     CX,0
                MOV     BX,0
                MOV     DI,0

repet:          MOV     DL,ES:[prs2 + DI]
                INC     DI
                CALL    Desenha_ponto

                INC     CX
                CMP     CX,320
                JZ      acres_y
                JMP     repet

acres_y:        INC     BX
                MOV     CX,0

                CMP     BX,200
                JZ      fib
                JMP     repet

fib:
                ASSUME  ES:dadoB
                MOV     DX,dadoB
                MOV     ES,DX

; *** ANIM 1

anim1:          MOV     CX,0
                MOV     BX,0
                MOV     DI,0

repete:         MOV     DL,ES:[prs3 + DI]
                INC     DI
                MOV     SI,ES:[t]
                CALL    Desenha_pont_t

                INC     CX
                CMP     CX,320
                JZ      acresc_y
                JMP     repete

acresc_y:       INC     BX
                MOV     CX,0

                CMP     BX,200
                JZ      fimb
                JMP     repete


fimb:
                CALL    mostra_tela

                ASSUME  DS:dadoC
                MOV     DX,dadoC
                MOV     DS,DX

;                MOV     AH,0
;                INT     16h

                mov     dl,0ffh
                mov     ah,6
                int     21h

                CMP     AL,1Bh
                JZ      FIM

                CALL    ajxy

                JMP     comeca_anim


fim:

                MOV     AH,0
                MOV     AL,3h
                INT     10h

        MOV AH,3H       ; Acelera a qtdade de tec/s
        MOV AL,5H
        MOV BH,00H
        MOV BL,00H
        INT 16h

                MOV     AH,4Ch
                INT     21h

                include ds_pnt
                include ds_pnt_t

ajxy            proc    near

                jmp     esq

                cmp     ah,48h
                jz      cim
                cmp     ah,4bh
                jz      esq
                cmp     ah,4dh
                jz      dir
                cmp     ah,50h
                jz      bai

                ASSUME  ES:dadoB
                MOV     DX,dadoB
                MOV     ES,DX
cim:            SUB     ES:[Y],1
                ret
esq:            SUB     ES:[X],1

                cmp     aL,"+"
                jz      MAI

                cmp     aL,"-"
                jz      MEN

                ret
dir:            ADD     ES:[X],1
                ret
bai:            ADD     ES:[Y],1
                ret
MAI:
                SUB     ES:[T],13
                CMP     ES:[T],0
                JL      menor
                RET
menor:          MOV     ES:[T],0
                RET
                                
MEN:            ADD     ES:[T],13
                CMP     ES:[T],100
                JG      maior
                ret
maior:          MOV     ES:[T],100
                RET
ajxy            endp
codig           ENDS

                END inicio_rpg

