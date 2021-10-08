Directorio models:
En este se encuentran los archivos correspondientes a appointments y professionals los cuales contienen sus respectivas clases. Estas forman parte del modulo Models.

Directorio commands:
En este se encuentran los archivos correspondientes a appointments y professionals los cuales contienen sus respectivas modulos. Estos forman parte del modulo Commands.
Los modulos Appointments y Professionals respectivamente, contienen sublcases de la clase Command. Cada una de estas representa un comando diferente a los cuales su modelo (professional o appointent) debe saber responder, e implementa la respuesta llamando a metodos del modelo que le corresponda. 

Esto es posible ya que tanto el modulo Commands como el modulo Models, forman parte del modulo Polycon, por lo que los metodos de las clases del modulo Commands pueden llamar a los metodos de las clases del modulo Models.


Además se creó el modulo Utils, el cual tambien forma parte del modulo Polycon, por lo que puede ser utilizado por las clases anteriormente mencionadas. Este contiene un metodo que asegura que todo el manejo de directorios y archivos de la aplicación se lleve a cabo en un directorio llamado ".polycon" ubicado en el directorio raíz del usuario.


Elecciones de diseño (no definidas en el enunciado original):
- No pueden existir dos directorios para un mismo profesional
- No se puede registrar una cita para un profesional que no existe
- Un profesional no puede tener más de una cita en la misma fecha y hora
- La fecha y hora de las citas que se crean, cancelan o se reprograman deben ser posteriores a la fecha y hora actual (no aplica a listar, mostrar o editar)
- El parametro fecha (en todos los comandos en que se lo utilice) debe seguir el formato "yyyy-mm-dd hh:mm", excepto en el listar, para el cual solo es necesaria la fecha, es decir "yyyy-mm-dd"
- El comando cancel-all borra todas las citas futuras de un profesional, es por esto que para eliminar un profesional solo basta con que no tenga citas futuras (no es necesario que su directorio esté vacío)
- Una cita puede reprogramarse para una fecha previa a la acordada inicialmente, siempre y cuando esta nueva fecha sea posterior a la fecha actual
- Una cita con una fecha anterior o igual a la fecha actual puede reprogramarse, basandose en el caso en el que un cliente o un profesional no hayan podido asistir y quieran reprogramarla para una fecha futura
- Los errores por no respetar el orden y la cantidad de parametros de los comandos no los modifiqué, las alertas se muestran en consola como fueron configuradas originalmente