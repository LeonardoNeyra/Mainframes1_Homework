-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 25-05-2018 a las 01:26:43
-- Versión del servidor: 10.1.26-MariaDB-0+deb9u1
-- Versión de PHP: 7.0.27-0+deb9u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `NotariaRM`
--
CREATE DATABASE IF NOT EXISTS `NotariaRM` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `NotariaRM`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Cliente`
--

CREATE TABLE `Cliente` (
  `idCliente` int(8) NOT NULL,
  `idTipoCliente` int(8) NOT NULL,
  `dni` int(8) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `telefono` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Comprobante`
--

CREATE TABLE `Comprobante` (
  `idComprobante` int(8) NOT NULL,
  `idCliente` int(8) NOT NULL,
  `idEmpleado` int(8) NOT NULL,
  `idTipoComprobante` int(8) NOT NULL,
  `serie` int(5) NOT NULL,
  `codigoUnico` int(6) NOT NULL,
  `fechaEmision` date NOT NULL,
  `importe` int(7) NOT NULL,
  `montoPago` int(7) NOT NULL,
  `saldo` int(7) NOT NULL,
  `subTotal` int(7) NOT NULL,
  `igv` int(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Empleado`
--

CREATE TABLE `Empleado` (
  `idEmpleado` int(8) NOT NULL,
  `dni` int(8) NOT NULL,
  `estadoEmpleado` tinyint(1) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `telefono` int(15) NOT NULL,
  `nombreUsuario` varchar(100) NOT NULL,
  `contraUsuario` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Pago`
--

CREATE TABLE `Pago` (
  `idPago` int(8) NOT NULL,
  `idComprobante` int(8) NOT NULL,
  `idTipoPago` int(8) NOT NULL,
  `fechaPago` date NOT NULL,
  `montoPago` int(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PedidoServicio`
--

CREATE TABLE `PedidoServicio` (
  `idPedidoServicio` int(8) NOT NULL,
  `idTipoServicio` int(8) NOT NULL,
  `idComprobante` int(8) NOT NULL,
  `codigoUnico` int(8) NOT NULL,
  `costoTotalServicio` int(10) NOT NULL,
  `estadoPedidoServicio` tinyint(1) NOT NULL,
  `fechaPedidoServicio` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PedidoSubServicio`
--

CREATE TABLE `PedidoSubServicio` (
  `idPedidoSubServicio` int(8) NOT NULL,
  `idComprobante` int(8) NOT NULL,
  `idTipoServicio` int(8) NOT NULL,
  `codigoUnico` int(8) NOT NULL,
  `costoTotalSubServicio` int(10) NOT NULL,
  `estadoSubServicio` tinyint(1) NOT NULL,
  `fechaPedidoSubServicio` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TipoCliente`
--

CREATE TABLE `TipoCliente` (
  `idTipoCliente` int(8) NOT NULL,
  `Descripcion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TipoComprobante`
--

CREATE TABLE `TipoComprobante` (
  `idTipoComprobante` int(8) NOT NULL,
  `Descripcion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TipoPago`
--

CREATE TABLE `TipoPago` (
  `idTipoPago` int(8) NOT NULL,
  `Descripcion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TipoServicio`
--

CREATE TABLE `TipoServicio` (
  `idTipoServicio` int(8) NOT NULL,
  `Descripcion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Cliente`
--
ALTER TABLE `Cliente`
  ADD PRIMARY KEY (`idCliente`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `idTipoCliente` (`idTipoCliente`);

--
-- Indices de la tabla `Comprobante`
--
ALTER TABLE `Comprobante`
  ADD PRIMARY KEY (`idComprobante`),
  ADD KEY `idCliente` (`idCliente`,`idEmpleado`,`idTipoComprobante`),
  ADD KEY `idEmpleado` (`idEmpleado`),
  ADD KEY `idTipoComprobante` (`idTipoComprobante`);

--
-- Indices de la tabla `Empleado`
--
ALTER TABLE `Empleado`
  ADD PRIMARY KEY (`idEmpleado`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `Pago`
--
ALTER TABLE `Pago`
  ADD PRIMARY KEY (`idPago`),
  ADD KEY `idComprobante` (`idComprobante`,`idTipoPago`),
  ADD KEY `idTipoPago` (`idTipoPago`);

--
-- Indices de la tabla `PedidoServicio`
--
ALTER TABLE `PedidoServicio`
  ADD PRIMARY KEY (`idPedidoServicio`),
  ADD KEY `idTipoServicio` (`idTipoServicio`,`idComprobante`),
  ADD KEY `idComprobante` (`idComprobante`);

--
-- Indices de la tabla `PedidoSubServicio`
--
ALTER TABLE `PedidoSubServicio`
  ADD PRIMARY KEY (`idPedidoSubServicio`),
  ADD KEY `idComprobante` (`idComprobante`,`idTipoServicio`),
  ADD KEY `idTipoServicio` (`idTipoServicio`);

--
-- Indices de la tabla `TipoCliente`
--
ALTER TABLE `TipoCliente`
  ADD PRIMARY KEY (`idTipoCliente`);

--
-- Indices de la tabla `TipoComprobante`
--
ALTER TABLE `TipoComprobante`
  ADD PRIMARY KEY (`idTipoComprobante`);

--
-- Indices de la tabla `TipoPago`
--
ALTER TABLE `TipoPago`
  ADD PRIMARY KEY (`idTipoPago`);

--
-- Indices de la tabla `TipoServicio`
--
ALTER TABLE `TipoServicio`
  ADD PRIMARY KEY (`idTipoServicio`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Cliente`
--
ALTER TABLE `Cliente`
  MODIFY `idCliente` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2501;
--
-- AUTO_INCREMENT de la tabla `Comprobante`
--
ALTER TABLE `Comprobante`
  MODIFY `idComprobante` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3001;
--
-- AUTO_INCREMENT de la tabla `Empleado`
--
ALTER TABLE `Empleado`
  MODIFY `idEmpleado` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;
--
-- AUTO_INCREMENT de la tabla `Pago`
--
ALTER TABLE `Pago`
  MODIFY `idPago` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4201;
--
-- AUTO_INCREMENT de la tabla `PedidoServicio`
--
ALTER TABLE `PedidoServicio`
  MODIFY `idPedidoServicio` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3601;
--
-- AUTO_INCREMENT de la tabla `PedidoSubServicio`
--
ALTER TABLE `PedidoSubServicio`
  MODIFY `idPedidoSubServicio` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2801;
--
-- AUTO_INCREMENT de la tabla `TipoCliente`
--
ALTER TABLE `TipoCliente`
  MODIFY `idTipoCliente` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `TipoComprobante`
--
ALTER TABLE `TipoComprobante`
  MODIFY `idTipoComprobante` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `TipoPago`
--
ALTER TABLE `TipoPago`
  MODIFY `idTipoPago` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `TipoServicio`
--
ALTER TABLE `TipoServicio`
  MODIFY `idTipoServicio` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `Cliente`
--
ALTER TABLE `Cliente`
  ADD CONSTRAINT `Cliente_ibfk_1` FOREIGN KEY (`idTipoCliente`) REFERENCES `TipoCliente` (`idTipoCliente`);

--
-- Filtros para la tabla `Comprobante`
--
ALTER TABLE `Comprobante`
  ADD CONSTRAINT `Comprobante_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `Cliente` (`idCliente`),
  ADD CONSTRAINT `Comprobante_ibfk_2` FOREIGN KEY (`idEmpleado`) REFERENCES `Empleado` (`idEmpleado`),
  ADD CONSTRAINT `Comprobante_ibfk_3` FOREIGN KEY (`idTipoComprobante`) REFERENCES `TipoComprobante` (`idTipoComprobante`);

--
-- Filtros para la tabla `Pago`
--
ALTER TABLE `Pago`
  ADD CONSTRAINT `Pago_ibfk_1` FOREIGN KEY (`idTipoPago`) REFERENCES `TipoPago` (`idTipoPago`),
  ADD CONSTRAINT `Pago_ibfk_2` FOREIGN KEY (`idComprobante`) REFERENCES `Comprobante` (`idComprobante`);

--
-- Filtros para la tabla `PedidoServicio`
--
ALTER TABLE `PedidoServicio`
  ADD CONSTRAINT `PedidoServicio_ibfk_1` FOREIGN KEY (`idComprobante`) REFERENCES `Comprobante` (`idComprobante`),
  ADD CONSTRAINT `PedidoServicio_ibfk_2` FOREIGN KEY (`idTipoServicio`) REFERENCES `TipoServicio` (`idTipoServicio`);

--
-- Filtros para la tabla `PedidoSubServicio`
--
ALTER TABLE `PedidoSubServicio`
  ADD CONSTRAINT `PedidoSubServicio_ibfk_1` FOREIGN KEY (`idComprobante`) REFERENCES `Comprobante` (`idComprobante`),
  ADD CONSTRAINT `PedidoSubServicio_ibfk_2` FOREIGN KEY (`idTipoServicio`) REFERENCES `TipoServicio` (`idTipoServicio`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
