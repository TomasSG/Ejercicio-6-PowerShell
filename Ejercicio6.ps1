



[cmdletbinding(DefaultParameterSetName="Entrada")]

Param (
        [ValidateNotNullOrEmpty()]
        [parameter(ParameterSetName="Entrada", Mandatory=$true)]
        [parameter(ParameterSetName="Producto", Mandatory=$false)]
        [parameter(ParameterSetName="Suma", Mandatory=$false)]
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




$directorioScript=$(Get-Location)
switch($PSBoundParameters.Keys){
    "entrada"{
            if ( Test-Path "$entrada" -PathType Leaf  ) {
                $vecAux=$entrada.Split("\")
                $nombreArchivo=$vecAux[$vecAux.Count - 1]
                $matrizOriginal,$fil,$col = cargarMatriz $entrada
                escribirMatriz "$directorioScript\salida.$nombreArchivo" $matrizOriginal $fil $col
            } else {
                Write-Host "La dirección '$entrada' no corresponde a un fichero válido"
                exit 1
            }    
    }
    "producto"{
            Write-Host "$producto"
    }
    "suma"{
            if ( Test-Path "$suma" -PathType Leaf  ) {
                Write-Host "Matriz cargada correctamente de $suma"
                
            } else {
                Write-Host "La dirección '$suma' no corresponde a un fichero válido"
                exit 1
            }
    }

}


                
                