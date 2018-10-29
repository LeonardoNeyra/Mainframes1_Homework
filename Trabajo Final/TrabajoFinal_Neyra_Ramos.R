#Install packages
install.packages("RMySQL")
install.packages("DBI")

#Import libraries
library("DBI")
library("RMySQL")

#Connection to DB
driver<-RMySQL::MySQL()
conexion<-dbConnect(driver, host="127.0.0.1", dbname="NotariaRM", user="admin", password="admin")
rm(list = ls())

#CONSULTAS DE RAMOS SARAVIA, SANDRO
#**********************************
#listarClte
QueryRamos1<-DBI::dbGetQuery(conexion, "SELECT * FROM TipoPago")

#listarClteJuridico
QueryRamos2<-dbGetQuery (con , "SELECT * FROM Cliente WHERE tipoDoc='RUC'")

#listarClteNatural
QueryRamos3<-dbGetQuery (con , "SELECT * FROM Cliente	WHERE tipoDoc='DNI'")

#consultaCltexDNI 
QueryRamos4<-dbGetQuery (con , "SELECT * FROM Cliente WHERE tipoDoc='DNI' AND nroDoc=75829631")

#consultaCltexRUC 
QueryRamos5<-dbGetQuery (con , "SELECT * FROM Cliente	WHERE tipoDoc='RUC' AND nroDoc=20758296310")

#consultaClteNxNombre 
QueryRamos6<-dbGetQuery (con , "SELECT * FROM Cliente WHERE tipoDoc='DNI' AND nombre LIKE '%'+'Maria Fernandez'+'%'")

#consultaClteJxRazonSocial 
QueryRamos7<-dbGetQuery (con , "SELECT * FROM Cliente WHERE tipoDoc='RUC' AND nombre LIKE '%'+'Pacifico' SAC+'%'")

#consultaCompxCodCompUnico 
QueryRamos8<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU  FROM Comprobante as c
                         INNER JOIN PedidoServicio as ps
                         ON c.idComprobante=ps.idComprobante
                         INNER JOIN TipoComprobante as tc
                         ON c.idTipoComp=tc.idTipoComp
                         INNER JOIN Cliente as cte
                         ON c.idCliente=cte.idCliente
                         INNER JOIN Empleado as emp
                         ON c.idEmpleado=emp.idEmpleado
                         WHERE tc.idTipoComp=2 AND c.serie=1 AND c.codCompUnico=150
                         UNION
                         SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag, c.saldo, c.estadoCU FROM Comprobante as c
                         INNER JOIN PedidoSubServicio as pss
                         ON c.idComprobante=pss.idComprobante
                         INNER JOIN TipoComprobante as tc
                         ON c.idTipoComp=tc.idTipoComp
                         INNER JOIN Cliente as cte
                         ON c.idCliente=cte.idCliente
                         INNER JOIN Empleado as emp
                         ON c.idEmpleado=emp.idEmpleado
                         WHERE tc.idTipoComp=2 AND c.serie=1 AND c.codCompUnico=150
                         ORDER BY c.fechaEmision")

#listarCompPendPago 
QueryRamos9<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                         FROM Comprobante as c
                         INNER JOIN Cliente as cte
                         ON c.idCliente=cte.idCliente
                         INNER JOIN TipoComprobante as tc
                         ON c.idTipoComp=tc.idTipoComp
                         INNER JOIN Empleado as emp
                         ON c.idEmpleado=emp.idEmpleado
                         WHERE c.saldo!=0 AND c.estadoCU=1")

#listarCompPendPagoxNroDocClte 
QueryRamos10<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE cte.nroDoc=74625193 AND c.saldo!=0 AND c.estadoCU=1")

#listarCompPendPagoxNombClte 
QueryRamos11<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE cte.nombre LIKE '%'+'Fernando Olivares'+'%' AND c.saldo!=0 AND c.estadoCU=1")

#listarCompPendPagoxEmp 
QueryRamos12<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE emp.nombreUsuario='Rafael' AND c.saldo!=0 AND estadoCU=1")

#listarCompPendxTipo 
QueryRamos13<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE c.idTipoComp=2 AND c.saldo!=0 AND c.estadoCU=1")

#listarCompSaldadoxNroDocClte 
QueryRamos14<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE cte.nroDoc=20418573 AND c.saldo=0 AND c.estadoCU=1")

#listarCompSaldadoxNombClte 
QueryRamos15<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE cte.nombre LIKE '%'+'Grifos del Norte'+'%' AND c.saldo=0 AND c.estadoCU=1")

#listarCompSaldadoxEmp 
QueryRamos16<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE emp.nombreUsuario='Micaela' AND c.saldo=0 AND estadoCU=1")

#listarCompSaldadoxTipo 
QueryRamos17<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE c.idTipoComp=3 AND c.saldo=0 AND c.estadoCU=1")

#listarCompxNroDocClte 
QueryRamos18<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE cte.nroDoc=20164593801")

#listarCompxNombClte 
QueryRamos19<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE cte.nombre LIKE '%'+'Sara Flores'+'%'")

#listarCompxCodigoUnico 
QueryRamos20<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU  FROM Comprobante as c
                          INNER JOIN PedidoServicio as ps
                          ON c.idComprobante=ps.idComprobante
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE ps.codigoUnico=457 AND ps.idTipoServ=1
                          UNION
                          SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag, c.saldo, c.estadoCU FROM Comprobante as c
                          INNER JOIN PedidoSubServicio as pss
                          ON c.idComprobante=pss.idComprobante
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE pss.codigoUnico=457 AND pss.idTipoServ=1
                          ORDER BY c.fechaEmision")

#listarCompxEmp 
QueryRamos21<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE emp.nombreUsuario='Denis'")

#listarCompxTipo 
QueryRamos22<-dbGetQuery (con , "SELECT c.idComprobante, c.fechaEmision, c.serie, c.codCompUnico, tc.nombreComp, cte.nombre as NombreCliente, emp.nombreUsuario, c.importe, c.montoPag ,c.saldo, c.estadoCU
                          FROM Comprobante as c
                          INNER JOIN Cliente as cte
                          ON c.idCliente=cte.idCliente
                          INNER JOIN TipoComprobante as tc
                          ON c.idTipoComp=tc.idTipoComp
                          INNER JOIN Empleado as emp
                          ON c.idEmpleado=emp.idEmpleado
                          WHERE c.idTipoComp=1")

#listarPedServxComp 
QueryRamos23<-dbGetQuery (con, "SELECT ps.idPedServ, ts.nombreTipoServ, ps.codigoUnico as Kardex, ps.estadoPedServ,ps.costoTotalServ, ps.fechaPedServ, ps.descripcion FROM PedidoServicio as ps
                          INNER JOIN TipoServicio as ts
                          ON ps.idTipoServ=ts.idTipoServ
                          WHERE ps.idComprobante=20")

#listarPedSubServxComp 
QueryRamos24<-dbGetQuery(con ,"SELECT pss.idPedSubServ, ts.nombreTipoServ, pss.codigoUnico as Kardex, pss.estadoSubServ, pss.fechaPedSubServ, pss.descripcion FROM PedidoSubServicio as pss
                         INNER JOIN TipoServicio as ts
                         ON pss.idTipoServ=ts.idTipoServ
                         WHERE pss.idComprobante=10")

#consultaTodoTipoServicio 
QueryRamos25<-dbGetQuery (con , "select * from a tipoServicio")


#***********************************************************************************************


#CONSULTAS DE NEYRA OCAÑA, LEONARDO
#**********************************
#listarEmp
QueryNeyra1<-dbGetQuery(con , "SELECT idEmpleado ,nombre, nombreUsuario, tipoUsuario, estadoEmp FROM Empleado")

#listarEmpActivo
QueryNeyra2<-dbGetQuery(con , "SELECT idEmpleado ,nombre, nombreUsuario, tipoUsuario, estadoEmp FROM Empleado
                        WHERE estadoEmp=1")

#listarEmpInactivo
QueryNeyra3<-dbGetQuery(con , "SELECT idEmpleado ,nombre, nombreUsuario, tipoUsuario, estadoEmp FROM Empleado
                        WHERE estadoEmp=0")

#listarPagoxAnio  
QueryNeyra4<-dbGetQuery(con , "SELECT * FROM Pago WHERE DATEPART(year,fechaPago)=2015")

#listarPagoxComp 
QueryNeyra5<-dbGetQuery(con , "SELECT * FROM Pago WHERE idComprobante=142")

#listarPagoxFecha 
QueryNeyra6<-dbGetQuery(con , "SELECT * FROM Pago	WHERE fechaPago='20/02/2015'")

#listarPagoxMes 
QueryNeyra7<-dbGetQuery(con , "SELECT * FROM Pago WHERE DATEPART(month,fechaPago)=4")

#consultaPedServxCodUnico 
QueryNeyra8<-dbGetQuery(con , "SELECT * FROM PedidoServicio WHERE idTipoServ=2 AND codigoUnico=354")

#consultaPedSubServxCodUnico 
QueryNeyra9<-dbGetQuery(con , "SELECT * FROM PedidoSubServicio
                        WHERE idTipoServ=1 AND codigoUnico=416")

#consultaTipoServ 
QueryNeyra10<-dbGetQuery(con , "SELECT * FROM TipoServicio
                         WHERE idTipoServ=2")

#consultaTipoComp 
QueryNeyra11<-dbGetQuery(con , "SELECT * FROM TipoComprobante
                         WHERE idTipoComp=1")

#consultaPagoxTipoPago 
QueryNeyra12<-dbGetQuery (con , "SELECT p.montoPago, tp.descripcion as Tipo FROM Pago as p
                          INNER JOIN TipoPago as tp
                          ON p.idTipoPago=tp.idTipoPago")

#consultaCltexTipoCliente 
QueryNeyra13<-dbGetQuery (con , "SELECT c.dni, c.nombre, tc.descripcion as Tipo FROM Cliente as c
                          INNER JOIN TipoCliente as tc
                          ON c.idTipoCliente=tc.idTipoCliente")

#consultaComprobantexTipo 
QueryNeyra14<-dbGetQuery (con , "SELECT c.serie, c.codigoUnico, tc.descripcion as Tipo FROM Comprobante as c
                          INNER JOIN TipoComprobante as tc
                          ON p.idTipoComprobante=tp.idTipoComprobante
                          WHERE c.serie=2")

#consultaPedidoServicioxTipo 
QueryNeyra15<-dbGetQuery (con , "SELECT s.codigoUnico, s.costoTotalServicio, ts.descripcion as Tipo
                          FROM PedidoServicio as s
                          INNER JOIN TipoServicio as ts
                          ON s.idTipoServicio=ts.idTipoServicio
                          WHERE s.estadoPedidoServicio=1")

#consultaPedidoSubServicioxTipo 
QueryNeyra16<-dbGetQuery (con , "SELECT s.codigoUnico, s.costoTotalSubServicio, ts.descripcion as Tipo
                          FROM PedidoSubServicio as s
                          INNER JOIN TipoServicio as ts
                          ON s.idTipoServicio=ts.idTipoServicio
                          WHERE s.estadoPedidoServicio=0")

#consultaPedidoServicioxEmp 
QueryNeyra17<-dbGetQuery (con , "SELECT s.codigoUnico, s.costoTotalSubServicio, e.nombre
                          FROM PedidoServicio as s
                          INNER JOIN Comprobante as c
                          ON s.idComprobante=c.idComprobante
                          INNER JOIN Empleado e
                          ON c.idEmpleado=e.idEmpleado
                          WHERE c.serie=4")

#consultaPedidoSubServicioxEmp
QueryNeyra18<-dbGetQuery (con , "SELECT s.codigoUnico, s.costoTotalSubServicio, cl.nombre
                          FROM PedidoSubServicio as s
                          INNER JOIN Comprobante as c
                          ON s.idComprobante=c.idComprobante
                          INNER JOIN Cliente cl
                          ON c.idEmpleado=cl.idEmpleado
                          ORDER BY s.costoTotalSubServicio")

#consultaComxTipoSumarizado 
QueryNeyra19<-dbGetQuery (con , "SELECT c.codigoUnico, sum(c.importe), tc.descripcion as tipo
                          FROM Comprobante as c
                          INNER JOIN TipoComprobante as tc
                          ON c.idComprobante=tc.idComprobante
                          GROUP BY tc.descripcion")

#consultaClientedeEmpleado
QueryNeyra20<-dbGetQuery (con , "SELECT e.nombre, cl.nombre
                          FROM Empleado as e
                          INNER JOIN Comprobante as c
                          ON e.idEmpleado=c.idEmpleado
                          INNER JOIN Cliente cl
                          ON c.idCliente=cl.idCliente
                          WHERE e.idEmpleado=28")

#consultaPagoxCliente
QueryNeyra21<-dbGetQuery (con , "SELECT cl.nombre, p.montoPago
                          FROM Cliente as cl
                          INNER JOIN Comprobante as c
                          ON cl.idCliente=c.idCliente
                          INNER JOIN Pago p
                          ON c.idComprobante=p.idComprobante
                          WHERE e.idCliente=28
                          ORDER BY p.montoPago")

