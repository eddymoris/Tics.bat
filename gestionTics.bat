:: Autor: Eddy Moris Matos :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Fecha: 10/03/2023	   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
cls
color 30
mode 120, 40
Title Gesti¢n TICs 1.0.0

:: *************************************************************************************
:: Variables que pueden ser utilizadas en alg˙n momento de la ejecuciÛn.
:: *************************************************************************************
	:: Obtiene el nombre del equipo tal cual est· almacenado en el sistema.
	for /f "usebackq skip=1" %%i in (`Wmic ComputerSystem get DNSHostName ^| findstr . ^| More `)do set nombreActual=%%~i
	:: Obtiene el nombre de usuario activo.
	for /f "usebackq skip=1 tokens=2 delims=\" %%i in (`wmic computersystem get username ^| findstr . ^| More `)do set usuario=%%~i
	:: Elimina espacios dentro del nombre de usuario. Los espacios pueden provocar errores.
	set usuario=%usuario: =%
:: *************************************************************************************


:: *************************************************************************************
	:menu
:: *************************************************************************************
	:: Men√∫ principal para elegir opciones ejecutables.
	echo.
	echo Guayaquil, %date% - %time%
	echo.
	echo 		=========================================
	echo 		= 	   Kit de herramientas	    	=
	echo 		=========================================
	echo 		= 					=
	echo 		= 1) Informaci¢n de equipo y usuario	=	
	echo 		= 2) Recurso compartido			=
	echo 		= 3) Registro migraci¢n	(Excel)		=
	echo 		= 4) OCS				=
	echo 		= 5) Cambiar nombre de equipo		=
	echo 		= 6) Agregar equipo a dominio		=
	echo 		= 7) Quitar equipo de dominio		=	
	echo 		= 8) Respaldo de informaci¢n		=
	echo 		= 9) Reiniciar equipo			=
	echo 		= 10) Salir				=
	echo 		= 					=
	echo 		=========================================
	echo.
	echo.
:: *************************************************************************************


:: *************************************************************************************
:: Ingreso de opci√≥n del men√∫ principal y decisi√≥n de ejecuci√≥n sobre la misma.
:: *************************************************************************************
	set /p opcion="Ingresa el n£mero de opci¢n que deseas ejecutar: "

	if %opcion%==1 goto :1informacionEquipoUsuario
	if %opcion%==2 goto :2recursoCompartido
	if %opcion%==3 goto :3registroMigracion
	if %opcion%==4 goto :4ocs
	if %opcion%==5 goto :5cambiarNombreEquipo
	if %opcion%==6 goto :6agregarEquipoDominio
	if %opcion%==7 goto :7quitarEquipoDominio
	if %opcion%==8 (
		cls
		goto :8menuCopiar 
	)
	if %opcion%==9 goto :9reiniciarEquipo
	if %opcion%==10 goto :10fin

	:: Manejo de opci√≥n no v√°lida.
	if %opcion% GTR 10 (
		cls
		echo.
		echo ----------------------------------------- 
		echo [------]Error: ingresa una opci¢n valida.
		echo -----------------------------------------
		echo.
	)
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:1informacionEquipoUsuario
:: *************************************************************************************
	:: Muestra informaci√≥n necesaria para realizar trabajos varios.
	cls
	echo [++++++]Datos del usuario
	echo 		Nombre de usuario: 	%usuario%
	echo.
	echo [++++++]Datos del equipo
	echo 		Nombre de equipo : 	%nombreActual%
	for /f "usebackq skip=1 tokens=* delims= " %%i in (`wmic computersystem get domain ^| findstr . ^| More `)do echo 		Dominio del equipo: 	%%i
	for /f "usebackq skip=1 tokens=* delims= " %%i in (`wmic csproduct get vendor ^| findstr . ^| More `)do echo 		Fabricante del equipo: 	%%i
	for /f "usebackq skip=1 tokens=* delims= " %%i in (`wmic csproduct get name ^| findstr . ^| More `)do echo 		Modelo del equipo: 	%%i
	for /f "usebackq skip=1 tokens=* delims= " %%i in (`wmic csproduct get identifyingnumber ^| findstr . ^| More `)do echo 		S/N del equipo: 	%%i
	echo.
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:2recursoCompartido
:: *************************************************************************************
	:: Abre el explorador de archivos desplegando los directorios creados y asignados
	:: en una direcciÛn de la red gestionada, para que solo usuarios con credenciales
	:: puedan acceder los distintos recursos existente en Èl. 
	cls
	start \\192.168.94.35
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:3registroMigracion
:: *************************************************************************************
	:: Abre un libro de excel donde se registran los datos pertinentes a nuestra gestiÛn.
	cls
	start \\192.168.94.35\Repositorio-TI\"0.- DOCS"\RegistroMigracionEquipos032023final.xlsx
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:4ocs
:: *************************************************************************************
	:: Redirecciona a la direcci√≥n de OCS mediante el navegador predeterminado.
	:: OCS es un software libre que permite a los administradores de TI 
	:: gestionar el inventario de sus activos de TI.
	cls
	start http://192.168.92.55/ocsreports/
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:5cambiarNombreEquipo
:: *************************************************************************************
	:: Cambia el nombre al equipo.
	cls
	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo 		+ Para ejecutar esta acci¢n debes haber ejecutado la aplicaci¢n como administrador +
	echo 		+ Para interrumpir la ejecuci¢n del programa pulsa [ Ctrl+C ] 			   +
	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo.	
	echo [++++++]Nombre actual del equipo: %nombreActual%
	echo.
	set /p "nombre=Ingresa el nuevo nombre del equipo: "
	:: Elimina los espacios en blanco dentro de la variable para evitar errores.
	set nombre=%nombre: =%
	cls
	echo _____________________________________________________________________________
	Wmic ComputerSystem where Name="%COMPUTERNAME%" call rename Name="%nombre%">nul && @echo\≠Cambio de nombre exitoso! Para aplicar los cambios debes reiniciar el equipo. || @echo\≠Cambio de nombre no fue exitoso! Debes ejecutar esta aplicaci¢n como administrador.
	echo _____________________________________________________________________________
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:6agregarEquipoDominio
:: *************************************************************************************
	:: Agrega un equipo a un dominio.
	cls
	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo 		+ Para ejecutar esta acci¢n debes haber ejecutado la aplicaci¢n como administrador +
	echo 		+ Para interrumpir la ejecuci¢n del programa pulsa [ Ctrl+C ] 			   +
	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo.	
	echo [++++++]Esta acci¢n reiniciar† el equipo...
	echo.
	:: Almacena la ruta de la aplicaci√≥n, pero sin el nombre de la misma.
	set ruta=%~d0%~p0
	:: Ejecuta un script de powershell desde este archivo .bat
	@powershell -noninteractive -nologo -noprofile -executionpolicy bypass -command "%ruta%addEqDom.ps1"
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:7quitarEquipoDominio
:: *************************************************************************************
	:: Remueve un equipo de un dominio.
	cls
	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo 		+ Para ejecutar esta acci¢n debes haber ejecutado la aplicaci¢n como administrador +
	echo 		+ Para interrumpir la ejecuci¢n del programa pulsa [ Ctrl+C ] 			   +
	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo.	
	echo [++++++]Esta acci¢n reiniciar† el equipo...
	echo.
	:: Almacena la ruta de la aplicaci√≥n, pero sin el nombre de la misma.
	set ruta=%~d0%~p0
	:: Ejecuta un script de powershell desde este archivo .bat
	@powershell -noninteractive -nologo -noprofile -executionpolicy bypass -command "%ruta%remEqDom.ps1"
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:8menuCopiar
:: *************************************************************************************
	:: Muestra las opciones que el usuario puede elegir para realizar copias de seguridad.
	echo.
	echo 		=================================================================
	echo 		= 	   	    Respaldo de informaci¢n	    		=
	echo 		=================================================================
	echo 		= 								=
	echo 		= 1) Carpetas relevantes de usuario:				=
	echo 		=    (Documentos, Descargas, Escritorio, Imagenes, Videos)	=	
	echo 		= 2) Carpeta Thunderbird					=
	echo 		= 3) Selecci¢n manual desde [ C:\ ]				=
	echo 		= 4) Selecci¢n manual desde [ C:\Users ]			=
	echo 		= 5) Selecci¢n manual desde [ C:\Users\usuario ]		=
	echo 		= 6) Atras							=
	echo 		= 								=
	echo 		=================================================================
	echo.
	echo.
:: *************************************************************************************


:: *************************************************************************************
:: Ingreso de opci√≥n del men√∫ copiar y decisi√≥n de ejecuci√≥n sobre la misma.
:: *************************************************************************************
	set /p opcion="Ingresa el n£mero de opci¢n que deseas ejecutar: "

	if %opcion%==1 goto :8.1copiarRelevantesUsuario
	if %opcion%==2 goto :8.2copiarCarpetaThunderbird
	if %opcion%==3 goto :8.3copiarDesdeRaiz
	if %opcion%==4 goto :8.4copiarDesdeUsers
	if %opcion%==5 goto :8.5copiarDesdeUsuario
	if %opcion%==6 goto :8.6atras

	:: Manejo de opci√≥n no v√°lida.
	if %opcion% GTR 6 (
		cls
		echo.
		echo ----------------------------------------- 
		echo [------]Error: ingresa una opci¢n v†lida.
		echo -----------------------------------------
		echo.
	)
	goto :8menuCopiar
:: *************************************************************************************


:: *************************************************************************************
	:8.1copiarRelevantesUsuario
:: *************************************************************************************
	:: Copiar las carpetas m√°s relevantes del usuario.
	cls
	robocopy "C:\Users\%usuario%\Documents" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\Documents" /s /r:0 /w:0 /MT:24
	robocopy "C:\Users\%usuario%\Downloads" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\Downloads" /s /r:0 /w:0 /MT:24
	robocopy "C:\Users\%usuario%\Desktop" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\Desktop" /s /r:0 /w:0 /MT:24
	robocopy "C:\Users\%usuario%\Pictures" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\Pictures" /s /r:0 /w:0 /MT:24
	robocopy "C:\Users\%usuario%\Videos" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\Videos" /s /r:0 /w:0 /MT:24
	cls
	echo.
	if ERRORLEVEL 5 (
		echo --------------------------------------------- 
		echo [------]Error: Por favor vuelve a intentarlo.
		echo ---------------------------------------------
	)
	if not ERRORLEVEL 5 (
		echo 		[++++++]La copia de seguridad se realiz¢ exitosamente.
		echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		echo 		+ La copia se encuentra en %~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%	+++
      	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	)
	echo.
	goto :8menuCopiar
:: *************************************************************************************


:: *************************************************************************************
	:8.2copiarCarpetaThunderbird
:: *************************************************************************************
	:: Copiar la carpeta Thunderbird que se encuentra en carpetas ocultas de la carpeta de usuario.
	:: Thunderbird es un cliente de correo electÛnico multiplataforma, libre y de cÛdigo abierto.
	cls
	robocopy "C:\Users\%usuario%\AppData\Roaming\Thunderbird" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\Thunderbird" /s /r:0 /w:0 /MT:24
	cls
	echo.
	if ERRORLEVEL 5 (
		echo --------------------------------------------- 
		echo [------]Error: Por favor vuelve a intentarlo.
		echo ---------------------------------------------
	)
	if not ERRORLEVEL 5 (
		echo 		[++++++]La copia de seguridad se realiz¢ exitosamente.
		echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		echo 		+ La copia se encuentra en %~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%	+++
      	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	)
	echo.
	goto :8menuCopiar
:: *************************************************************************************


:: *************************************************************************************
	:8.3copiarDesdeRaiz
:: *************************************************************************************
	:: Copiar informaci√≥n desde la raÌz.
	cls
	cd /
	dir
	echo -----------------------------------------------------------------------------
	set /p opCopiar="Ingresa el nombre del directorio o archivo que deseas copiar: "
	
	robocopy "C:\%opCopiar%" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\%opCopiar%" /s /r:0 /w:0 /MT:24
	cls
	echo.
	if ERRORLEVEL 5 (
		echo --------------------------------------------- 
		echo [------]Error: Por favor vuelve a intentarlo.
		echo ---------------------------------------------
	)
	if not ERRORLEVEL 5 (
		echo 		[++++++]La copia de seguridad se realiz¢ exitosamente.
		echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		echo 		+ La copia se encuentra en %~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%	+++
      	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	)
	echo.
	goto :8menuCopiar
:: *************************************************************************************


:: *************************************************************************************
	:8.4copiarDesdeUsers
:: *************************************************************************************
	:: Copiar informaci√≥n desde la carpeta Users.
	cls
	cd C:\Users
	dir
	echo -----------------------------------------------------------------------------
	set /p opCopiar="Ingresa el nombre del directorio o archivo que deseas copiar: "
	
	robocopy "C:\Users\%opCopiar%" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\%opCopiar%" /s /r:0 /w:0 /MT:24
	cls
	echo.
	if ERRORLEVEL 5 (
		echo --------------------------------------------- 
		echo [------]Error: Por favor vuelve a intentarlo.
		echo ---------------------------------------------
	)
	if not ERRORLEVEL 5 (
		echo 		[++++++]La copia de seguridad se realiz¢ exitosamente.
		echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		echo 		+ La copia se encuentra en %~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%	+++
      	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	)
	echo.
	goto :8menuCopiar
:: *************************************************************************************


:: *************************************************************************************
	:8.5copiarDesdeUsuario
:: *************************************************************************************
	:: Copiar informaci√≥n desde la carpeta de usuario.
	cls
	cd C:\Users\%usuario%
	dir
	echo -----------------------------------------------------------------------------
	set /p opCopiar="Ingresa el nombre del directorio o archivo que deseas copiar: "
	
	robocopy "C:\Users\%usuario%\%opCopiar%" "%~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%\%opCopiar%" /s /r:0 /w:0 /MT:24
	cls
	echo.
	if ERRORLEVEL 5 (
		echo --------------------------------------------- 
		echo [------]Error: Por favor vuelve a intentarlo.
		echo ---------------------------------------------
	)
	if not ERRORLEVEL 5 (
		echo 		[++++++]La copia de seguridad se realiz¢ exitosamente.
		echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		echo 		+ La copia se encuentra en %~d0%~p0%usuario%%date:~-10, 2%%date:~-7, 2%%date:~-4, 4%	+++
      	echo			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	)
	echo.
	goto :8menuCopiar
:: *************************************************************************************


:: *************************************************************************************
	:8.6atras
:: *************************************************************************************
	:: Vuelve un paso atr√°s en la aplicaci√≥n.
	cls
	echo.
	goto :menu
:: *************************************************************************************


:: *************************************************************************************
	:9reiniciarEquipo
:: *************************************************************************************
	:: Reiniciar el equipo.
	shutdown -r -t 0
:: *************************************************************************************


:: *************************************************************************************
	:10fin
:: *************************************************************************************
	:: Sale de la aplicaci√≥n y cierra el CMD.
	exit
:: *************************************************************************************
