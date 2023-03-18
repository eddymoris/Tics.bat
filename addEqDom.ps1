# Se llama desde :6agregarEquipoDominio en el archivo .bat 
# Almacena el nombre del equipo en una variable.
$nombreEquipo = get-content env:computername

# Agrega el equipo al dominio especificado. 
# Se ejecutará solo si se introduce la contraseña del usuario especificado.
# Si la autenticación es correcta, reiniciará forzosamente el equipo.
Add-Computer -ComputerName "$nombreEquipo" -DomainName "GUA.LOCAL" -Credential gua\userx1 -Restart -Force