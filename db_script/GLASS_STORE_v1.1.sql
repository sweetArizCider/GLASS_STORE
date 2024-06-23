-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: GLASS_STORE
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE GLASS_STORE_V1;

--
-- Table structure for table `CITAS`
--

DROP TABLE IF EXISTS `CITAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CITAS` (
  `id_cita` int NOT NULL AUTO_INCREMENT,
  `usuario` int NOT NULL,
  `venta` int DEFAULT NULL,
  `tipo` enum('medidas','instalacion','personalizada') DEFAULT NULL,
  `fecha` date NOT NULL,
  `direccion` int NOT NULL,
  `hora` enum('13:00','18:00') DEFAULT NULL,
  `status` enum('aceptada','rechazada','en espera') DEFAULT NULL,
  PRIMARY KEY (`id_cita`),
  KEY `direccion` (`direccion`),
  KEY `usuario` (`usuario`),
  KEY `fk_citas_venta` (`venta`),
  CONSTRAINT `CITAS_ibfk_2` FOREIGN KEY (`direccion`) REFERENCES `DIRECCIONES` (`id_direccion`),
  CONSTRAINT `CITAS_ibfk_3` FOREIGN KEY (`usuario`) REFERENCES `USUARIOS` (`id_usuario`),
  CONSTRAINT `fk_citas_venta` FOREIGN KEY (`venta`) REFERENCES `VENTAS` (`id_venta`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CITAS`
--

LOCK TABLES `CITAS` WRITE;
/*!40000 ALTER TABLE `CITAS` DISABLE KEYS */;
INSERT INTO `CITAS` VALUES (1,51,NULL,'medidas','2024-06-17',6,'13:00','en espera'),(2,52,NULL,'instalacion','2024-03-20',7,'18:00','en espera'),(3,51,NULL,'personalizada','2024-06-18',11,'13:00','en espera');
/*!40000 ALTER TABLE `CITAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COTIZACIONES`
--

DROP TABLE IF EXISTS `COTIZACIONES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COTIZACIONES` (
  `id_cotizacion` int NOT NULL AUTO_INCREMENT,
  `usuario` int NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `monto` double(10,2) NOT NULL,
  PRIMARY KEY (`id_cotizacion`),
  KEY `fk_usuario` (`usuario`),
  CONSTRAINT `fk_usuario` FOREIGN KEY (`usuario`) REFERENCES `USUARIOS` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COTIZACIONES`
--

LOCK TABLES `COTIZACIONES` WRITE;
/*!40000 ALTER TABLE `COTIZACIONES` DISABLE KEYS */;
INSERT INTO `COTIZACIONES` VALUES (1,1,NULL,0.00),(2,1,NULL,0.00),(3,1,NULL,0.00),(4,2,NULL,0.00),(5,2,NULL,0.00),(6,3,NULL,0.00),(7,4,NULL,0.00),(8,4,NULL,0.00),(9,4,NULL,0.00),(10,4,NULL,0.00),(11,4,NULL,0.00),(12,5,NULL,0.00),(13,5,NULL,0.00),(14,5,NULL,0.00),(15,5,NULL,0.00),(16,5,NULL,0.00),(17,6,NULL,0.00),(18,7,NULL,0.00),(19,7,NULL,0.00),(20,8,NULL,0.00),(21,8,NULL,0.00),(22,8,NULL,0.00),(23,9,NULL,0.00),(24,9,NULL,0.00),(25,10,'2024-06-20 03:22:41',0.00),(26,10,'2024-06-20 03:22:41',0.00),(27,11,'2024-06-20 03:22:41',0.00),(28,12,'2024-06-20 03:22:41',0.00),(29,12,'2024-06-20 03:22:41',0.00),(30,13,'2024-06-20 03:22:41',0.00),(31,14,'2024-06-20 03:22:41',0.00),(32,14,'2024-06-20 03:22:41',0.00),(33,14,'2024-06-20 03:22:41',0.00),(34,14,'2024-06-20 03:22:41',0.00),(35,14,'2024-06-20 03:22:41',0.00),(36,15,'2024-06-20 03:22:41',0.00),(37,15,'2024-06-20 03:22:41',0.00),(38,15,'2024-06-20 03:22:41',0.00),(39,15,'2024-06-20 03:22:41',0.00),(40,15,'2024-06-20 03:22:41',0.00),(41,16,'2024-06-20 03:22:41',0.00),(42,17,'2024-06-20 03:22:41',0.00),(43,17,'2024-06-20 03:22:41',0.00),(44,18,'2024-06-20 03:22:41',0.00),(45,18,'2024-06-20 03:22:41',0.00),(46,18,'2024-06-20 03:22:41',0.00),(47,19,'2024-06-20 03:22:41',0.00),(48,19,'2024-06-20 03:22:41',0.00);
/*!40000 ALTER TABLE `COTIZACIONES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COTIZACIONES_HERRERIAS`
--

DROP TABLE IF EXISTS `COTIZACIONES_HERRERIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COTIZACIONES_HERRERIAS` (
  `id_cotizacion` int NOT NULL AUTO_INCREMENT,
  `cotizacion` int NOT NULL,
  `herreria` int NOT NULL,
  `alto` decimal(10,2) NOT NULL,
  `largo` decimal(10,2) NOT NULL,
  `cantidad` int NOT NULL,
  PRIMARY KEY (`id_cotizacion`),
  KEY `cotizacion` (`cotizacion`),
  KEY `herreria` (`herreria`),
  CONSTRAINT `COTIZACIONES_HERRERIAS_ibfk_1` FOREIGN KEY (`cotizacion`) REFERENCES `COTIZACIONES` (`id_cotizacion`),
  CONSTRAINT `COTIZACIONES_HERRERIAS_ibfk_2` FOREIGN KEY (`herreria`) REFERENCES `HERRERIAS` (`id_herreria`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COTIZACIONES_HERRERIAS`
--

LOCK TABLES `COTIZACIONES_HERRERIAS` WRITE;
/*!40000 ALTER TABLE `COTIZACIONES_HERRERIAS` DISABLE KEYS */;
INSERT INTO `COTIZACIONES_HERRERIAS` VALUES (1,1,1,1.20,1.00,1);
/*!40000 ALTER TABLE `COTIZACIONES_HERRERIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COTIZACIONES_PERSIANAS`
--

DROP TABLE IF EXISTS `COTIZACIONES_PERSIANAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COTIZACIONES_PERSIANAS` (
  `id_cotizacion` int NOT NULL AUTO_INCREMENT,
  `cotizacion` int NOT NULL,
  `persiana` int NOT NULL,
  `alto` decimal(10,2) NOT NULL,
  `largo` decimal(10,2) NOT NULL,
  `tipo_tela` varchar(50) DEFAULT NULL,
  `marco` varchar(50) DEFAULT NULL,
  `tipo_cadena` varchar(50) DEFAULT NULL,
  `cantidad` int NOT NULL,
  PRIMARY KEY (`id_cotizacion`),
  KEY `cotizacion` (`cotizacion`),
  KEY `persiana` (`persiana`),
  CONSTRAINT `COTIZACIONES_PERSIANAS_ibfk_1` FOREIGN KEY (`cotizacion`) REFERENCES `COTIZACIONES` (`id_cotizacion`),
  CONSTRAINT `COTIZACIONES_PERSIANAS_ibfk_2` FOREIGN KEY (`persiana`) REFERENCES `PERSIANAS` (`id_persiana`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COTIZACIONES_PERSIANAS`
--

LOCK TABLES `COTIZACIONES_PERSIANAS` WRITE;
/*!40000 ALTER TABLE `COTIZACIONES_PERSIANAS` DISABLE KEYS */;
/*!40000 ALTER TABLE `COTIZACIONES_PERSIANAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COTIZACIONES_TAPICES`
--

DROP TABLE IF EXISTS `COTIZACIONES_TAPICES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COTIZACIONES_TAPICES` (
  `id_cotizacion` int NOT NULL AUTO_INCREMENT,
  `cotizacion` int NOT NULL,
  `tapiz` int NOT NULL,
  `alto` decimal(10,2) NOT NULL,
  `largo` decimal(10,2) NOT NULL,
  `diseño` varchar(30) DEFAULT NULL,
  `cantidad` int NOT NULL,
  PRIMARY KEY (`id_cotizacion`),
  KEY `cotizacion` (`cotizacion`),
  KEY `tapiz` (`tapiz`),
  KEY `diseño` (`diseño`),
  CONSTRAINT `COTIZACIONES_TAPICES_ibfk_1` FOREIGN KEY (`cotizacion`) REFERENCES `COTIZACIONES` (`id_cotizacion`),
  CONSTRAINT `COTIZACIONES_TAPICES_ibfk_2` FOREIGN KEY (`tapiz`) REFERENCES `TAPICES` (`id_tapiz`),
  CONSTRAINT `COTIZACIONES_TAPICES_ibfk_3` FOREIGN KEY (`diseño`) REFERENCES `DISEÑOS` (`id_diseño`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COTIZACIONES_TAPICES`
--

LOCK TABLES `COTIZACIONES_TAPICES` WRITE;
/*!40000 ALTER TABLE `COTIZACIONES_TAPICES` DISABLE KEYS */;
INSERT INTO `COTIZACIONES_TAPICES` VALUES (1,1,1,1.50,1.50,'10104-02(64)',2);
/*!40000 ALTER TABLE `COTIZACIONES_TAPICES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COTIZACIONES_VIDRIOS`
--

DROP TABLE IF EXISTS `COTIZACIONES_VIDRIOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COTIZACIONES_VIDRIOS` (
  `id_cotizacion` int NOT NULL AUTO_INCREMENT,
  `cotizacion` int NOT NULL,
  `vidrio` int NOT NULL,
  `alto` decimal(10,2) NOT NULL,
  `largo` decimal(10,2) NOT NULL,
  `grosor` decimal(10,2) NOT NULL,
  `cantidad` int NOT NULL,
  PRIMARY KEY (`id_cotizacion`),
  KEY `cotizacion` (`cotizacion`),
  KEY `vidrio` (`vidrio`),
  CONSTRAINT `COTIZACIONES_VIDRIOS_ibfk_1` FOREIGN KEY (`cotizacion`) REFERENCES `COTIZACIONES` (`id_cotizacion`),
  CONSTRAINT `COTIZACIONES_VIDRIOS_ibfk_2` FOREIGN KEY (`vidrio`) REFERENCES `VIDRIOS` (`id_vidrio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COTIZACIONES_VIDRIOS`
--

LOCK TABLES `COTIZACIONES_VIDRIOS` WRITE;
/*!40000 ALTER TABLE `COTIZACIONES_VIDRIOS` DISABLE KEYS */;
/*!40000 ALTER TABLE `COTIZACIONES_VIDRIOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DIRECCIONES`
--

DROP TABLE IF EXISTS `DIRECCIONES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DIRECCIONES` (
  `id_direccion` int NOT NULL AUTO_INCREMENT,
  `usuario` int NOT NULL,
  `calle` varchar(50) NOT NULL,
  `numero` int NOT NULL,
  `colonia` varchar(50) NOT NULL,
  `ciudad` enum('torreon','gomez palacio','lerdo') NOT NULL,
  `referencias` varchar(300) NOT NULL,
  PRIMARY KEY (`id_direccion`),
  KEY `usuario` (`usuario`),
  CONSTRAINT `DIRECCIONES_ibfk_1` FOREIGN KEY (`usuario`) REFERENCES `USUARIOS` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DIRECCIONES`
--

LOCK TABLES `DIRECCIONES` WRITE;
/*!40000 ALTER TABLE `DIRECCIONES` DISABLE KEYS */;
INSERT INTO `DIRECCIONES` VALUES (6,51,'Av.Torre Latino',454,'Las Torres','torreon','casa roja'),(7,52,'Av. Revolución',123,'Centro','gomez palacio','edificio blanco'),(8,53,'Calle 5 de Mayo',789,'San Miguel','lerdo','esquina con avenida principal'),(9,54,'Paseo de la Reforma',456,'Polanco','torreon','frente a parque central'),(10,55,'Av. Constitución',987,'Del Valle','lerdo','al lado del centro comercial'),(11,51,'Av. Benito Juarez',234,'Centro','torreon','cerca de la plaza principal'),(12,52,'Calle Allende',567,'San Miguel','gomez palacio','al lado del parque'),(13,53,'Av. Hidalgo',890,'Polanco','lerdo','junto a la iglesia'),(14,54,'Calle Independencia',123,'Las Torres','torreon','frente al supermercado'),(15,55,'Calle Zaragoza',456,'Del Valle','gomez palacio','entre las calles 5 de mayo y 16 de septiembre');
/*!40000 ALTER TABLE `DIRECCIONES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DISEÑOS`
--

DROP TABLE IF EXISTS `DISEÑOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DISEÑOS` (
  `id_diseño` varchar(30) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `upload_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_diseño`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DISEÑOS`
--

LOCK TABLES `DISEÑOS` WRITE;
/*!40000 ALTER TABLE `DISEÑOS` DISABLE KEYS */;
INSERT INTO `DISEÑOS` VALUES ('10104-02(64)','/var/www/html/img/catalogo/tapices/SPOT_2_10104-02(64).png','SPOT_2_10104-02(64)','2024-06-20 01:59:51','Patrón natural, hojas bordadas, beige claro'),('10104-10(64)','/var/www/html/img/catalogo/tapices/SPOT_3_10104-10(64).png','SPOT_3_10104-10(64)','2024-06-20 01:59:51','Patrón natural, hojas bordadas, beige oscuro'),('10145-31(64)','/var/www/html/img/catalogo/tapices/SPOT_1_10145-31(64).png','SPOT_1_10145-31(64)','2024-06-20 01:59:51','Patrón geométrico, beige'),('LV-10005','/var/www/html/img/catalogo/tapices/Bili_Bili_4_LV-10005.png','Bili_Bili_4_LV-10005','2024-06-20 01:55:21','Tipo marmol, beige'),('LV-10006','/var/www/html/img/catalogo/tapices/Bili_Bili_1_LV-10006.png','Bili_Bili_1_LV-10006','2024-06-20 01:50:54','Tipo roca, gris con detalles dorados'),('LV-10016','/var/www/html/img/catalogo/tapices/Bili_Bili_2_LV-10016.png','Bili_Bili_2_LV-10016','2024-06-20 01:55:21','Tipo roca, brilloso, líneas vertiales doradas'),('LV-10026','/var/www/html/img/catalogo/tapices/Bili_Bili_3_LV-10026.png','Bili_Bili_3_LV-10026','2024-06-20 01:55:21','Tipo alfombra, gris jaspeado con dorado'),('LV-10056','/var/www/html/img/catalogo/tapices/Bili_Bili_5_LV-10056.png','Bili_Bili_5_LV-10056','2024-06-20 01:55:21','Tipo alfombra, geométrico blanco y negro, patron chico'),('MV-201-10','/var/www/html/img/catalogo/tapices/MET_AVERSE_3_MV-201-10.png','MET_AVERSE_3_MV-201-10','2024-06-20 02:03:48','Tipo piedra, gris moteado'),('MV-303-3','/var/www/html/img/catalogo/tapices/MET_AVERSE_2_MV-303-3.png','MET_AVERSE_2_MV-303-3','2024-06-20 02:03:48','Tipo marmol, negro con dorado, geométrico'),('MV-303-4','/var/www/html/img/catalogo/tapices/MET_AVERSE_1_MV-303-4.png','MET_AVERSE_1_MV-303-4','2024-06-20 02:03:48','Tipo marmol, blanco negro y dorado');
/*!40000 ALTER TABLE `DISEÑOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FAVORITOS`
--

DROP TABLE IF EXISTS `FAVORITOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FAVORITOS` (
  `id_favorito` int NOT NULL AUTO_INCREMENT,
  `usuario` int NOT NULL,
  `producto` int NOT NULL,
  PRIMARY KEY (`id_favorito`),
  KEY `usuario` (`usuario`),
  KEY `producto` (`producto`),
  CONSTRAINT `FAVORITOS_ibfk_1` FOREIGN KEY (`usuario`) REFERENCES `USUARIOS` (`id_usuario`),
  CONSTRAINT `FAVORITOS_ibfk_2` FOREIGN KEY (`producto`) REFERENCES `PRODUCTOS` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FAVORITOS`
--

LOCK TABLES `FAVORITOS` WRITE;
/*!40000 ALTER TABLE `FAVORITOS` DISABLE KEYS */;
/*!40000 ALTER TABLE `FAVORITOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HERRERIAS`
--

DROP TABLE IF EXISTS `HERRERIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HERRERIAS` (
  `id_herreria` int NOT NULL AUTO_INCREMENT,
  `producto` int NOT NULL,
  PRIMARY KEY (`id_herreria`),
  UNIQUE KEY `producto` (`producto`),
  CONSTRAINT `HERRERIAS_ibfk_1` FOREIGN KEY (`producto`) REFERENCES `PRODUCTOS` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HERRERIAS`
--

LOCK TABLES `HERRERIAS` WRITE;
/*!40000 ALTER TABLE `HERRERIAS` DISABLE KEYS */;
INSERT INTO `HERRERIAS` VALUES (1,36),(2,37),(3,49),(4,50);
/*!40000 ALTER TABLE `HERRERIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HISTORIAL_ABONOS`
--

DROP TABLE IF EXISTS `HISTORIAL_ABONOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HISTORIAL_ABONOS` (
  `id_abono` int NOT NULL AUTO_INCREMENT,
  `venta` int NOT NULL,
  `fecha_pago` datetime NOT NULL,
  `cantidad_pagada` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_abono`),
  KEY `venta` (`venta`),
  CONSTRAINT `HISTORIAL_ABONOS_ibfk_1` FOREIGN KEY (`venta`) REFERENCES `VENTAS` (`id_venta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HISTORIAL_ABONOS`
--

LOCK TABLES `HISTORIAL_ABONOS` WRITE;
/*!40000 ALTER TABLE `HISTORIAL_ABONOS` DISABLE KEYS */;
/*!40000 ALTER TABLE `HISTORIAL_ABONOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NOTIFICACIONES`
--

DROP TABLE IF EXISTS `NOTIFICACIONES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NOTIFICACIONES` (
  `id_notificacion` int NOT NULL AUTO_INCREMENT,
  `tipo` enum('cita','promocion') NOT NULL,
  `cita` int DEFAULT NULL,
  `mensaje` varchar(200) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`),
  KEY `cita` (`cita`),
  KEY `usuario` (`usuario`),
  CONSTRAINT `NOTIFICACIONES_ibfk_1` FOREIGN KEY (`cita`) REFERENCES `CITAS` (`id_cita`),
  CONSTRAINT `usuario` FOREIGN KEY (`usuario`) REFERENCES `USUARIOS` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NOTIFICACIONES`
--

LOCK TABLES `NOTIFICACIONES` WRITE;
/*!40000 ALTER TABLE `NOTIFICACIONES` DISABLE KEYS */;
INSERT INTO `NOTIFICACIONES` VALUES (1,'cita',1,'Su cita para la toma de medidas es mañana 20 de junio a las 10 AM.','2024-06-20 02:35:46',NULL),(2,'promocion',NULL,'¡Aproveche nuestra promoción del 15% de descuento en proyectos de renovación completa este mes!','2024-06-20 02:35:46',NULL),(3,'cita',2,'Recordatorio: su cita para la evaluación del espacio es el 25 de junio a las 2 PM.','2024-06-20 02:35:46',NULL),(4,'promocion',NULL,'¡Oferta especial! Obtenga una consulta de diseño gratuita al contratar nuestros servicios esta semana.','2024-06-20 02:35:46',NULL),(5,'cita',1,'Confirmación de cita: para su instalcion pendiente el 30 de junio a las 11 AM.','2024-06-20 02:35:46',NULL);
/*!40000 ALTER TABLE `NOTIFICACIONES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PERSIANAS`
--

DROP TABLE IF EXISTS `PERSIANAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PERSIANAS` (
  `id_persiana` int NOT NULL AUTO_INCREMENT,
  `producto` int NOT NULL,
  PRIMARY KEY (`id_persiana`),
  UNIQUE KEY `producto` (`producto`),
  CONSTRAINT `PERSIANAS_ibfk_1` FOREIGN KEY (`producto`) REFERENCES `PRODUCTOS` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PERSIANAS`
--

LOCK TABLES `PERSIANAS` WRITE;
/*!40000 ALTER TABLE `PERSIANAS` DISABLE KEYS */;
INSERT INTO `PERSIANAS` VALUES (1,2),(2,7),(3,8),(4,9),(5,10),(6,11);
/*!40000 ALTER TABLE `PERSIANAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PERSONA`
--

DROP TABLE IF EXISTS `PERSONA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PERSONA` (
  `id_persona` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(25) NOT NULL,
  `apellido_p` varchar(30) NOT NULL,
  `apellido_m` varchar(30) DEFAULT NULL,
  `correo` varchar(70) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  PRIMARY KEY (`id_persona`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `telefono` (`telefono`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PERSONA`
--

LOCK TABLES `PERSONA` WRITE;
/*!40000 ALTER TABLE `PERSONA` DISABLE KEYS */;
INSERT INTO `PERSONA` VALUES (73,'Carlos','Arizpe','Hernandez','pycarizpehdz@gmail.com','8719002244'),(74,'Pamela','Robledo','Pinto','pamelita@gmail.com','871510287'),(75,'Thania Sofia','Medina','','thania123@gmail.com','8719274924'),(76,'Ana Luisa','de Leon','Azpilicueta','deleon@outlook.com','8712389944'),(77,'Marcela','González','Martínez','marcelagm@gmail.com','871111333'),(78,'Gustavo','Hernández','Sánchez','gustavohs@yahoo.com','871222444'),(79,'Lorena','Martínez','López','lorenaml@yahoo.com','871333555'),(80,'Rodrigo','López','Ramírez','rodrigolr@gmail.com','871444666'),(81,'Valeria','Ramírez','Gómez','valeriarfg@yahoo.com','871555777'),(82,'Felipe','García','Hernández','felipegh@gmail.com','871666888'),(83,'Catalina','Sánchez','García','catalinasg@yahoo.com','871777999'),(84,'Mariano','Martínez','Gómez','marianomg@gmail.com','871888111'),(85,'Isabella','Gómez','Hernández','isabellagh@yahoo.com','871999222'),(86,'Arturo','Hernández','Martínez','arturohm@gmail.com','371123456'),(87,'Fernanda','López','García','fernandalg@yahoo.com','871234567'),(88,'Ricardo','Ramírez','Martínez','ricardorm@gmail.com','871345678'),(89,'Juliana','García','López','julianagl@yahoo.com','871456789'),(90,'Emilio','Sánchez','Ramírez','emiliosr@gmail.com','871567890'),(91,'Camila','Martínez','Gómez','camilamg@yahoo.com','871678901'),(92,'Sebastián','Gómez','Hernández','sebastiangh@gmail.com','871789012'),(93,'Valentina','Hernández','Sánchez','valentinahs@yahoo.com','871890123'),(94,'Facundo','López','Martínez','facundolm@gmail.com','871901234'),(95,'Abril','Ramírez','Gómez','abrilrg@yahoo.com','871012345'),(96,'Mateo','García','López','mateogl@gmail.com','871123456'),(157,'Emiliano','Hernández','García','emilianohg@gmail.com','8441112222'),(158,'Valeria','García','Martínez','valeriagm@yahoo.com','8713334444'),(159,'Joaquín','Martínez','Ramírez','joaquinmr@gmail.com','8995556666'),(160,'Renata','Ramírez','López','renatarl@yahoo.com','8337778888'),(161,'Leonardo','López','Gómez','leonardolg@gmail.com','8189990000'),(162,'Isabela','Gómez','Hernández','isabelagh@yahoo.com','8112223333'),(163,'Tomás','Hernández','Martínez','tomashm@gmail.com','8714445555'),(164,'Aitana','García','López','aitanagl@yahoo.com','8715556666'),(165,'Diego','López','Ramírez','diegolr@gmail.com','8996667777'),(166,'Luna','Ramírez','Gómez','lunarg@yahoo.com','8338889999'),(167,'Emilio','Martínez','Hernández','emiliomh@gmail.com','8181112222'),(168,'Valentina','Hernández','Sánchez','valentinahs2@yahoo.com','8113334444'),(169,'Santiago','Sánchez','Martínez','santiagosm@gmail.com','8716667777'),(170,'Catalina','Martínez','Gómez','catalinamg@yahoo.com','8997778888'),(171,'Benjamín','Gómez','Ramírez','benjamingr@gmail.com','8339990000'),(172,'Emma','Ramírez','López','emmarl@yahoo.com','8182223333'),(173,'Lucas','López','García','lucaslg@gmail.com','8717778888'),(174,'Martina','García','Martínez','martinagm@yahoo.com','8718889999'),(175,'Matías','Martínez','Hernández','matiashh@gmail.com','8990001111'),(176,'Camila','Hernández','López','camilahl@yahoo.com','8331112222');
/*!40000 ALTER TABLE `PERSONA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRODUCTOS`
--

DROP TABLE IF EXISTS `PRODUCTOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUCTOS` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCTOS`
--

LOCK TABLES `PRODUCTOS` WRITE;
/*!40000 ALTER TABLE `PRODUCTOS` DISABLE KEYS */;
INSERT INTO `PRODUCTOS` VALUES (1,'Persiana Moderna','Persiana de lujo para interiores',150.00),(2,'Ventana de Vidrio','Ventana de vidrio templado de alta resistencia',300.00),(3,'Puerta de Vidrio','Puerta de vidrio templado para interiores',500.00),(4,'Tapiz Floral','Tapiz de diseño floral para paredes',50.00),(5,'Repisa de Vidrio','Repisa de vidrio templado para decoración',100.00),(6,'Cubierta para Mesa de Vidrio','Cubierta de vidrio templado para mesa',200.00),(7,'Persiana clasica','Persiana de lujo para interiores',2500.00),(8,'Persiana francesa','Persiana de lujo para interiores',2800.00),(9,'Persiana elegance','Persiana de lujo para interiores',3000.00),(10,'Persiana sheer','Persiana de lujo para interiores',3500.00),(11,'Persiana tablas','Persiana de lujo para interiores',4000.00),(12,'Ventana de Vidrio doble','Ventana de vidrio templado de alta resistencia',600.00),(13,'Ventana de Vidrio triple','Ventana de vidrio templado de alta resistencia',900.00),(14,'Ventana de Vidrio grande','Ventana de vidrio templado de alta resistencia',1600.00),(15,'Ventana de Vidrio chica','Ventana de vidrio templado de alta resistencia',200.00),(16,'Ventana de Vidrio mediana','Ventana de vidrio templado de alta resistencia',400.00),(17,'Cancel clasico','Puerta de vidrio templado para interiores',500.00),(18,'Cancel con diseno','Puerta de vidrio templado para interiores',900.00),(19,'Cancel corredizo','Puerta de vidrio templado para interiores',1000.00),(20,'Repisa de Vidrio moderna','Repisa de vidrio templado para decoración',200.00),(21,'Cubierta para Mesa de Vidrio con diseno','Cubierta de vidrio templado para mesa',400.00),(22,'Tapiz BILLI BILL','Tapiz dentro del catalogo BILLI BILLI',50.00),(23,'Tapiz MODERNA','Tapiz dentro del catalogo MODERNA',50.00),(24,'Tapiz ERA','Tapiz dentro del catalogo ERA',50.00),(25,'Tapiz BILLI BILL','Tapiz dentro del catalogo BILLI BILLI',50.00),(26,'Tapiz MODERNA','Tapiz dentro del catalogo MODERNA',50.00),(27,'Tapiz AURORA','Tapiz dentro del catalogo ERA',50.00),(28,'Tapiz KIDS','Tapiz dentro del catalogo BILLI BILLI',50.00),(29,'Tapiz PEOPLE','Tapiz dentro del catalogo MODERNA',50.00),(30,'Tapiz PEOPLE 20','Tapiz dentro del catalogo ERA',50.00),(31,'Espejo con arco de luz','Espejo con arco de luz interdo',80.00),(32,'Espejo con led','Espejo con luz led trasera',90.00),(33,'Espejo clasico','Espejo con diseno clasico',30.00),(34,'Espejo circular','Espejo con corte circular',100.00),(35,'Espejo Ovalado','Espejo con corte ovalado',150.00),(36,'Puerta para area social','Puerta de aluminio para areas sociales',1050.00),(37,'Pasamanos de seguridad','Pasamanos de aluminio de seguridad',50.00),(38,'Tapiz ECO','Tapiz dentro del catalogo BILLI BILLI',50.00),(39,'Tapiz MAR','Tapiz dentro del catalogo MODERNA',50.00),(40,'Tapiz EUROPA','Tapiz dentro del catalogo ERA',50.00),(41,'Tapiz NEW YORK','Tapiz dentro del catalogo BILLI BILLI',50.00),(42,'Tapiz PEOPLE PEOPLE','Tapiz dentro del catalogo MODERNA',50.00),(43,'Tapiz BILLI BILLI VK','Tapiz dentro del catalogo ERA',50.00),(44,'Espejo sin bisel','Espejo sencillo sin bisel',80.00),(45,'Espejo negro','Espejo titando de negro con luz led',90.00),(46,'Espejo con  focos','Espejo con focos en cuatro puntas',30.00),(47,'Espejo con marco','Espejo sencillo con marco de aluminior',100.00),(48,'Numero exterior','Vidrio tintado con vinil',5.00),(49,'Mosquitero','Tela mosquitera con marco de aluminio',1050.00),(50,'cancel exterior con mosquitero','Cancel corredizo para exterior con tela mosquitera',50.00);
/*!40000 ALTER TABLE `PRODUCTOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROMOCIONES`
--

DROP TABLE IF EXISTS `PROMOCIONES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROMOCIONES` (
  `id_promocion` int NOT NULL AUTO_INCREMENT,
  `nombre_promocion` varchar(50) NOT NULL,
  `tipo_promocion` enum('porcentual','cantidad') DEFAULT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_promocion`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROMOCIONES`
--

LOCK TABLES `PROMOCIONES` WRITE;
/*!40000 ALTER TABLE `PROMOCIONES` DISABLE KEYS */;
INSERT INTO `PROMOCIONES` VALUES (12,'Dia de la Independencia','cantidad',600.00),(16,'Dia de las madres','porcentual',0.50),(17,'Navidad','cantidad',700.00),(18,'Verano','cantidad',500.00),(19,'Invierno','porcentual',0.20),(20,'Primavera','cantidad',300.00),(21,'Otoño','porcentual',0.15),(22,'Fin de Año','cantidad',1000.00),(23,'San Valentin','porcentual',0.40),(24,'Halloween','cantidad',200.00),(25,'Año Nuevo','porcentual',0.35),(26,'Dia del Padre','porcentual',0.45),(27,'Dia de la Independencia','cantidad',600.00),(28,'Dia de los Muertos','porcentual',0.30),(29,'Cinco de Mayo','cantidad',250.00),(30,'Dia de la Revolución','porcentual',0.25);
/*!40000 ALTER TABLE `PROMOCIONES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROMOCIONES_APLICADAS`
--

DROP TABLE IF EXISTS `PROMOCIONES_APLICADAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROMOCIONES_APLICADAS` (
  `id_promocion_aplicada` int NOT NULL AUTO_INCREMENT,
  `promocion` int NOT NULL,
  `venta` int NOT NULL,
  PRIMARY KEY (`id_promocion_aplicada`),
  KEY `promocion` (`promocion`),
  KEY `venta` (`venta`),
  CONSTRAINT `PROMOCIONES_APLICADAS_ibfk_1` FOREIGN KEY (`promocion`) REFERENCES `PROMOCIONES` (`id_promocion`),
  CONSTRAINT `PROMOCIONES_APLICADAS_ibfk_2` FOREIGN KEY (`venta`) REFERENCES `VENTAS` (`id_venta`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROMOCIONES_APLICADAS`
--

LOCK TABLES `PROMOCIONES_APLICADAS` WRITE;
/*!40000 ALTER TABLE `PROMOCIONES_APLICADAS` DISABLE KEYS */;
INSERT INTO `PROMOCIONES_APLICADAS` VALUES (1,24,1);
/*!40000 ALTER TABLE `PROMOCIONES_APLICADAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ROLES`
--

DROP TABLE IF EXISTS `ROLES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ROLES` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) NOT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre_rol` (`nombre_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ROLES`
--

LOCK TABLES `ROLES` WRITE;
/*!40000 ALTER TABLE `ROLES` DISABLE KEYS */;
INSERT INTO `ROLES` VALUES (1,'Administrador'),(2,'Cliente'),(4,'Gerente'),(3,'Instalador'),(5,'Master');
/*!40000 ALTER TABLE `ROLES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TAPICES`
--

DROP TABLE IF EXISTS `TAPICES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TAPICES` (
  `id_tapiz` int NOT NULL AUTO_INCREMENT,
  `producto` int NOT NULL,
  PRIMARY KEY (`id_tapiz`),
  UNIQUE KEY `producto` (`producto`),
  CONSTRAINT `TAPICES_ibfk_1` FOREIGN KEY (`producto`) REFERENCES `PRODUCTOS` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TAPICES`
--

LOCK TABLES `TAPICES` WRITE;
/*!40000 ALTER TABLE `TAPICES` DISABLE KEYS */;
INSERT INTO `TAPICES` VALUES (1,4),(2,22),(3,23),(4,24),(5,25),(6,26),(7,27),(8,28),(9,29),(10,30),(11,38),(12,39),(13,40),(14,41),(15,42),(16,43);
/*!40000 ALTER TABLE `TAPICES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USUARIOS`
--

DROP TABLE IF EXISTS `USUARIOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USUARIOS` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `id_persona` int NOT NULL,
  `usuario` varchar(70) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `id_rol` int NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `id_persona` (`id_persona`),
  KEY `id_rol` (`id_rol`),
  KEY `usuario` (`usuario`),
  CONSTRAINT `USUARIOS_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `PERSONA` (`id_persona`),
  CONSTRAINT `USUARIOS_ibfk_2` FOREIGN KEY (`id_rol`) REFERENCES `ROLES` (`id_rol`),
  CONSTRAINT `USUARIOS_ibfk_3` FOREIGN KEY (`usuario`) REFERENCES `PERSONA` (`correo`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USUARIOS`
--

LOCK TABLES `USUARIOS` WRITE;
/*!40000 ALTER TABLE `USUARIOS` DISABLE KEYS */;
INSERT INTO `USUARIOS` VALUES (1,73,'pycarizpehdz@gmail.com','test',5),(2,74,'pamelita@gmail.com','test',5),(3,75,'thania123@gmail.com','test',5),(4,76,'deleon@outlook.com','test',5),(5,164,'aitanagl@yahoo.com','test',2),(6,171,'benjamingr@gmail.com','test',2),(7,176,'camilahl@yahoo.com','test',2),(8,170,'catalinamg@yahoo.com','test',2),(9,165,'diegolr@gmail.com','test',2),(10,157,'emilianohg@gmail.com','test',2),(11,167,'emiliomh@gmail.com','test',2),(12,172,'emmarl@yahoo.com','test',2),(13,162,'isabelagh@yahoo.com','test',2),(14,159,'joaquinmr@gmail.com','test',2),(15,161,'leonardolg@gmail.com','test',2),(16,173,'lucaslg@gmail.com','test',2),(17,166,'lunarg@yahoo.com','test',2),(18,174,'martinagm@yahoo.com','test',2),(19,175,'matiashh@gmail.com','test',2),(20,160,'renatarl@yahoo.com','test',2),(21,169,'santiagosm@gmail.com','test',2),(22,163,'tomashm@gmail.com','test',2),(23,168,'valentinahs2@yahoo.com','test',2),(24,158,'valeriagm@yahoo.com','test',2),(36,95,'abrilrg@yahoo.com','test',2),(37,86,'arturohm@gmail.com','test',2),(38,91,'camilamg@yahoo.com','test',2),(39,83,'catalinasg@yahoo.com','test',2),(40,90,'emiliosr@gmail.com','test',2),(41,94,'facundolm@gmail.com','test',2),(42,82,'felipegh@gmail.com','test',2),(43,87,'fernandalg@yahoo.com','test',2),(44,78,'gustavohs@yahoo.com','test',2),(45,85,'isabellagh@yahoo.com','test',2),(46,89,'julianagl@yahoo.com','test',2),(47,79,'lorenaml@yahoo.com','test',2),(48,77,'marcelagm@gmail.com','test',2),(49,84,'marianomg@gmail.com','test',2),(50,96,'mateogl@gmail.com','test',2),(51,88,'ricardorm@gmail.com','test',2),(52,80,'rodrigolr@gmail.com','test',2),(53,92,'sebastiangh@gmail.com','test',2),(54,93,'valentinahs@yahoo.com','test',2),(55,81,'valeriarfg@yahoo.com','test',2);
/*!40000 ALTER TABLE `USUARIOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VENTAS`
--

DROP TABLE IF EXISTS `VENTAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VENTAS` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `cotizacion` int NOT NULL,
  `usuario` int NOT NULL,
  `fecha_venta` date NOT NULL,
  `subtotal` int NOT NULL,
  `total_promocion` int DEFAULT NULL,
  `extras` int DEFAULT NULL,
  `notas` varchar(300) DEFAULT NULL,
  `total` int NOT NULL,
  `saldo` int NOT NULL,
  PRIMARY KEY (`id_venta`),
  UNIQUE KEY `cotizacion` (`cotizacion`),
  KEY `usuario` (`usuario`),
  CONSTRAINT `cotizacion` FOREIGN KEY (`cotizacion`) REFERENCES `COTIZACIONES` (`id_cotizacion`),
  CONSTRAINT `VENTAS_ibfk_1` FOREIGN KEY (`usuario`) REFERENCES `USUARIOS` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VENTAS`
--

LOCK TABLES `VENTAS` WRITE;
/*!40000 ALTER TABLE `VENTAS` DISABLE KEYS */;
INSERT INTO `VENTAS` VALUES (1,1,1,'2024-06-19',1500,200,100,'100 pesos extras por eleccion del diseño',1400,1400);
/*!40000 ALTER TABLE `VENTAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VIDRIOS`
--

DROP TABLE IF EXISTS `VIDRIOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VIDRIOS` (
  `id_vidrio` int NOT NULL AUTO_INCREMENT,
  `producto` int NOT NULL,
  `tipo` varchar(25) NOT NULL,
  PRIMARY KEY (`id_vidrio`),
  UNIQUE KEY `producto` (`producto`),
  CONSTRAINT `VIDRIOS_ibfk_1` FOREIGN KEY (`producto`) REFERENCES `PRODUCTOS` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VIDRIOS`
--

LOCK TABLES `VIDRIOS` WRITE;
/*!40000 ALTER TABLE `VIDRIOS` DISABLE KEYS */;
INSERT INTO `VIDRIOS` VALUES (1,2,'templado'),(2,3,'templado'),(3,5,'templado'),(4,7,'templado'),(5,12,'templado'),(6,13,'templado'),(7,14,'templado'),(8,15,'templado'),(9,16,'templado'),(10,17,'templado'),(11,18,'templado'),(12,19,'templado'),(13,20,'templado'),(14,21,'templado'),(15,31,'templado'),(16,32,'templado'),(17,33,'templado'),(18,34,'templado'),(19,35,'templado'),(20,44,'sencillo'),(21,45,'tintado'),(22,46,'sencillo'),(23,47,'sencillo'),(24,48,'sencillo');
/*!40000 ALTER TABLE `VIDRIOS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-20 18:29:34

DELIMITER //
CREATE TRIGGER after_insert_promocion_aplicada
AFTER INSERT ON PROMOCIONES_APLICADAS
FOR EACH ROW
BEGIN
    DECLARE promocion_tipo ENUM('porcentual','cantidad');
    DECLARE promocion_valor DECIMAL(10,2);
    DECLARE subtotal INT;

    -- Obtener el tipo y valor de la promoción
    SELECT tipo_promocion, valor INTO promocion_tipo, promocion_valor
    FROM PROMOCIONES
    WHERE id_promocion = NEW.promocion;

    -- Obtener el subtotal de la venta
    SELECT subtotal INTO subtotal
    FROM VENTAS
    WHERE id_venta = NEW.venta;

    -- Calcular el total de la promoción
    IF promocion_tipo = 'porcentual' THEN
        UPDATE VENTAS
        SET total_promocion = subtotal * promocion_valor,
            total = subtotal - (subtotal * promocion_valor),
            saldo = subtotal - (subtotal * promocion_valor)
        WHERE id_venta = NEW.venta;
    ELSEIF promocion_tipo = 'cantidad' THEN
        UPDATE VENTAS
        SET total_promocion = promocion_valor,
            total = subtotal - promocion_valor,
            saldo = subtotal - promocion_valor
        WHERE id_venta = NEW.venta;
    END IF;
END//
DELIMITER ;