# Ejericio-6-PowerShell

Resolución del punto 6 del trabajo práctico de PowerShell. Consigna:

Desarrollar un script que permita realizar producto escalar y suma de matrices. La entrada de la matriz al script se realizará mediante un archivo de texto plano. La salida se guardará en otro archivo que se llamará “salida.nombreArchivoEntrada” en el mismo directorio donde se encuentra el script. El formato de los archivos de matrices debe ser el siguiente:

0|1|2

1|1|1

-3|-3-|1


Parámetros que recibirá el script:

• -Entrada: Path del archivo de entrada. No se debe realizar validación por extensión de archivo. Se asume que todos los archivos de entrada tienen matrices válidas.

• -Producto: De tipo entero, recibe el escalar a ser utilizado en el producto escalar. No se puede usar junto con “-Suma”.

• -Suma: Path del archivo de la matriz a sumar a la indicada en “-Entrada”. No se puede usar junto con “-Producto”.

***Criterios de corrección: Control Criticidad***

1.Debe cumplir con el enunciado

2.El script cuenta con una ayuda visible con Get-Help

3.Validación correcta de los parámetros

4.Se deben respetar los nombres y tipos de los parámetros

5.Crear grupos de parámetros (ParameterSetName)

6.Se debe respetar el nombre del archivo de salida

7.La matriz puede contener cualquier “double” válido

8.Los paths recibidos por parámetro pueden ser absolutos o relativos
