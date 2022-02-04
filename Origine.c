int verifica(char *st, int d)
{ int j;
for(j=0;j<d;j++)
if(st[j]>=st[j+1])
break;
return j+1;
}
main() {
char STRINGA[16];
int i, conta;
i=0;
do {
printf("Inserisci una stringa di numeri crescenti\n");
scanf("%s",STRINGA);
conta= verifica(STRINGA, strlen(STRINGA));
printf("Valore = %d \n",conta);
i++;
} while (i<4 && strlen(STRINGA)==conta);
}
