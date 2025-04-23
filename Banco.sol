// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Bank {
    // Debemos almecenar los balances de cada usuario
    mapping...
    // Enum para manejar el estado de las cuentas
    enum EstadoCuenta {
        Activa,
        Inactiva,
        Cerrada
    }
    // Estructura para almacenar la información de las cuentas
    struct Cuenta {
        // ¿Que información tiene cada cuenta?
    }
    // Debemos almacenar cada cuenta de los usuarios
    mapping(address => Cuenta) public cuentas;

    // Define una variable para el balance total del banco

    // Define eventos para depósito, retiro, transferencia y registro de cuenta

    // modifier para verificar si la persona está registrada
    modifier soloRegistrados{
        // Realiza la validación con require o revert
        _;
    }

    constructor() {
        // Creamos una cuenta para la persona que crea el contrato
    }

    // Función para crear una cuenta bancaria
    function CrearCuenta() external {
        // Verifica que la cuenta no esté ya registrada
        // Crea una nueva cuenta en el mapping de cuentas
        // Emite un evento CuentaCreada con la dirección del usuario
    }

    // Función para depositar AVAX (payable)
    function depositar() external payable /* Añade modifier necesario */ {
        // Verifica que msg.value sea mayor a 0
        // Actualiza el saldo del usuario en el mapping de balances
        // Actualiza la variable de balances totales
        // Emite un evento Deposito con la dirección, cantidad depositada y nuevo saldo
        // Sigue el patrón Checks-Effects-Interactions
    }

    // Función para consultar el saldo de una cuenta
    function verBalance() external view /* Añade modificador necesario */ returns (uint) {
        // Retorna el saldo del usuario desde el mapeo balances
    }

    // Función para retirar AVAX
    function retirar(uint cantidad) external /* Añade modificador necesario */ {
        // Verifica que cantidad sea mayor a 0
        // Verifica que el usuario tenga suficiente saldo
        // Actualiza el saldo del usuario y el balance total
        // Usa call para enviar AVAX al usuario
        // Emite un evento Retiro con la dirección, cantidad y nuevo saldo
        // Sigue el patrón Checks-Effects-Interactions
    }

    // Función para transferir AVAX a otra cuenta
    function transferir(address destinatario, uint cantidad) external /* Añade modificadores necesarios */ {
        // Verifica que la cuenta del remitente esté registrada
        // Verifica que la cuenta del destinatario esté registrada
        // Verifica que cantidad sea mayor a 0
        // Verifica que el remitente tenga suficiente saldo
        // Actualiza los saldos del remitente y destinatario en sus balances
        // Emite un evento Transferencia con las direcciones y la cantidad
        // Sigue el patrón Checks-Effects-Interactions
        // Nota: No necesitas enviar AVAX, solo actualizar saldos internos
    }

    // Función receive para aceptar AVAX enviado directamente
    receive() external payable {
        // Verifica que msg.value sea mayor a 0
        // Registra el AVAX como un depósito (similar a la función depositar)
        // Actualiza los balances
        // Emite un evento Deposito
    }

}