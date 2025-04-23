// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Bank {
    // Debemos almacenar los balances de cada usuario
    mapping(address => uint) private balances;
    
    // Enum para manejar el estado de las cuentas
    enum EstadoCuenta {
        Activa,
        Inactiva,
        Cerrada
    }
    
    // Estructura para almacenar la información de las cuentas
    struct Cuenta {
        uint balance;
        EstadoCuenta estado;
        uint ultimaOperacion; // Timestamp de la última operación
        bool exists;
    }
    
    // Debemos almacenar cada cuenta de los usuarios
    mapping(address => Cuenta) public cuentas;

    // Define una variable para el balance total del banco
    uint public balanceTotal;

    // Define eventos para depósito, retiro, transferencia y registro de cuenta
    event CuentaCreada(address indexed usuario, uint timestamp);
    event Deposito(address indexed usuario, uint cantidad, uint nuevoBalance);
    event Retiro(address indexed usuario, uint cantidad, uint nuevoBalance);
    event Transferencia(address indexed remitente, address indexed destinatario, uint cantidad);

    // modifier para verificar si la persona está registrada
    modifier soloRegistrados {
        require(cuentas[msg.sender].exists, "No tienes una cuenta registrada");
        require(cuentas[msg.sender].estado == EstadoCuenta.Activa, "Tu cuenta no esta activa");
        _;
    }

    constructor() {
        // Creamos una cuenta para la persona que crea el contrato
        cuentas[msg.sender] = Cuenta({
            balance: 0,
            estado: EstadoCuenta.Activa,
            ultimaOperacion: block.timestamp,
            exists: true
        });
        emit CuentaCreada(msg.sender, block.timestamp);
    }

    // Función para crear una cuenta bancaria
    function CrearCuenta() external {
        // Verifica que la cuenta no esté ya registrada
        require(!cuentas[msg.sender].exists, "Ya tienes una cuenta registrada");
        
        // Crea una nueva cuenta en el mapping de cuentas
        cuentas[msg.sender] = Cuenta({
            balance: 0,
            estado: EstadoCuenta.Activa,
            ultimaOperacion: block.timestamp,
            exists: true
        });
        
        // Emite un evento CuentaCreada con la dirección del usuario
        emit CuentaCreada(msg.sender, block.timestamp);
    }

    // Función para depositar AVAX (payable)
    function depositar() external payable soloRegistrados {
        // Verifica que msg.value sea mayor a 0
        require(msg.value > 0, "Debes enviar una cantidad mayor a cero");
        
        // Actualiza el saldo del usuario en el mapping de balances
        cuentas[msg.sender].balance += msg.value;
        cuentas[msg.sender].ultimaOperacion = block.timestamp;
        
        // Actualiza la variable de balances totales
        balanceTotal += msg.value;
        
        // Emite un evento Deposito con la dirección, cantidad depositada y nuevo saldo
        emit Deposito(msg.sender, msg.value, cuentas[msg.sender].balance);
    }

    // Función para consultar el saldo de una cuenta
    function verBalance() external view soloRegistrados returns (uint) {
        // Retorna el saldo del usuario desde el mapeo balances
        return cuentas[msg.sender].balance;
    }

    // Función para retirar AVAX
    function retirar(uint cantidad) external soloRegistrados {
        // Verifica que cantidad sea mayor a 0
        require(cantidad > 0, "La cantidad a retirar debe ser mayor a cero");
        
        // Verifica que el usuario tenga suficiente saldo
        require(cuentas[msg.sender].balance >= cantidad, "Saldo insuficiente");
        
        // Actualiza el saldo del usuario y el balance total
        cuentas[msg.sender].balance -= cantidad;
        balanceTotal -= cantidad;
        cuentas[msg.sender].ultimaOperacion = block.timestamp;
        
        // Emite un evento Retiro con la dirección, cantidad y nuevo saldo
        emit Retiro(msg.sender, cantidad, cuentas[msg.sender].balance);
        
        // Usa call para enviar AVAX al usuario
        (bool success, ) = payable(msg.sender).call{value: cantidad}("");
        require(success, "Error al enviar AVAX");
    }

    // Función para transferir AVAX a otra cuenta
    function transferir(address destinatario, uint cantidad) external soloRegistrados {
        // Verifica que la cuenta del destinatario esté registrada
        require(cuentas[destinatario].exists, "La cuenta del destinatario no existe");
        require(cuentas[destinatario].estado == EstadoCuenta.Activa, "La cuenta del destinatario no esta activa");
        
        // Verifica que cantidad sea mayor a 0
        require(cantidad > 0, "La cantidad a transferir debe ser mayor a cero");
        
        // Verifica que el remitente tenga suficiente saldo
        require(cuentas[msg.sender].balance >= cantidad, "Saldo insuficiente");
        
        // Actualiza los saldos del remitente y destinatario en sus balances
        cuentas[msg.sender].balance -= cantidad;
        cuentas[destinatario].balance += cantidad;
        cuentas[msg.sender].ultimaOperacion = block.timestamp;
        cuentas[destinatario].ultimaOperacion = block.timestamp;
        
        // Emite un evento Transferencia con las direcciones y la cantidad
        emit Transferencia(msg.sender, destinatario, cantidad);
    }

    // Función receive para aceptar AVAX enviado directamente
    receive() external payable {
        // Verifica que msg.value sea mayor a 0
        require(msg.value > 0, "Debes enviar una cantidad mayor a cero");
        require(cuentas[msg.sender].exists, "No tienes una cuenta registrada");
        
        // Registra el AVAX como un depósito (similar a la función depositar)
        cuentas[msg.sender].balance += msg.value;
        cuentas[msg.sender].ultimaOperacion = block.timestamp;
        
        // Actualiza los balances
        balanceTotal += msg.value;
        
        // Emite un evento Deposito
        emit Deposito(msg.sender, msg.value, cuentas[msg.sender].balance);
    }

}