# Se llama desde :6quitarEquipoDominio en el archivo .bat
# Almacena el nombre del equipo en una variable.
$nombreEquipo = get-content env:computername

# Remueve el equipo del dominio especificado. 
# Se ejecutará solo si se introduce la contraseña del usuario especificado.
# Si la autenticación es correcta, reiniciará forzosamente el equipo.
Remove-Computer -ComputerName "$nombreEquipo" -Credential gua\userx1 -Restart -Force
