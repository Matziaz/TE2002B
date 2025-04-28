# TE2002B - Encriptador y Desencriptador AES

Este proyecto implementa un sistema de **encriptación** y **desencriptación** basado en el algoritmo AES (Advanced Encryption Standard). Está diseñado para procesar datos de manera segura, proporcionando módulos tanto para el cifrado como para el descifrado, optimizado para implementación en hardware mediante VHDL.

## Características

- **Encriptador**: Convierte texto plano en texto cifrado utilizando una clave secreta.
- **Desencriptador**: Recupera el texto original a partir del texto cifrado utilizando la misma clave.
- Basado en el estándar AES, ampliamente utilizado para la seguridad de datos.
- Modular y escalable, diseñado para implementaciones en hardware mediante FPGA.
- Compatible con Questa para simulación y Quartus para síntesis e implementación.

## Estructura del Proyecto

El proyecto está organizado en los siguientes módulos VHDL:

### **Encriptador**

Contiene los componentes necesarios para realizar el cifrado:
- `AddRoundKey.vhd`: Realiza la operación de suma de clave de ronda.
- `SubBytes.vhd`: Sustituye bytes según una tabla de sustitución (S-box).
- `ShiftRows.vhd`: Desplaza las filas de la matriz de estado.
- `MixColumns.vhd`: Mezcla las columnas de la matriz de estado.
- `KeySchedule.vhd`: Genera las claves de ronda necesarias.

### **Desencriptador**

Incluye los componentes para realizar el descifrado:
- `AddRoundKey.vhd`: Similar al módulo de encriptación, realiza la suma de clave de ronda.
- `InvSubBytes.vhd`: Realiza la sustitución inversa de bytes.
- `InvShiftRows.vhd`: Desplaza las filas de manera inversa.
- `InvMixColumns.vhd`: Mezcla las columnas de manera inversa.
- `KeySchedule.vhd`: Utiliza las claves de ronda generadas para el descifrado.

### **Archivo Principal**

- `Top.vhd`: Integra todos los módulos y define la estructura general del sistema.

## Requisitos

Para trabajar con este proyecto, necesitarás:
- **Questa**: Para simulación y verificación de los componentes VHDL.
- **Quartus Prime**: Para síntesis e implementación del diseño en FPGA.
- Conocimientos básicos de diseño digital y del algoritmo AES.
- FPGA compatible con Quartus para la implementación en hardware.

## Configuración del Entorno

### Configuración de Questa

1. **Instalación**:
   - Asegúrate de tener instalado Questa Advanced Simulator.
   - Verifica que la versión sea compatible con los archivos VHDL del proyecto.

2. **Creación del Proyecto**:
   - Abre Questa y crea un nuevo proyecto.
   - Añade todos los archivos `.vhd` del proyecto.
   - Define la jerarquía del diseño según la estructura del proyecto.

### Configuración de Quartus

1. **Instalación**:
   - Instala Intel Quartus Prime (versión recomendada: 22.1 o superior).
   - Asegúrate de incluir el soporte para tu familia de FPGA específica.

2. **Creación del Proyecto**:
   - Crea un nuevo proyecto en Quartus.
   - Añade todos los archivos `.vhd` del proyecto.
   - Especifica el dispositivo FPGA que utilizarás.
   - Configura las asignaciones de pines según tu placa de desarrollo.

## Flujo de Trabajo

### Simulación con Questa

1. **Compilación**:
   ```
   vcom -work work *.vhd
   ```

2. **Simulación**:
   - Crea un testbench para cada módulo o para el sistema completo.
   - Ejecuta la simulación:
   ```
   vsim -t ns work.testbench
   ```
   - Añade señales al visor de ondas para analizar el comportamiento.
   - Ejecuta la simulación para el tiempo deseado:
   ```
   run 1000 ns
   ```

### Implementación con Quartus

1. **Análisis y Síntesis**:
   - Inicia el proceso de compilación en Quartus.
   - Revisa los informes de síntesis para identificar posibles problemas.

2. **Place & Route**:
   - Ejecuta la asignación de pines y el enrutamiento.
   - Verifica los informes de timing para asegurar que cumple con los requisitos.

3. **Programación**:
   - Conecta la FPGA a tu PC.
   - Usa el programador de Quartus para cargar el archivo `.sof` generado.

## Ejemplo de Uso

1. **Encriptación**:
   - Proporciona un bloque de texto plano (16 bytes) como entrada.
   - Define una clave secreta (16, 24 o 32 bytes, dependiendo de la implementación).
   - El módulo encriptador procesará la entrada y generará el texto cifrado.

2. **Desencriptación**:
   - Alimenta el texto cifrado al módulo desencriptador.
   - Proporciona la misma clave secreta utilizada para la encriptación.
   - El módulo recuperará el texto plano original.

## Verificación

Para verificar el correcto funcionamiento del sistema:

1. **Simulación Funcional**:
   - Ejecuta simulaciones en Questa con vectores de prueba conocidos del estándar AES.
   - Verifica que las salidas coincidan con los resultados esperados.

2. **Pruebas en Hardware**:
   - Implementa el diseño en la FPGA usando Quartus.
   - Utiliza herramientas de depuración como Signal Tap Logic Analyzer para monitorear señales internas.
   - Compara los resultados con los obtenidos en simulación.

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## Créditos

Desarrollado como parte del curso **TE2002B**. Todos los derechos reservados.

---

¡Gracias por usar este proyecto!