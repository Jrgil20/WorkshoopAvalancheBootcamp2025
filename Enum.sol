// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract EnvioDeProductos {
    // Enum para los estados del envio
    enum EstadoEnvio { Preparando, EnTransito, EnReparto, Entregado, Cancelado }
    /* 
        Variable para almacenar el estado actual
        ¿Como hacemos para almacenar el estado actual usando un enum como tipo de dato?
    */
    EstadoEnvio public status;

    // Función para cambiar el estado de la tarea
    function setStatus(EstadoEnvio newStatus) public {
        status = newStatus;
    }

    /* 
        Función para cambiar el estado de la tarea a Cancelado directamente
        ¿Cómo le asignamos el estado Cancelado a la variable de estado?
    */
    function cancelar() public {
        status = EstadoEnvio.Cancelado;
    }

    /* 
        Función para obtener el estado actual del envio
        ¿Que tipo de dato debe retornar para que nos indique el estado?
        ¿Que variable retorna?
    */
    function getStatus() public view returns (EstadoEnvio) {
        return status;
    }
}