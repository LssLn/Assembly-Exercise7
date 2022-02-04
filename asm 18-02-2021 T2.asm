;# int verifica(char *st, int d)
;# { int j;
;# for(j=0;j<d;j++)
;# if(st[j]>=st[j+1])
;# break;
;# return j+1;
;# }
;# main() {
;# char STRINGA[16];
;# int i, conta;
;# i=0;
;# do {
;# printf("Inserisci una stringa di numeri crescenti\n");
;# scanf("%s",STRINGA);
;# conta= verifica(STRINGA, strlen(STRINGA));
;# printf("Valore = %d \n",conta);
;# i++;
;# } while (i<4 && strlen(STRINGA)==conta);
;# }

.data 
ST: .space 16 ;# ST[16]
stack: .space 32

msg1: .asciiz "Inserisci una str di numeri crescenti\n"
msg2: .asciiz "Valore : %d\n" ;# val 1° arg msg2

p1sys5: .space 8
conta: .space 8 ;# 1° arg msg2

p1sys3: .word 0 ;#fd null
ind: .space 8
dim: .word 16 ;# numbyte da leggere <= ST

.code
;# init stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s0,$0,0 ;# i=0
do:
    ;# do while ha condizioni i<4 (4 cicli) + strlen==conta (return funzione).
        ;# condizione di incr-salto-fine  a fine do while
    
    ;# printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# scanf ST
    daddi $t0,$0,ST
    sd $t0,ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    ;# passaggio parametri
    move $a1,r1 ;# $a1 = strlen
    daddi $a0,$0,ST ;# $a0 = ST
    jal verifica
    sd r1,conta($0) ;# conta = r1 = return di verifica
    dadd $s1,$0,$a1 ;# $s1 = conta; la uso x 69 while&&
    ;# printf msg2 con 1° arg conta 
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# condizioni di incr-salto-fine
        ;# while(i<4) 
    slti $t0,$s0,4   ;#$t0=0 quando $so(i) >= 4
    beq $t0,$0,exit ;# esce quando $t0=0 ossia $s0(i) >=4
        ;# && while (strlen == conta)
    bne $s1,$a1,exit ;# se sono diversi $s1 (conta) e $a1 (strlen), esce)
    ;# se non sono soddisfatte le condizioni di fine ciclo, allora devo incrementare e fare un altra iterazione
    daddi $s0,$s0,1 ;# i++
    j do
verifica:
    ;#$a0 = ST , $a1 = strlen
    daddi $sp,$sp,-8 ;# 8x1, solo j 
    sd $s2,0($sp) ;# j
    daddi $s2,$0,0 ;# $s2 = j = 0

for_f:  
    ;# incremento di 1, non 8 : devo scorrere una str, non un array di str (*16) o int (*8)
    ;# j ($s2)< strlen ($a1)
    slt $t0,$s2,$a1 ;# $t0=0 quando $s2 (j) >= $a1 (strlen)
    beq $t0,$0,return
    ;# if (st[j] >= st[j+1] --> break
        ;# carico st[j]
    dadd $t0,$a0,$s2 ;# $t0= &st[j] = st ($a0) + j ($s2)
    lbu $t1,0($t0)  ;# $t1 = st[j]
        ;# $s3 = j+1
    daddi $s3,$s2,1
    dadd $t0,$a0,$s3
    lbu $t2,0($t0)  ;# $t2 = st[j+1]

    slt $t0,$t1,$t2 ;# $t0 = 0 quando $t1 (st[j]) >= $t2 (st[j+1])
    beq $t0,$0,return
    ;# se non vado al return, incremento for e salto al for
    daddi $s2,$s2,1 ;#i++
    j for_f
return:
    move r1,$s3 ;# r1 = $s3 (j+1)
    ld $s2,0($sp) 

    daddi $sp,$sp,8
    jr $ra
exit: 
    syscall 0