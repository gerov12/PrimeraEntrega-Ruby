Directorio models:
En este se encuentran los archivos correspondientes a appointments y professionals los cuales contienen sus respectivas clases. Estas forman parte del modulo Models.

Directorio commands:
En este se encuentran los archivos correspondientes a appointments y professionals los cuales contienen sus respectivas modulos. Estos forman parte del modulo Commands.
Los modulos Appointments y Professionals respectivamente, contienen sublcases de la clase Command. Cada una de estas representa un comando diferente a los cuales su modelo (professional o appointent) debe saber responder, e implementa la respuesta llamando a metodos del modelo que le corresponda. 

Esto es posible ya que tanto el modulo Commands como el modulo Models, forman parte del modulo Polycon, por lo que los metodos de las clases del modulo Commands pueden llamar a los metodos de las clases del modulo Models.


Además se creó el modulo Utils, el cual tambien forma parte del modulo Polycon, por lo que puede ser utilizado por las clases anteriormente mencionadas. Este contiene un metodo que asegura que todo el manejo de directorios y archivos de la aplicación se lleve a cabo en un directorio llamado ".polycon" ubicado en el directorio raíz del usuario.