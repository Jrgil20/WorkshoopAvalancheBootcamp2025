// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Votacion {
    /* 
        Mapping que permita almacenar votos por candidato
        ¿Que tipo de dato nos sirve para almacenar los votos?
    */
    mapping (address => ???) public votos;

    /* 
        Mapping que rastree si un usuario ya votó
        ¿Que tipo de dato nos sirve para saber si una persona votó?
    */
    mapping (address => ???) public yaVoto;

    // Función para votar por un candidato
    function votar(address candidato) public {
        /* 
            Registra que el usuario votó
            Usamos la variable global msg.sender para almacenar la 
            dirección de la persona que ejecutó la función (el votante)
        */
        yaVoto[msg.sender] = true;
        /* 
            Incrementa los votos del candidato
            Usamos la operación '++' para incrementar en 1 el valor
        */
        votos[candidato]++;
    }
    
    /* 
        Función para verificar si un usuario ya votó
        ¿Es view o pure?
        ¿Que tipo de dato debe retornar para que nos indique si un usuario votó?
    */
    function verificarSiVoto(address votante) public ??? returns (???) {
        return yaVoto[votante];
    }

    /* 
        Función para obtener los votos de un candidato
        ¿Es view o pure?
        ¿Que tipo de dato debe retornar para que nos indique la cantidad de votos?
        ¿Cómo accedemos al mapping y que dato le pasamos para que retorne los votos del candidato?
    */
    function obtenerVotos(address candidato) public ??? returns (???) {
        return ???[???];
    }
}