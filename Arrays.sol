// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Charity {
    // Array para almacenar las direcciones de los donantes
    address[] public donadores;

    // Función para registrarse como donante (omitimos el envio de dinero por ahora)
    function donar() public {
        // ¿Cómo hacemos para almacenar a la persona que interactuó con la función como donador?
        donadores.push(msg.sender);
    }

    /* 
        Función para obtener la dirección del último donante
        ¿Es view o pure?
        ¿Que tipo de dato debe retornar para que nos indique el ultimo donador?
    */
    function ultimoDonador() public view returns (address) {
        // Devuelve la última dirección del array
        return donadores[donadores.length - 1];
    }

    /* 
        Función para obtener el número total de donantes
        ¿Es view o pure?
        ¿Que tipo de dato debe retornar para que nos indique la cantidad de donadores?
    */
    function cantidadDonadores() public view returns (uint256) {
        // Retorna la longitud del array
        return donadores.length;
    }
}