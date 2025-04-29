# // Principio de Computadores.
# // Operaciones con funciones y direccionamiento indirecto
# // Autores: Carlos Martín Galán y Alberto Hamilton Castro
# // Fecha última modificación: 2025-04-11
# #include <iostream>

# const int n1 = 10;
# double v1[n1] = {10.5, 9.5, 7.25, 6.25, 5.75, 4.5, 4.25, 3.5, -1.5, -2.0};
# const int n2 = 5;
# double v2[n2] = {5.5, 4.5, 4.25, 2.5, 2.5 };
# const int n3 = 4;
# double v3[n3] = {7.0, 5.0, 2.0, 1.0};


# void printvec(double* v, const int n) {
#     std::cout << "\nVector con dimension " << n << '\n';
#     for (int i = 0; i < n; i++)
#         std::cout << v[i] << " ";

#     std::cout << "\n";
#     return;
# }

# int ordenado(double* v, const int n) {
#     int resultado = 1;
#     int i = 0;
#     while (i < n-1) {
#         if (v[i+1] >= v[i]) {
#             resultado = 0;
#             break;
#         }
#         i++;
#     }
#     return resultado;
# }

# void merge(double* v1, const int n1,double* v2, const int n2) {

#     int  o1 = ordenado(v1,n1);
#     if (o1 == 0) {
#       std::cout << "Primer vector no ordenado. NO se puede mezclar\n";
#       return;
#     }
#     int o2 = ordenado(v2,n2);
#     if (o2 == 0) {
#       std::cout << "Segundo vector no ordenado. NO se puede mezclar\n";
#       return;
#     }
#     int i = 0; // índice para recorrer el v1
#     int j = 0; // índice para recorrer el v2
#     while ( ( i < n1) && (j < n2) ) {
#         if (v1[i] >= v2[j]) {
#             std::cout << v1[i] << ' ';
#             i++;
#         }
#         else {
#             std::cout << v2[j] << ' ';
#             j++;
#         }
#     }
#     while ( i < n1) {
#         std::cout << v1[i] << ' ';
#         i++;
#     }
#     while ( j < n2) {
#         std::cout << v2[j] << ' ';
#         j++;
#     }
#     std::cout << '\n';
#     return;
# }

# int main(void) {
#   std::cout << "\nPrograma de mezcla de vectores\n";

#   printvec(v1,n1);
#   printvec(v2,n2);
#   printvec(v3,n3);

#   std::cout << "\nIntentando mezcla con dos vectores ...\n";
#   merge(v1,n1,v2,n2);

#   std::cout << "\nIntentando mezcla con dos vectores ...\n";
#   merge(v1,n1,v3,n3);

#   std::cout << "\nIntentando mezcla con dos vectores ...\n";
#   merge(v2,n2,v3,n3);

#   std::cout << "\nFIN DEL PROGRAMA\n";
#   return 0;
# }

sizeD = 8

    .data
n1:     .word 10
v1:     .double 10.5, 9.5, 7.25, 6.25, 5.75, 4.5, 4.25, 3.5, -1.5, -2.0
n2:     .word 5
v2:     .double 5.5, 4.5, 4.25, 2.5, 2.5
n3:     .word 4
v3:     .double 7.0, 5.0, 2.0, 1.0

cad0:	.asciiz	"\nPrograma de mezcla de vectores\n"
cad1:   .asciiz "\nVector con dimension "
cad51:	.asciiz	"Primer vector no ordenado. NO se puede mezclar\n"
cad52:	.asciiz	"Segundo vector no ordenado. NO se puede mezclar\n"
cad2:   .asciiz "\nIntentando mezcla con dos vectores ...\n"
cad3:   .asciiz "\nFIN DEL PROGRAMA\n"

#######################################################################################
# void printvec(double* v, const int n) {

# Parametros de entrada:
# double* v -> $a0
# int n -> $a1

# Parametros de salida:
# Ninguno

# Esta funcion llama a otra -> Usar pila

# int i -> $s0
# v -> $a0 pasarlo a $s1
# n -> $a1 pasarlo a $s2

printvec:
        #PUSH ra, s0, s1, s2: 4 registros x 4 bytes = 16
        addi    $sp,$sp,-16
        sw      $ra,0($sp)
        sw      $s0,4($sp)
        sw      $s1,8($sp)
        sw      $s2,12($sp)

        move    $s1,$a0
        move    $s2,$a1
        li      $s0,0
        
#     std::cout << "\nVector con dimension " << n << '\n';
        li      $v0,4
        la      $a0,cad1
        syscall

        li      $v0,1
        move    $a0,$s2
        syscall

        li      $v0,11
        li      $a0,10
        syscall

#     for (int i = 0; i < n; i++)
for_print_vec:
        bge     $s0,$s2,for_print_vec_fin

#         std::cout << v[i] << " ";
        mul     $t0,$s0,sizeD  
        add     $t0,$s1,$t0
        l.d     $f12,0($t0)

        li      $v0,3
        syscall

        li      $v0,11
        li      $a0,32
        syscall

        addi    $s0,$s0,1

        j       for_print_vec

#     std::cout << "\n";
        li      $v0,11
        li      $a0,10
        syscall

for_print_vec_fin:
#     return;
# }
        #POP ra, s0, s1, s2: 4 registros x 4 bytes = 16
        lw      $ra,0($sp)
        lw      $s0,4($sp)
        lw      $s1,8($sp)
        lw      $s2,12($sp)
        addi    $sp,$sp,16

        jr      $ra

printvec_fin:
#######################################################################################


#######################################################################################
# int ordenado(double* v, const int n) {
# Parametros de entrada:
# double* v -> $a0
# int n -> $a1

# Parametros de salida:
# resultado -> $v0

# Esta funcion no llama a otra -> No usar pila

# int resultado -> $t0
# int i -> $t1
# v -> $a0
# n -> $a1

ordenado:
#     int resultado = 1;
        li      $t0,1

#     int i = 0;
        li      $t1,0

#     while (i < n-1) {
while_ordenado:
        sub     $t2,$a1,1
        bge     $t1,$t2,while_ordenado_fin

#         if (v[i+1] >= v[i]) {
if_ordenado:
        add     $t3,$t1,1

        mul     $t4,$t3,sizeD
        add     $t4,$a0,$t4
        l.d     $f4,0($t4)

        mul     $t6,$t1,sizeD  
        add     $t6,$a0,$t6
        l.d     $f6,0($t6)

        c.lt.d  $f4,$f6
        bc1t    if_ordenado_fin

#             resultado = 0;
        li      $t0,0

#             break;
        j       while_ordenado_fin
#         }
if_ordenado_fin:
        addi    $t1,$t1,1
#         i++;

        j       while_ordenado
#     }
while_ordenado_fin:
#     return resultado;
        move    $v0,$t0
        jr      $ra
# }
ordenado_fin:
#######################################################################################


#######################################################################################

# void merge(double* v1, const int n1,double* v2, const int n2) {
# Tabla de paso de argumentos:
# double* v1 = $a0
# const int n1 = $a1
# double* v2 = $a2
# const int n2 = $a3

# Tabla de valores de retorno:
# Esta funcion no retorna nada

# Esta funcion llama a syscall o otra funcion por lo que usa la pila

# Tabla de variables locales:
# int o1 = $s0
# int o2 = $s1
# int i = $s2
# int j = $s3
# v1 = $s4
# v2 = $s5
# n1 = $s6
# n2 = $s7

merge:
#       PUSH:  ra,o1,o2,i,j,v1,v2,n1,n2, 8 x 4 bytes = 36
        addi    $sp,$sp,-32
        sw      $ra,0($sp)
        sw      $s0,4($sp)
        sw      $s1,8($sp)
        sw      $s2,12($sp)
        sw      $s3,16($sp)
        sw      $s4,20($sp)
        sw      $s5,24($sp)
        sw      $s6,28($sp)
        sw      $s7,32($sp)

        move    $s4,$a0
        move    $s5,$a1
        move    $s6,$a2
        move    $s7,$a3

#     int  o1 = ordenado(v1,n1);
        move    $a0,$s4
        move    $a1,$s6
        jal     ordenado
        move    $s0,$v0
        
#     if (o1 == 0) {
merge_if:
        bnez    $s0,merge_if_fin

#       std::cout << "Primer vector no ordenado. NO se puede mezclar\n";
        li      $v0,4
        la      $a0,cad51
        syscall

        j       merge_pop
#       return;
#     }
merge_if_fin:
#     int o2 = ordenado(v2,n2);
        move    $a0,$s5
        move    $a1,$s7
        jal     ordenado
        move    $s1,$v0    

merge_segundo_if:
#     if (o2 == 0) {
        bnez    $s1,merge_segundo_if_fin

#       std::cout << "Segundo vector no ordenado. NO se puede mezclar\n";
        li      $v0,4
        la      $a0,cad52
        syscall

#       return;
        j merge_pop
#     }

merge_segundo_if_fin:
#     int i = 0; // índice para recorrer el v1
        li      $s2,0

#     int j = 0; // índice para recorrer el v2
        li      $s3,0

merge_primer_while:
#     while ( ( i < n1) && (j < n2) ) {
        bge     $s2,$s6,merge_primer_while_fin
        bge     $s3,$s7,merge_primer_while_fin

merge_if_dentro_primer_while:
#         if (v1[i] >= v2[j]) {
        mul     $t0,$s2,sizeD
        add     $t0,$s4,$t0
        l.d     $f16,0($t0)

        mul     $t1,$s3,sizeD
        add     $t1,$s5,$t1
        l.d     $f14,0($t1)

        c.lt.d  $f16,$f14
        bc1t    merge_if_dentro_primer_while_fin

#             std::cout << v1[i] << ' ';
        li      $v0,3
        mov.d   $f12,$f16
        syscall

        li      $v0,11
        li      $a0,32
        syscall

#             i++;
        addi    $s2,$s2,1
        j       merge_primer_while
#         }

merge_if_dentro_primer_while_fin:
#         else {
#             std::cout << v2[j] << ' ';
        li      $v0,3
        mov.d   $f12,$f14
        syscall

        li      $v0,11
        li      $a0,32
        syscall

#             j++;
        addi    $s3,$s3,1
#         }
#     }
merge_primer_while_fin:

merge_segundo_while:
#     while ( i < n1) {
        bge     $s2,$s6,merge_segundo_while_fin

#         std::cout << v1[i] << ' ';
        li      $v0,3
        mov.d   $f12,$f16
        syscall

        li      $v0,11
        li      $a0,32
        syscall

#         i++;
        addi    $s3,$s3,1

        j merge_segundo_while
#     }
merge_segundo_while_fin:

merge_tercer_while:
#     while ( j < n2) {
        bge     $s3,$s7,merge_tercer_while_fin

#         std::cout << v2[j] << ' ';
        li      $v0,3
        mov.d   $f12,$f14
        syscall

        li      $v0,11
        li      $a0,32
        syscall

#         j++;
        addi    $s3,$s3,1
#     }
#     std::cout << '\n';
        li      $v0,11
        li      $a0,10
        syscall

#     return;
        j       merge_pop       
# }
merge_tercer_while_fin:

merge_pop:

#       POP:
        lw      $ra,0($sp)
        lw      $s0,4($sp)
        lw      $s1,8($sp)
        lw      $s2,12($sp)
        lw      $s3,16($sp)
        lw      $s4,20($sp)
        lw      $s5,24($sp)
        lw      $s6,28($sp)
        lw      $s7,32($sp)
        addi    $sp,$sp,32



merge_fin:
#######################################################################################


#######################################################################################
# int main(void) {
main:

#   std::cout << "\nPrograma de mezcla de vectores\n";
        li      $v0,4
        la      $a0,cad0
        syscall

#   printvec(v1,n1);
        lw      $a0,v1
        la      $a1,n1
        jal     printvec

#   printvec(v2,n2);
        lw      $a0,v2
        la      $a1,n2
        jal     printvec

#   printvec(v3,n3);
        lw      $a0,v3
        la      $a1,n3
        jal     printvec

#   std::cout << "\nIntentando mezcla con dos vectores ...\n";
        li      $v0,4
        la      $a0,cad2
        syscall

#   merge(v1,n1,v2,n2);
        lw      $a0,v1
        la      $a1,n1
        lw      $a0,v2
        la      $a1,n2
        jal     merge

#   std::cout << "\nIntentando mezcla con dos vectores ...\n";
        li      $v0,4
        la      $a0,cad2
        syscall

#   merge(v1,n1,v3,n3);
        lw      $a0,v1
        la      $a1,n1
        lw      $a0,v3
        la      $a1,n3
        jal     merge

#   std::cout << "\nIntentando mezcla con dos vectores ...\n";
        li      $v0,4
        la      $a0,cad2
        syscall

#   merge(v2,n2,v3,n3);
        lw      $a0,v2
        la      $a1,n2
        lw      $a0,v3
        la      $a1,n3
        jal     merge

#   std::cout << "\nFIN DEL PROGRAMA\n";
        li      $v0,4
        la      $a0,cad3
        syscall

#   return 0;
        li      $v0,10
        syscall
# }