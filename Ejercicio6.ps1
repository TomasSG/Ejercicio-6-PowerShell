



[cmdletbinding(DefaultParameterSetName="Entrada")]

Param (
        [ValidateNotNullOrEmpty()]
        [parameter(ParameterSetName="Entrada", Mandatory=$true , Position = 1)]
        [parameter(ParameterSetName="Producto", Mandatory=$false, Position = 1)]
        [parameter(ParameterSetName="Suma", Mandatory=$false, Position = 1)]
        [String]
        $entrada,
        [ValidateNotNull()]
        [parameter(ParameterSetName="Producto",Mandatory=$true)]
        [int]
        $producto,
        [ValidateNotNullOrEmpty()]
        [parameter(ParameterSetName="Suma", Mandatory=$true)]
        [String]
        $suma
        )



<#
.SYNOPSIS
    Dado un archivo de entrada genera y carga una matriz
.DESCRIPTION
    Dado un archivo que contenga los elementos de una matriz con la siguiente estructura:
        Los elementos de una misma fila separados por | y las filas separados por /n.
    Se genera una matriz con las dimensiones necesarias y carga los datos en esa nueva matriz. La función retorna la matriz 
    creada, la cantidad de filas ,y por último, la cantidad de columnas
.PARAMETER
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
.PARAMETER
    Dirección de fichero donde escribir, la cantidad de filas que contiene la matriz, la cantidad de columnas y la matriz a cargar.
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
.PARAMETER
    $matriz1 --> La primera matriz a sumar
    $fil1 --> La cantidad de filas de la primera matriz
    $col1 --> La cantidad de columnas de la primera matriz
    $matriz2 --> La segunda matriz a sumar
    $fil2 --> La cantidad de filas de la segunda matriz
    $col2 --> La cantidad de columnas de la segunda matriz
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
.PARAMETER
   $matriz --> La matriz con la cual se realiza el producto escalar
   $fil --> Cantidad de filas de la matriz
   $col --> Cantidad de columnas de la matriz
   $escalar --> El escalar con el cual se realiza el producto escalar
#>
function productoMatriz($matriz, [int] $fil, [int] $col, [double] $escalar){
    $matRes = New-Object 'Object[,]' $fil,$col
    foreach ( $i in 0..($fil -1 ) ){
        foreach ($j in 0..($col - 1) ){
            $matRes[$i,$j]= $matriz[$i,$j]*$escalar -as [double]
        }
    }
    return $matRes,$fil,$col
}



$directorioScript=$(Get-Location)
switch($PSBoundParameters.Keys){
    "entrada"{
            if ( Test-Path "$entrada" -PathType Leaf  ) {
                $vecAux=$entrada.Split("\")
                $nombreArchivo=$vecAux[$vecAux.Count - 1]
                $matrizOriginal,$fil,$col = cargarMatriz $entrada
            } else {
                Write-Host "La dirección '$entrada' no corresponde a un fichero válido"
                exit 1
            }    
    }
    "producto"{
            if ( ! $matrizOriginal ){
                Write-Host "Aún no se epsecificó la matriz original"
                exit 1
            }
            $matrizProducto,$filP,$colP = productoMatriz $matrizOriginal,$fil,$col,$producto
            escribirMatriz "$directorioScript\salida.$nombreArchivo" $matrizProducto $filP $colP
    }
    "suma"{
            if ( Test-Path "$suma" -PathType Leaf  ) {
                if ( ! $matrizOriginal ) {
                    Write-Host "Aún no se especificó la matriz original"
                    exit 1
                }
                $matrizSuma,$filS,$colS = cargarMatriz $suma
                if( ! $filS -eq $fil -and ! $colS -eq $col ) {
                    Write-Host "Las dimensiones de las matrices no coinciden"
                    exit 1
                }
                $matrizResultado,$filR,$colR = sumarMatrices $matrizOriginal $fil $col $matrizSuma $filS $colS 
                escribirMatriz "$directorioScript\salida.$nombreArchivo" $matrizResultado $filR $colR
            } else {
                Write-Host "La dirección '$suma' no corresponde a un fichero válido"
                exit 1
            }
    }

}


                
                