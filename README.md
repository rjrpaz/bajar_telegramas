# bajar_telegramas
Script para bajar telegramas de resultados.gob.ar - elecciones 2017 

La página resultados.gob.ar va subiendo los telegramas que envían los
presidentes de mesa, a medida que son escaneados.

En general suelen subirse de una forma más o menos ágil, aunque puede
suceder que algunos no sean subidos nunca.

El script puede ser ejecutado múltiples veces. Si detecta que un
telegrama ya fue bajado, no reintenta bajarlo.

Por mi uso personal, está bajando solamente los telegramas de la
provincia de Córdoba (código 04), pero sin dudas con una mínima
modificación se podría bajar otra provincia, o todas.

Existe un proyecto mucho más evolucionado en relación al procesamiento
de los telegramas, que tiene su propio repositorio. Para ello, consultar

http://democraciaconcodigos.github.io/

