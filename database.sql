-- MySQL dump 10.13  Distrib 8.0.45, for macos26.2 (arm64)
--
-- Host: localhost    Database: oka_iki_indonesia
-- ------------------------------------------------------
-- Server version	8.0.45

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

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
INSERT INTO `cache` VALUES ('laravel-cache-5875ae354a52ab6d4be2b4ac5cc9cd25','i:1;',1780815729),('laravel-cache-5875ae354a52ab6d4be2b4ac5cc9cd25:timer','i:1780815729;',1780815729),('laravel-cache-88df0ebeda0c8701842b6fe124628b75','i:1;',1780816077),('laravel-cache-88df0ebeda0c8701842b6fe124628b75:timer','i:1780816077;',1780816077);
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_tenants_table',1),(2,'0001_01_01_000000_create_users_table',1),(3,'0001_01_01_000001_create_cache_table',1),(4,'0001_01_01_000002_create_jobs_table',1),(5,'2026_06_05_145328_create_products_table',1),(6,'2026_06_05_145354_create_transactions_table',1),(7,'2026_06_05_145407_create_transaction_items_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint unsigned NOT NULL,
  `item_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `products_tenant_id_foreign` (`tenant_id`),
  CONSTRAINT `products_tenant_id_foreign` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Coffee Beans','PROD-A001',15000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(2,1,'Tea Leaves','PROD-A002',20000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(3,1,'Brown Sugar','PROD-A003',25000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(4,1,'Fresh Milk','PROD-A004',30000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(5,1,'Vanilla Syrup','PROD-A005',35000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(6,1,'Cocoa Powder','PROD-A006',40000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(7,1,'Caramel Sauce','PROD-A007',45000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(8,1,'Paper Cups','PROD-A008',50000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(9,2,'Laptop Acer','PROD-B001',50000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(10,2,'Mouse Logitech','PROD-B002',200000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(11,2,'Keyboard Mechanical','PROD-B003',350000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(12,2,'Monitor Dell 24','PROD-B004',500000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(13,2,'USB Flashdrive 64GB','PROD-B005',650000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(14,2,'HDMI Cable 2M','PROD-B006',800000.00,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('4FpIjdfn24UGIb9sl43loBLoSuAPHwUEIGrSLnyR',1,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36','eyJfdG9rZW4iOiI4SURpa3VYWm1TNDE2UUd2TVpPQldzYjNTV3ozSWpQbWxLRTRaZnh5IiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJ1cmwiOltdLCJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI6MSwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC90ZWNobmljYWwtdGVzdC1sYXJhdmVsLnRlc3RcL2Rhc2hib2FyZCIsInJvdXRlIjoiZGFzaGJvYXJkIn19',1780816523);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenants`
--

DROP TABLE IF EXISTS `tenants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenants` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referral_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenants`
--

LOCK TABLES `tenants` WRITE;
/*!40000 ALTER TABLE `tenants` DISABLE KEYS */;
INSERT INTO `tenants` VALUES (1,'Sinar Jaya Corp','SJ8Nk1IF','2026-06-06 23:48:25','2026-06-06 23:48:25'),(2,'Abadi Jaya Mandiri','AJM88K2S','2026-06-06 23:48:25','2026-06-06 23:48:25');
/*!40000 ALTER TABLE `tenants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_items`
--

DROP TABLE IF EXISTS `transaction_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned DEFAULT NULL,
  `qty` int NOT NULL,
  `price_at_transaction` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transaction_items_transaction_id_foreign` (`transaction_id`),
  KEY `transaction_items_product_id_foreign` (`product_id`),
  CONSTRAINT `transaction_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `transaction_items_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_items`
--

LOCK TABLES `transaction_items` WRITE;
/*!40000 ALTER TABLE `transaction_items` DISABLE KEYS */;
INSERT INTO `transaction_items` VALUES (1,1,2,1,20000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(2,2,3,4,25000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(3,2,6,3,40000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(4,3,2,4,20000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(5,3,7,3,45000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(6,3,8,1,50000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(7,4,1,4,15000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(8,4,3,3,25000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(9,4,8,4,50000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(10,5,5,3,35000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(11,6,2,3,20000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(12,6,8,3,50000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(13,7,1,3,15000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(14,8,6,1,40000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(15,9,2,4,20000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(16,9,4,4,30000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(17,9,7,3,45000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(18,10,1,1,15000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(19,10,4,3,30000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(20,10,7,3,45000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(21,11,3,4,25000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(22,12,1,4,15000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(23,12,3,2,25000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(24,12,6,4,40000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(25,13,12,1,500000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(26,13,14,1,800000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(27,14,10,2,200000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(28,14,12,2,500000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(29,15,12,2,500000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(30,15,13,1,650000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(31,16,11,2,350000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(32,16,13,1,650000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(33,17,9,1,50000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(34,17,11,1,350000.00,'2026-06-06 23:48:25','2026-06-06 23:48:25');
/*!40000 ALTER TABLE `transaction_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `customer_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `trans_date` datetime NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transactions_tenant_id_foreign` (`tenant_id`),
  KEY `transactions_user_id_foreign` (`user_id`),
  CONSTRAINT `transactions_tenant_id_foreign` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,1,1,'Customer A',20000.00,'2026-05-27 06:48:25','TX-A-0001','2026-06-06 23:48:25','2026-06-06 23:48:25'),(2,1,1,'Customer B',220000.00,'2026-05-28 06:48:25','TX-A-0002','2026-06-06 23:48:25','2026-06-06 23:48:25'),(3,1,1,'Customer C',265000.00,'2026-05-29 06:48:25','TX-A-0003','2026-06-06 23:48:25','2026-06-06 23:48:25'),(4,1,1,'Customer D',335000.00,'2026-05-30 06:48:25','TX-A-0004','2026-06-06 23:48:25','2026-06-06 23:48:25'),(5,1,1,'Customer E',105000.00,'2026-05-31 06:48:25','TX-A-0005','2026-06-06 23:48:25','2026-06-06 23:48:25'),(6,1,1,'Customer F',210000.00,'2026-06-01 06:48:25','TX-A-0006','2026-06-06 23:48:25','2026-06-06 23:48:25'),(7,1,1,'Customer G',45000.00,'2026-06-02 06:48:25','TX-A-0007','2026-06-06 23:48:25','2026-06-06 23:48:25'),(8,1,1,'Customer H',40000.00,'2026-06-03 06:48:25','TX-A-0008','2026-06-06 23:48:25','2026-06-06 23:48:25'),(9,1,1,'Customer I',335000.00,'2026-06-04 06:48:25','TX-A-0009','2026-06-06 23:48:25','2026-06-06 23:48:25'),(10,1,1,'Customer J',240000.00,'2026-06-05 06:48:25','TX-A-0010','2026-06-06 23:48:25','2026-06-06 23:48:25'),(11,1,1,'Customer K',100000.00,'2026-06-06 06:48:25','TX-A-0011','2026-06-06 23:48:25','2026-06-06 23:48:25'),(12,1,1,'Customer L',270000.00,'2026-06-07 06:48:25','TX-A-0012','2026-06-06 23:48:25','2026-06-06 23:48:25'),(13,2,3,'Client P',1300000.00,'2026-06-03 06:48:25','TX-B-0001','2026-06-06 23:48:25','2026-06-06 23:48:25'),(14,2,3,'Client Q',1400000.00,'2026-06-04 06:48:25','TX-B-0002','2026-06-06 23:48:25','2026-06-06 23:48:25'),(15,2,3,'Client R',1650000.00,'2026-06-05 06:48:25','TX-B-0003','2026-06-06 23:48:25','2026-06-06 23:48:25'),(16,2,3,'Client S',1350000.00,'2026-06-06 06:48:25','TX-B-0004','2026-06-06 23:48:25','2026-06-06 23:48:25'),(17,2,3,'Client T',400000.00,'2026-06-07 06:48:25','TX-B-0005','2026-06-06 23:48:25','2026-06-06 23:48:25');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'staff',
  `is_accepted` tinyint(1) NOT NULL DEFAULT '0',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_tenant_id_foreign` (`tenant_id`),
  CONSTRAINT `users_tenant_id_foreign` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Budi','owner@sinarjaya.com','$2y$12$8JwDrNBv34ij.MzBauCAaeUIFL7zuJQdP75r6jfo8aV/tZFjx/nNK','owner',1,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(2,1,'Andi','staff@sinarjaya.com','$2y$12$y1kjwjFh0O22LjxKmVLAJ.yfilwJEzNkEWFK3R4aTZHPHGulSXv9q','staff',1,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:53'),(3,2,'Siti','owner@abadijaya.com','$2y$12$YiNg3qkPoew4oN8.x0ADL.SX6PDqUfNh2/WNLw2lVYEYNMdw/O.8u','owner',1,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25'),(4,2,'Joko','staff@abadijaya.com','$2y$12$BKK8d2AyPrrY0xRW7w0zQ.bYVY6inOiixJkGXbHttc7Wf4/FLWC6m','staff',0,NULL,'2026-06-06 23:48:25','2026-06-06 23:48:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-07 14:20:38
