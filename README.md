


# Solución a la prueba técnica

## Descripción

Aplicación desarrollada para la gestión de precios (listado e importación) siguiendo la arquitectura dada en la prueba técnica.
Se ha priorizado el uso de buenas prácticas:

- Responsabilidad única en los módulos.

- Desacoplamiento entre componentes.

- Código limpio y legible.

El proyecto está dockerizado, lo que facilita:

- Montar un entorno reproducible en cualquier máquina.

- Evitar problemas de dependencias locales.

- Simplificar el despliegue y la ejecución de la aplicación.

## Estructura del proyecto

- controller/ → controladores HTTP.

- service/ → servicios de aplicación.

- use_case/ → casos de uso principales.

- dto/ → objetos de transferencia de datos.

- policy/ → políticas de validación (ej. unidades permitidas según una definición de precio).

- presenter/ → formateo de datos para UI.

- decorator/ → formateo de resultados (ej. resumen de importación).

## Tarea 1 – Listado de precios
### Validaciones

Solo se permite listar precios si se han seleccionado todos los filtros obligatorios: Sucursal (rental_location), Tipo de tarifa (rate_type) y Duración (time_measurement).

**Motivo: garantizar datos consistentes.**

Si no, aparecerían categorías duplicadas con precios de distintas temporadas y el usuario podría percibirlo como un error.

Una vez aplicados los filtros, si se filtra de nuevo, cada desplegable actualizado refresca el desplegable inmediatamente después, asegurando coherencia entre opciones.

**Validación adicional: si se selecciona un grupo de temporadas, se obliga a elegir también la temporada concreta.**

## Presentación

Se desarrolló un presenter (ListPricesPivotPresenter) que transforma los precios en formato de tabla pivotada, perfecto para representar directamente la información en la UI.

## Tarea 2 – Importación de precios

**Respuesta a la pregunta: ¿Planterías la importación siguiendo estos filtros o añadirías las columnas de sucursal, tipo de tarifa y temporada?**

No lo plantearía siguiendo los filtros aunque a nivel conceptual pueda parecer coherente por compartir el mismo esquema. El problema es que hay que indicar a qué combinación concreta pertenece cada precio. He optado por añadir las columnas de sucursal, tipo de tarifa y temporada. Esto permite que en un mismo fichero CSV se definan precios para distintas sucursales, tarifas y temporadas. Además, evita tener que importar varias veces para cubrir todas las combinaciones.

**Archivo CSV de ejemplo: https://raw.githubusercontent.com/jomosen/mybooking-prueba-tecnica/refs/heads/master/mybooking_price_import.csv**

### Flujo

- La importación se implementa mediante subida de fichero CSV.

- El controlador recibe el archivo y lo pasa al use case para que lo orqueste todo.

- Se devuelve un sumario del resultado de la importación.

## Fuente de datos

- Se definió un contrato (ImportDataSource) para desacoplar la fuente de datos del caso de uso.

- Implementación concreta: CsvDataSource.

Esto permite cambiar o ampliar la fuente de datos en el futuro.

## Decorador

Se creó un decorador (ImportResultDecorator) para formatear el resultado de la importación y mostrar al usuario un resumen claro:

- Estado (éxito/abortado).

- Última fila procesada.

- Totales, advertencias y errores.

## Validaciones en la importación

- Se valida que los datos se hayan introducido en el orden correcto. Por ejemplo, en el caso del csv se comprueba que las cabeceras siguen el esquema esperado.
- Si un precio no tiene temporada, en el csv viene como cadena vacía y se mapea como nulo.
- Si el valor de unidades no coincide con ninguna opción de la definición de precio, el precio se omite. Para ello se ha implementado una clase pequeña que encapsula una regla de negocio concreta y aislada (AllowdUnitsPolicy).

## Persistencia

Se implementó un upsert para la persistencia de precios.

- Rendimiento: evita un SELECT previo antes del insert/update.

- Atomicidad: la DB resuelve inserción/actualización de forma segura, evitando condiciones de carrera (por ejemplo más de un usuario importando al mismo tiempo).

## Bug detectado en el dump

En el dump original, los valores de time_measurement no eran correctos:

- El enum definido era (months, days, hours, minutes).

- Para days el índice correcto era 1.

- En el dump aparecía 2 (que corresponde a hours).

- La prueba especificaba que solo debía haber precios definidos para days.

**Decisión: corregir el dump en lugar de cambiar el enum o el código, asegurando que la aplicación fuera funcional y consistente con los requisitos.**

Posibles mejoras futuras

- Añadir tests automáticos (unitarios e integración) para garantizar robustez.

- Mejorar la arquitectura de la aplicación.

- Otras fuentes de importación.

<img width="1420" height="1225" alt="imagen" src="https://github.com/user-attachments/assets/f722e794-f717-4dd1-92b7-91cb01dcdead" />

# Mybooking - Interview test

## Prerequesites

- Ruby 3.3.0
- MySQL or MariaDB

## Database

The file prueba_tecnica.sql is a dump of the db to be used.

## Preparing the environment
```
bundle install
````

Create an .env file at project root with the following variables

```ruby
COOKIE_SECRET="THE-COOKIE-SECRET"
DATABASE_URL="mysql://user:password@host:port/prueba_tecnica?encoding=UTF-8-MB4"
TEST_DATABASE_URL="mysql://user:password@host:port/prueba_tecnica_test?encoding=UTF-8-MB4"
```

## Running the application

```
bundle exec rackup
```

Then, you can open the browser and check

http://localhost:9292
http://localhost:9292/api/sample

## Running tests

The project uses rspec as testing library

````
bundle exec rspec spec
````

## Working with Rake for command line utils

A basic task, foo:bar, has been implemented to show how it works

```
bundle exec rake foo:bar
```

## Details

This is a sample application for Mybooking technical interview. 
It's a Ruby Sinatra webapp that uses bootstrap 5.0 as the css framework.

## Debugging

Install the extension rdbg and use this as lauch.json

````
{
    // Use IntelliSense para saber los atributos posibles.
    // Mantenga el puntero para ver las descripciones de los existentes atributos.
    // Para más información, visite: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "rdbg", // "rdbg" is the type of the debugger
            "name": "Debug Ruby Sinatra",
            "request": "attach",
            "debugPort": "1235",  // The same port as in the config.ru file
            "localfs": true       // To be able to debug the local files using breakpoints
        }
    ]
}
````

