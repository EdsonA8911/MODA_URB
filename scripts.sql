-- Listar los pedidos entregados dentro de un rango de fechas, mostrando:
-- Fecha de entrega
-- PedidoID
-- Peso y volumen del pedido
-- Nombre de la tienda de destino
-- Dirección del almacén de origen
-- Placa del camión que lo transportó
DELIMITER //
CREATE PROCEDURE ReportePedidoEntregados (
	IN fecha_inicio DATE,
    IN fecha_final DATE
    )
BEGIN
	SELECT 
		PT.FechaEntrega,
		P.PedidoID,
		P.Peso,
		P.Volumen,
		T.Nombre,
		A.Direccion,
		C.Placa
	FROM pedido_tienda PT
	JOIN Pedido P ON PT.PedidoID = P.PedidoID
	JOIN Tienda T ON PT.TiendaID = T.TiendaID
	JOIN Almacen A ON P.AlmacenID = A.AlmacenID
	JOIN Viaje V ON V.ViajeID = P.ViajeID
	JOIN Camion C ON C.Placa = V.PlacaCamion
	WHERE PT.FechaEntrega between fecha_inicio AND fecha_final;
END //
DELIMITER ;
CALL ReportePedidoEntregados ('2025-06-06' , '2025-06-08');




-- 1. Crear un reporte que muestra
-- el peso y volumen total transportado por cada camión, dentro de un rango de
-- fechas específico.(utilizar procedimientos almacenados).
use velasquezdb;
DELIMITER //
CREATE PROCEDURE ReportePedidoPorCamion (
	IN fecha_inicio DATE,
    IN fecha_final DATE
    )
BEGIN
	SELECT
		C.Placa,
		SUM(P.Peso) AS TotalPesoTransportado,
		SUM(P.Volumen) AS TotalVolumenTransportado
	FROM Pedido P
	JOIN Viaje V ON P.ViajeID = V.ViajeID
	JOIN Camion C ON C.Placa = V.PlacaCamion
	WHERE V.Fecha between fecha_inicio AND fecha_final
	GROUP BY C.Placa;

END //
DELIMITER ;

CALL ReportePedidoPorCamion ('2025-06-01', '2025-06-02');

-- 2. Crear un reporte que muestre la lista
-- los camiones que no realizaron ningún viaje entre dos fechas dadas.(utilizar procedimientos almacenados).

DELIMITER //
CREATE PROCEDURE ReporteCamionesNoUtilizados (
	IN fecha_inicio DATE,
    IN fecha_final DATE
    )
BEGIN
	SELECT 
			C.Placa,
			C.MaxPeso,
			C.MaxVolumen
	FROM Camion C
	WHERE C.Placa NOT IN (SELECT  V.PlacaCamion FROM Viaje V
	WHERE V.Fecha Between fecha_inicio AND fecha_final);

END //
DELIMITER ;

CALL ReporteCamionesNoUtilizados ('2025-06-01', '2025-07-30');

