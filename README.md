# Proyecto: Módulo 2 – Keygen Básico

## Datos del alumno

- **Materia:** Lenguajes de Interfaz
- **Alumno:** Guzmán Ávila Jesús Antonio 22490399
- **Carrera:** Ingeniería en Sistemas Computacionales
- **Proyecto:** Módulo 2 – Keygen Básico

## 1. Descripción del proyecto

Este proyecto consiste en desarrollar un generador básico de claves utilizando lenguaje ensamblador x86-64 en Windows. El programa solicita al usuario un nombre, calcula la suma de los valores ASCII de sus caracteres y aplica una operación XOR con el valor hexadecimal `0ABCD`.

La clave generada se muestra en la consola como un número hexadecimal de 16 dígitos, utilizando letras mayúsculas y ceros a la izquierda cuando sea necesario.

## 2. Objetivos

- Capturar el nombre introducido por el usuario.
- Calcular la suma de los valores ASCII de los caracteres.
- Aplicar la operación XOR con el valor `0ABCD` para generar la clave.
- Mostrar el resultado en formato hexadecimal de 16 dígitos.
- Rechazar entradas vacías y nombres que superen los 64 caracteres.
- Utilizar las funciones de Windows `ReadConsoleA`, `WriteConsoleA` y `GetStdHandle`.

## 3. Herramientas utilizadas

- **UASM64:** ensamblador para generar el archivo objeto.
- **GoLink:** enlazador para crear el ejecutable.
- **Windows CMD:** consola para compilar y ejecutar el programa.
- **kernel32.dll:** biblioteca de Windows que contiene las funciones de consola utilizadas.

## 4. Funcionamiento del programa

El programa realiza los siguientes pasos:

1. Obtiene los identificadores de entrada y salida de la consola.
2. Solicita al usuario que escriba su nombre.
3. Lee la entrada y elimina el retorno de carro y el salto de línea cuando están presentes.
4. Comprueba que el nombre no esté vacío y que no supere los 64 caracteres.
5. Suma los valores ASCII de los caracteres introducidos.
6. Aplica la operación XOR con `0ABCD`.
7. Convierte el resultado a hexadecimal y lo muestra con 16 dígitos.

### Ejemplo de cálculo

Para el nombre `Ana`:

- `A` = 65
- `n` = 110
- `a` = 97

La suma ASCII es:

`65 + 110 + 97 = 272`

El valor 272 en hexadecimal es `0110`. Al aplicar XOR con `ABCD`, el resultado es `AADD`.

Por lo tanto, la clave esperada es:

`000000000000AADD`

## 5. Compilación y ejecución

Abrir CMD en la carpeta donde se encuentran los archivos del proyecto.

### Ensamblar el código

```bat
uasm64 -win64 keygen_apellido_nombre.asm
```

### Enlazar el archivo objeto

```bat
GoLink.exe keygen_apellido_nombre.obj kernel32.dll /fo keygen_apellido_nombre.exe /console /entry main
```

### Ejecutar el programa

```bat
keygen_apellido_nombre.exe
```

## 6. Conclusión

Este proyecto permite practicar el uso de registros, operaciones aritméticas y lógicas, recorridos de memoria y llamadas a funciones de Windows desde lenguaje ensamblador x86-64. También permite comprender cómo transformar una entrada de texto en una clave hexadecimal mediante el cálculo de valores ASCII y una operación XOR.