## PRIMERA ENTREGA:
###### Directorio models:
En este se encuentran los archivos correspondientes a **appointments** y **professionals** los cuales contienen sus respectivas clases. Estas forman parte del **modulo Models**.

###### Directorio commands:
En este se encuentran los archivos correspondientes a **appointments** y **professionals** los cuales contienen sus respectivas modulos. Estos forman parte del **modulo Commands**.
Los modulos Appointments y Professionals respectivamente, contienen *sublcases de la clase Command*. Cada una de estas representa un comando diferente a los cuales su modelo (professional o appointent) debe saber responder, e implementa la respuesta llamando a metodos del modelo que le corresponda. 

Esto es posible ya que tanto el modulo Commands como el modulo Models, forman parte del **modulo Polycon**, por lo que los metodos de las clases del modulo Commands pueden llamar a los metodos de las clases del modulo Models.


Además se creó el modulo **Utils**, el cual tambien forma parte del **modulo Polycon**, por lo que puede ser utilizado por las clases anteriormente mencionadas. Este contiene un metodo que asegura que todo el manejo de directorios y archivos de la aplicación se lleve a cabo en un directorio llamado *".polycon"* ubicado en el directorio raíz del usuario.


###### Elecciones de diseño (no definidas en el enunciado original):
- No pueden existir dos directorios para un mismo profesional
- No se puede registrar una cita para un profesional que no existe
- Un profesional no puede tener más de una cita en la misma fecha y hora
- La fecha y hora de las citas que se crean, cancelan o se reprograman deben ser posteriores a la fecha y hora actual (no aplica a listar, mostrar o editar)
- El parametro fecha (en todos los comandos en que se lo utilice) debe seguir el formato "yyyy-mm-dd hh:mm", excepto en el listar, para el cual solo es necesaria la fecha, es decir "yyyy-mm-dd"
- El comando cancel-all borra todas las citas futuras de un profesional, es por esto que para eliminar un profesional solo basta con que no tenga citas futuras (no es necesario que su directorio esté vacío)
- Una cita puede reprogramarse para una fecha previa a la acordada inicialmente, siempre y cuando esta nueva fecha sea posterior a la fecha actual
- Una cita con una fecha anterior o igual a la fecha actual puede reprogramarse, basandose en el caso en el que un cliente o un profesional no hayan podido asistir y quieran reprogramarla para una fecha futura
- Los errores por no respetar el orden y la cantidad de parametros de los comandos no los modifiqué, las alertas se muestran en consola como fueron configuradas originalmente


## SEGUNDA ENTREGA:
La principal modificación realizada para esta entrega fue el pasaje a objetos de todo el código de la primer entrega, pudiendo así manejar a los profesionales y citas (appointments) como instancias de sus respectivas clases, simplificando la lógica general del código.
Además tanto directorios como archivos sufrieron modificaciónes:

###### Directorio commands:
Se agregó el archivo correspondiente a tables, el cual contiene su respectivo modulo. Este, al igual que todos los archivos de este directorio, forma parte del modulo Commands y contiene una subclase de la clase Command llamada Create, la cual representa al comando (llamado de igual manera) que permite crear un nuevo archivo HTML con la grilla correspondiente según las opciones pasadas al parametro.
La sintaxis del comando es la siguiente:
```
table (o "t" en su forma abreviada) create "yyyy-mm-dd" --professional="nombre profesional" --type="day/week"
```
La opción `--professional` no es obligatoria, permitiendo (en caso de no utilizarla) mostrar en la grilla resultante los turnos que se correspondan al periodo de tiempo indicado de todos los profesionales existentes en el sistema.
En cuanto a la opcion `--type`, esta es obligatoria (al igual que el argumento inicial que indica una fecha) y debe ser **"day"** o **"week"**.
> `"day"` indica que se listarán solo los turnos correspondientes al día indicado.
> `"week"` indica que se listarán los turnos correspondientes a la semana de la cual el día indicado forma parte.

El comando, al igual que los demás comandos de la aplicación, se encuentra registrado en el archivo *commands.rb* ubicado en el directorio Polycon.

###### Directorio tables:
En este directorio se encuentran los archivos *"table_day"* y *"table_week"*. Estos archivos contienen a las clases **Day** y **Week** respectivamente, las cuales forman parte del **modulo Tables** (que a su vez forma parte del **modulo Polycon**) y permiten crear las grillas según los parametros indicados por el usuario al ejecutar el comando *t create*.

Las grillas resultantes se almacenan en el directorio **tables**, el cual se creará en el directorio home del usuario.

###### Directorio polycon:
En este directorio se agregaron dos archivos:

El primero es el archivo **tables.rb**, el cual permite que se carguen las clases *Week* y *Day* correspondientes al modulo Tables (de la misma forma que el archivo *models.rb* carga las clases *Professional* y *Appointment*).

El segundo archivo es **store.rb**. En este archivo se encuentra toda la lógica relacionada a guardar y recuperar los "objetos" de la aplicación (por ejemplo, recuperar a todos los profesionales, actualizar un appointment, guardar una grilla, etc.); esto permite que las clases se desliguen del manejo de archivos y directorios, delegandolo a la clase **Store**.
Además, la gracias a la clase Store y el manejo de objetos, ya no es necesario el **modulo Utils**, por lo cual se eliminó.

###### Elecciones de diseño (no definidas en el enunciado original):
- Los nombres de los archivos HTML que contienen las grillas siguen el siguiente formato: 
  - *Grillas tipo "Week"*:
    Si se seleccionó un profesional → "nombre_yyyy-mm-dd_week.html"
    Si no se seleccionó un profesional → "yyyy-mm-dd_week.html"
  - *Grillas tipo "Day"*:
    Si se seleccionó un profesional → "nombre_yyyy-mm-dd_day.html"
    Si no se seleccionó un profesional → "yyyy-mm-dd_day.html" 
- Se asume que los horarios creados los turnos se encontrarán en un rango horario entre las 8:00hs y las 16:00hs, con una diferencia de 15 minutos entre cada turno (ej: 08:00, 08:15, 08:30, etc.) 
