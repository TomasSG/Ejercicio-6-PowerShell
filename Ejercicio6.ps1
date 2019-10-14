<#
.SYNOPSIS
    Permita realizar producto escalar y suma de matrices. La entrada de la matriz al script se realizará mediante un archivo de texto plano. 
    La salida se guardará en otro archivo que se llamará “salida.nombreArchivoEntrada” en el mismo directorio donde se encuentra el script
.DESCRIPTION
    *Nombre Script: Ejercicio6.ps1
    *Trabajo Práctico nro: 2
    *Ejercicio nro: 6
    *Integrantes:
        .Giselle González - 41292355
        .Tomas Grigioni - 41589109
        .Alan Rossi - 37250221
        .Lautaro Costa - 36396983
        .Diego Stanko - 39372117
    *Primera entrega

.PARAMETER Entrada
    Path del archivo donde esta cargada la matriz.
.PARAMETER Producto
    Entero para realizar el producto escalar con la matriz especificada en -Entrada. No se puede usar con -Suma
.PARAMETER Suma
    Path del archivo de la matriz a sumar a la indicada en -Enrada. No se puede usarjunto con -Producto
.PARAMETER Help
    Cuando se lo explicitad se indica el número de versióny las formasde llamar al script

.EXAMPLE
    Ejercicio6.ps1 -Entrada .\matrizEjemplo.txt -Suma .\matrizEjemploSuma.txt
#>



[cmdletbinding(DefaultParameterSetName="Suma")]


Param (
        [ValidateNotNullOrEmpty()]
        [parameter(ParameterSetName="Producto", Mandatory=$true, Position = 1)]
        [parameter(ParameterSetName="Suma", Mandatory=$true, Position = 1)]
        [String]
        $entrada,
        [ValidateNotNull()]
        [parameter(ParameterSetName="Producto",Mandatory=$true, Position = 2)]
        [int]
        $producto,
        [ValidateNotNullOrEmpty()]
        [parameter(ParameterSetName="Suma", Mandatory=$true, Position = 2)]
        [String]
        $suma,
        [parameter(ParameterSetName="Ayuda", Mandatory=$true, Position=1)]
        [switch]
        $help
        )



<#
.SYNOPSIS
    Dado un archivo de entrada genera y carga una matriz
.DESCRIPTION
    Dado un archivo que contenga los elementos de una matriz con la siguiente estructura:
        Los elementos de una misma fila separados por | y las filas separados por /n.
    Se genera una matriz con las dimensiones necesarias y carga los datos en esa nueva matriz. La función retorna la matriz 
    creada, la cantidad de filas ,y por último, la cantidad de columnas
.PARAMETER Path
    Dirección de fichero con los datos, no se hara ninguna validación entonces se debe asegurar que la dirección sea correcta 
    previamente al llamado de dicha función
#>
function cargarMatriz([String] $path){
    $cantFil=0
    $cantCol=0
    Get-Content "$path" | % { $cantFil++}
    Get-Content "$path" | Select-Object -first 1 | ForEach-Object -Process { $cantCol=$_.Split("|").count } 
    $mat=New-Object 'Object[,]' $cantFil,$cantCol
    $i=0
    $j=0 
    Get-Content "$path" | ForEach-Object {
        Foreach ( $var in $($_.Split("|")) ) {
            $mat[$i,$j] = $var -as [double]
            $j++ 
        }
        $j=0
        $i++
    }
    return $mat,$cantFil,$cantCol
}

<#
.SYNOPSIS
    Dado un archivo de salida y una matriz, escribe en el fichero la matriz
.DESCRIPTION
    Dado un archivo y una matriz, se escirbe en el archiovo la matriz especeificada. El separadaro entre elementos de la misma fila es el "|" y el separadaor de columnas
    es el salto de línea "\n".
    Si ya existe el fichero donde se va a escribir, el nuevo archivo va a pisar al viejo
.PARAMETER Path
    Dirección de fichero donde escribir la matriz
.PARAMETER Mat
    Matriz a escribir
.PARAMETER Fil
    Cantidad de filas de la matriz
.PARAMETER Col
    Cantidad de columnas de la matriz
#>
function escribirMatriz([String] $path, $mat, [int] $fil, [int] $col){
    if ( Test-Path "$path" -PathType Leaf){
        Remove-Item -Path "$path"
    }
    $resultado=""
    foreach ( $i in 0..($fil-1)){
        foreach ($j in 0..($col-1)){
            if($j -eq ($col-1) ){
                $resultado+="$($mat[$i,$j])"
            }else {
                $resultado+="$($mat[$i,$j])|"
            } 
        }
        $resultado+="`n" 
    }
    $resultado|Out-File -FilePath "$path"
}

<#
.SYNOPSIS
    Dada dos matrices y sus respectivas filas y columnas, guarda en una nueva matriz el resultado de la suma
.DESCRIPTION
    La función no realiza el control de que las dimensionas coincidan entonces se tiene que realizar previamente a su llamada.
    A partir de las matrices y sus respectivas filas y columnas, se genera una matriz con las dimensiones correspondientes. En la matriz resultado se guarda la suma
    de las otras dos matrices.
    La función retorna la matriz resultado, la cantidad de filas y columnas
.PARAMETER Matriz1
    La primera matriz a sumar
.PARAMETER Fil1
    La cantidad de filas de la primera matriz
.PARAMETER Col1
    La cantidad de columnas de la primera matriz
.PARAMETER Matriz2
    La segunda matriz a sumar
.PARAMETER Fil2
    La cantidad de filas de la segunda matriz
.PARAMETER Col2
    La cantidad de columnas de la segunda matriz
#>
function sumarMatrices($matriz1,[int] $fil1, [int] $col1, $matriz2, [int] $fil2, [int] $col2){
    $matRes = New-Object 'Object[,]' $fil1,$col1
    foreach ( $i in 0..($fil1 -1 ) ){
        foreach ($j in 0..($col1 - 1) ){
            $matRes[$i,$j]= $matriz1[$i,$j]+$matriz2[$i,$j] -as [double]
        }
    }
    return $matRes,$fil1,$col1
}

<#
.SYNOPSIS
   Dada una matriz, la cantidad de filas y de columnas y un escalar, se guarda en una nueva matriz el producto escalar.
.DESCRIPTION
    A partir de la matriz dada y el escalar, se genera una nueva matriz con sus respectivas dimensiones donde se guarda el resultado del producto escalar
    La función retorna la matriz resultado, la cantidad de filas y columnas
.PARAMETER Matriz
   La matriz con la cual se realiza el producto escalar
.PARAMETER Fil
   Cantidad de filas de la matriz
.PARAMETER Col
   Cantidad de columnas de la matriz
.PARAMETER Escalar
   El escalar con el cual se realiza el producto escalar
#>
function productoMatriz($matriz, [int] $fil, [int] $col, [int] $escalar){
    $matRes = New-Object 'Object[,]' $fil,$col
    foreach ( $i in 0..($fil -1 ) ){
        foreach ($j in 0..($col - 1) ){
            $matRes[$i,$j]= $matriz[$i,$j]*$escalar -as [double]
        }
    }
    return $matRes,$fil,$col
}



#$directorioScript=$(Get-Location)
$directorioScript= $($MyInvocation.MyCommand.path | Split-path)
switch($PSBoundParameters.Keys){

     "producto"{
            if(! $matrizOriginal ){
                Write-Host "Pimero se debe especificar -entrada"
                exit 0
            }
            $matrizProducto,$filP,$colP = productoMatriz $matrizOriginal $fil $col $producto
            escribirMatriz "$directorioScript\salida.$nombreArchivo" $matrizProducto $filP $colP
            exit 1
    }

    "suma"{
            if(! $matrizOriginal ){
                Write-Host "Pimero se debe especificar -entrada"
                exit 0
            }
            if ( Test-Path "$suma" -PathType Leaf  ) {
                $matrizSuma,$filS,$colS = cargarMatriz $suma
                if(  $filS -ne $fil -or $colS -ne $col ) {
                    Write-Host "Las dimensiones de las matrices no coinciden"
                    exit 0
                }
                $matrizResultado,$filR,$colR = sumarMatrices $matrizOriginal $fil $col $matrizSuma $filS $colS 
                escribirMatriz "$directorioScript\salida.$nombreArchivo" $matrizResultado $filR $colR
                exit 1
            } else {
                Write-Host "La dirección '$suma' no corresponde a un fichero válido"
                exit 0
            }
    }

    "help"{
        Write-Host "Numero de versión : 1.0"
        Write-Host "Ejemplo de llamadas:"
        Write-Host "1) Suma: .\Ejercicio6.ps1 -Entrada .\matrizEjemplo1.txt -Suma \matrizEjemploSuma1.txt"
        Write-Host "2) Producto: .\Ejercicio6.ps1 -Entrada .\matrizEjemplo1.txt -Producto 3"
        exit 1
    }

    "entrada"{
        if ( Test-Path "$entrada" -PathType Leaf  ) {
            $vecAux=$entrada.Split("\")
            $nombreArchivo=$vecAux[$vecAux.Count - 1]
            $matrizOriginal,$fil,$col = cargarMatriz $entrada
        } else {
            Write-Host "La dirección '$entrada' no corresponde a un fichero válido"
            exit 0
        }
    }

    default{
        Write-Host "Error en llamada!"
        Write-Host "Usos:"
        Write-Host "1) Suma: .\Ejercicio6.ps1 -Entrada .\matrizEjemplo1.txt -Suma \matrizEjemploSuma1.txt"
        Write-Host "2) Producto: .\Ejercicio6.ps1 -Entrada .\matrizEjemplo1.txt -Producto 3"
        exit 0
    }

}


                
                