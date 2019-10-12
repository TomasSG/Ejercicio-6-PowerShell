
[cmdletbinding(DefaultParameterSetName="Entrada")]

Param (
        [ValidateNotNullOrEmpty()]
        [parameter(ParameterSetName="Entrada")]
        [parameter(ParameterSetName="Producto")]
        [parameter(ParameterSetName="Suma")]
        [String]
        $entrada,
        [ValidateNotNull()]
        [parameter(ParameterSetName="Producto")]
        [int]
        $producto,
        [ValidateNotNullOrEmpty()]
        [parameter(ParameterSetName="Suma")]
        [String]
        $suma
        )

switch($PSBoundParameters.Keys){
    "entrada"{
            if ( Test-Path "$entrada" -PathType Leaf  ) {
                Write-Host "Matriz cargada correctamente de $entrada"
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

<#
.SYNOPSIS
    Dado un archivo de entrada genera y carga una matriz
.DESCRIPTION
    Dado un archivo que contenga los elementos de una matriz con la siguiente estructura:
        Los elementos de una misma fila separados por | y las filas separados por /n.
    Se genera una matriz con las dimensiones necesarias y carga los datos en esa nueva matriz. La función retorna la matriz 
    creada.
.PARAMETER
    Dirección de fichero con los datos, no se hara ninguna validación entonces se debe asegurar que la dirección sea correcta 
    previamente al llamado de dicha función
#>
function cargarMatriz([String] $path){
    Get-Content "$path" | ForEach-Object {
        $OFSViejo=$OFS
        $OFS='|'
        Foreach ( $i in $_ ) {
            
        }
        $OFS=$OFSViejo          
    }
}
                
                