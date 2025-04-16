// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract SistemaEnvios {
    // Enum para los estados del envio
    enum EstadoEnvio { Preparando, EnTransito, EnReparto, Entregado, Cancelado }
    
    // Estructura para almacenar información de cada producto
    struct Producto {
        uint256 id;
        string nombre;
        string descripcion;
        address remitente;
        address destinatario;
        EstadoEnvio estado;
        uint256 timestamp;
        string ubicacionActual;
    }
    
    // Mapeo de productos por ID
    mapping(uint256 => Producto) public productos;
    
    // Contador de productos
    uint256 public totalProductos;
    
    // Registro de donadores
    mapping(address => uint256) public donaciones;
    address public ultimoDonador;
    uint256 public totalDonadores;
    
    // Eventos
    event ProductoCreado(uint256 id, address remitente, address destinatario);
    event EstadoActualizado(uint256 id, EstadoEnvio estado, string ubicacion);
    event DonacionRecibida(address donador, uint256 monto);
    
    // Modificador para verificar que solo el remitente pueda actualizar
    modifier soloRemitente(uint256 _id) {
        require(productos[_id].remitente == msg.sender, "Solo el remitente puede modificar el envio");
        _;
    }
    
    // Función para crear un nuevo producto en el sistema
    function crearEnvio(
        string memory _nombre,
        string memory _descripcion,
        address _destinatario,
        string memory _ubicacionInicial
    ) public returns (uint256) {
        uint256 nuevoId = totalProductos + 1;
        
        // Crear nuevo producto
        Producto memory nuevoProducto = Producto({
            id: nuevoId,
            nombre: _nombre,
            descripcion: _descripcion,
            remitente: msg.sender,
            destinatario: _destinatario,
            estado: EstadoEnvio.Preparando,
            timestamp: block.timestamp,
            ubicacionActual: _ubicacionInicial
        });
        
        // Almacenar el producto
        productos[nuevoId] = nuevoProducto;
        
        // Incrementar contador
        totalProductos = nuevoId;
        
        // Emitir evento
        emit ProductoCreado(nuevoId, msg.sender, _destinatario);
        
        return nuevoId;
    }
    
    // Función para actualizar el estado de un envío
    function actualizarEstado(
        uint256 _id,
        EstadoEnvio _nuevoEstado,
        string memory _nuevaUbicacion
    ) public soloRemitente(_id) {
        require(_id > 0 && _id <= totalProductos, "ID de producto invalido");
        
        Producto storage producto = productos[_id];
        producto.estado = _nuevoEstado;
        producto.ubicacionActual = _nuevaUbicacion;
        producto.timestamp = block.timestamp;
        
        emit EstadoActualizado(_id, _nuevoEstado, _nuevaUbicacion);
    }
    
    // Función para obtener información de un producto
    function obtenerInformacionProducto(uint256 _id) public view returns (
        string memory nombre,
        string memory descripcion,
        address remitente,
        address destinatario,
        EstadoEnvio estado,
        uint256 timestamp,
        string memory ubicacionActual
    ) {
        require(_id > 0 && _id <= totalProductos, "ID de producto invalido");
        
        Producto memory producto = productos[_id];
        
        return (
            producto.nombre,
            producto.descripcion,
            producto.remitente,
            producto.destinatario,
            producto.estado,
            producto.timestamp,
            producto.ubicacionActual
        );
    }
    
    // Función para realizar una donación
    function donar() public payable {
        require(msg.value > 0, "La donacion debe ser mayor a cero");
        
        // Actualizar el registro de donaciones
        if (donaciones[msg.sender] == 0) {
            totalDonadores++;
        }
        
        donaciones[msg.sender] += msg.value;
        ultimoDonador = msg.sender;
        
        emit DonacionRecibida(msg.sender, msg.value);
    }
    
    // Función para obtener el último donador
    function getUltimoDonador() public view returns (address) {
        return ultimoDonador;
    }
    
    // Función para obtener el total de donadores
    function getTotalDonadores() public view returns (uint256) {
        return totalDonadores;
    }
    
    // Función para obtener la donación total de una dirección
    function getDonacionPorDireccion(address _donador) public view returns (uint256) {
        return donaciones[_donador];
    }
    
    // Función para cancelar un envío
    function cancelarEnvio(uint256 _id) public soloRemitente(_id) {
        require(_id > 0 && _id <= totalProductos, "ID de producto invalido");
        require(productos[_id].estado != EstadoEnvio.Entregado, "No se puede cancelar un envio ya entregado");
        
        productos[_id].estado = EstadoEnvio.Cancelado;
        emit EstadoActualizado(_id, EstadoEnvio.Cancelado, productos[_id].ubicacionActual);
    }
}