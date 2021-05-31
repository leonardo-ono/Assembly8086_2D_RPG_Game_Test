;----------------------------------------------------------------------------;
; PROGRAMA: Prot¢tipo para o Jogo de RPG                                     ;
;----------------------------------------------------------------------------;
;  ARQUIVO: rpg_proto.EXE                                                    ;
;    AUTOR: Leonardo Ono                                                     ;
;     DATA: 29/07/00                                   in Assembly =] Hoho ! ;
;----------------------------------------------------------------------------;
; Rotinas utilizadas:   rpg_inic_tec (inicializa teclado   / arq.: inic_tec) ;
;                       rpg_fina_tec (finaliza teclado     / arq.: fina_tec) ;
;                       modo_video   (define modo v°deo    / arq.: modo_vid) ;
;                       locs_aj_pal  (define palettes      / arq.: loaj_pal) ;   
;                       rpg_des_cenA (desenha cen†rio LyrA / arq.: des_cena) ;
;                       mostra_tela  (pag.de mont. p/ tela / arq.: most_tel) ;
;                       des_pers_prc (des. pers. principal / arq.: des_pr_p) ;
;----------------------------------------------------------------------------;
;            INSTRUÄÂES DE COMANDO              |        COMENTµRIOS         ;   
;----------------------------------------------------------------------------;
rpg_pilha       SEGMENT STACK 'STACK'           ; - Define segmento de pilha.
                DB      100h DUP (?)             
rpg_pilha       ENDS                             
rpg_pag_montag  SEGMENT PARA 'DATA'             ; - Define segmento de dado p/ a PµGINA DE MONTAGEM.
                DB 65535 DUP (0)                ; - Buffer de 64Kbytes.
rpg_pag_montag  ENDS                             
rpg_mapa_A      SEGMENT PARA 'DATA'             ; - Define segmento de dado p/ o MAPA do Layer A.
                INCLUDE mapa_a.asm              ; - Mapa A.
rpg_mapa_A      ENDS                             
rpg_cenario_A   SEGMENT PARA 'DATA'             ; - Define segmento de dado p/ os CENµRIOS do Layer A.
                INCLUDE cenario\grama3.asm      ; - Cen 001: prs2 (PROVIS.)!!!
                INCLUDE cenario\grama.asm       ; - Cen 000: prs3 (PROVIS.)!!!
                INCLUDE cenario\grama2.asm      ; - Cen 001: prs2 (PROVIS.)!!!
                INCLUDE cenario\grama3.asm      ; - Cen 002: grama.
rpg_cenario_A   ENDS                             
rpg_personagens SEGMENT PARA 'DATA'             ; - Define segmento de dado p/ os PERSONAGENS do jogo.
                INCLUDE ares.asm                ; - Inclui personagem "ARES".
rpg_personagens ENDS
rpg_variaveis   SEGMENT PARA 'DATA'             ; - Define segmento de dado para as VARIµVEIS do jogo.
                INCLUDE rpg_varj                ; - Inclui as vari†veis
rpg_variaveis   ENDS                                
rpg_codig_princ SEGMENT PARA 'CODE'             ; - Seg. PRINCIPAL do jogo. 
                ASSUME CS:rpg_codig_princ           
                ASSUME SS:rpg_pilha              
rpg_inicio:                                     ; - In°cio do programa RPG!
                CALL    rpg_inic_tec            ; - Inicializaá∆o do TECLADO!
                MOV     AL,13h                  ; - Def. v°deo:320x200/256c!
                CALL    modo_video               
                MOV     BX,12                   ; - Intensidade BX=12, define os PALETTES!
                CALL    locs_aj_pal
rpg_inic_repA:  CALL    rpg_des_cenA            ; - Desenha CENµRIO LAYER A!
                CALL    des_pers_prc            ; - Desenha o PERSONAGEM PRINCIPAL na sua respectiva posiá∆o!
                CALL    ajst_prsP_xy            ; - Reaj. coordenadas (PROV!).
                CALL    mostra_tela             ; - Passa as imagens da p†gina de montagem para tela atual! 
                IN      AL,60h                  ; - F1 foi pressionada ? Se sim, finalize!
                CMP     AL,3Bh                  
                JNZ     rpg_inic_repA           
rpg_finaliza:   CALL    rpg_fina_tec            ; - Finalizaá∆o do TECLADO!
                MOV     AL,3h                   ; - Def. v°deo:80x25/16c(TXT)!
                CALL    modo_video              
fim:            MOV     AH,4Ch                  ; - Retorna ao DOS.
                INT     21h                     
                INCLUDE rotinas\inic_tec        ; - Inclui rotina 'inic_tec'.
                INCLUDE rotinas\fina_tec        ; - Inclui rotina 'fina_tec'.
                INCLUDE rotinas\modo_vid        ; - Inclui rotina 'modo_vid'.
                INCLUDE rotinas\loaj_pal        ; - Inclui rotina 'lo_ajpal'.
                INCLUDE rotinas\des_cena        ; - Inclui rotina 'des_cena'.
                INCLUDE rotinas\most_tel        ; - Inclui rotina 'most_tel'.
                INCLUDE rotinas\des_pr_p        ; - Inclui rotina 'des_pr_p'.
                INCLUDE aj_pp_xy                ; - PROVIS‡RIO !!!!!
rpg_codig_princ ENDS                             
                END     rpg_inicio              ; - Fim do programa.                


