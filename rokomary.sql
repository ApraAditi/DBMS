-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 25, 2024 at 07:39 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rokomary`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertAuthor` (IN `p_author_name` VARCHAR(50))   BEGIN
  INSERT INTO authors (author_name) VALUES (p_author_name);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertBook` (IN `p_author_id` INT, IN `p_title` VARCHAR(100))   BEGIN
  INSERT INTO books (author_id, title) VALUES (p_author_id, p_title);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE `authors` (
  `author_id` int(11) NOT NULL,
  `author_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`author_id`, `author_name`) VALUES
(1, 'George Orwell'),
(2, 'Jane Austen'),
(3, 'Mark Twain'),
(4, 'New Author Name'),
(5, 'New Author Name'),
(6, ' Jane Austen');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `book_id` int(11) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `title` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_id`, `author_id`, `title`) VALUES
(1, 1, '1984'),
(2, 1, 'Animal Farm'),
(3, 2, 'Pride and Prejudice'),
(4, 2, 'Sense and Sensibility'),
(5, 3, 'Adventures of Huckleberry Finn'),
(6, NULL, 'Unknown Book'),
(7, 1, ' Pride and Prejudice');

-- --------------------------------------------------------

--
-- Table structure for table `publishers`
--

CREATE TABLE `publishers` (
  `publisher_id` int(11) NOT NULL,
  `publisher_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `publishers`
--

INSERT INTO `publishers` (`publisher_id`, `publisher_name`) VALUES
(1, 'Penguin Books'),
(2, 'Oxford University Press'),
(3, 'HarperCollins');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sale_id` int(11) NOT NULL,
  `book_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`sale_id`, `book_id`, `quantity`) VALUES
(1, 1, 10),
(2, 2, 5),
(3, 3, 15),
(4, 4, 7),
(5, 5, 12),
(6, 6, 0),
(7, 1, 8),
(8, 2, 3),
(9, 3, 20);

--
-- Triggers `sales`
--
DELIMITER $$
CREATE TRIGGER `after_sales_insert` AFTER INSERT ON `sales` FOR EACH ROW BEGIN
  INSERT INTO `sales_log` (`book_id`, `quantity`) 
  VALUES (NEW.book_id, NEW.quantity);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sales_log`
--

CREATE TABLE `sales_log` (
  `log_id` int(11) NOT NULL,
  `book_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `log_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_log`
--

INSERT INTO `sales_log` (`log_id`, `book_id`, `quantity`, `log_date`) VALUES
(1, 1, 8, '2024-12-13 14:13:09'),
(2, 2, 3, '2024-12-13 14:13:09'),
(3, 3, 20, '2024-12-13 14:13:09');

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_book_details`
-- (See below for the actual view)
--
CREATE TABLE `view_book_details` (
`book_id` int(11)
,`book_title` varchar(100)
,`author_name` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_sales_summary`
-- (See below for the actual view)
--
CREATE TABLE `view_sales_summary` (
`book_id` int(11)
,`book_title` varchar(100)
,`total_quantity_sold` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Structure for view `view_book_details`
--
DROP TABLE IF EXISTS `view_book_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_book_details`  AS SELECT `b`.`book_id` AS `book_id`, `b`.`title` AS `book_title`, `a`.`author_name` AS `author_name` FROM (`books` `b` left join `authors` `a` on(`b`.`author_id` = `a`.`author_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `view_sales_summary`
--
DROP TABLE IF EXISTS `view_sales_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_sales_summary`  AS SELECT `b`.`book_id` AS `book_id`, `b`.`title` AS `book_title`, coalesce(sum(`s`.`quantity`),0) AS `total_quantity_sold` FROM (`books` `b` left join `sales` `s` on(`b`.`book_id` = `s`.`book_id`)) GROUP BY `b`.`book_id`, `b`.`title` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`author_id`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`),
  ADD KEY `author_id` (`author_id`);

--
-- Indexes for table `publishers`
--
ALTER TABLE `publishers`
  ADD PRIMARY KEY (`publisher_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sale_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `sales_log`
--
ALTER TABLE `sales_log`
  ADD PRIMARY KEY (`log_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authors`
--
ALTER TABLE `authors`
  MODIFY `author_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `publishers`
--
ALTER TABLE `publishers`
  MODIFY `publisher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `sales_log`
--
ALTER TABLE `sales_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
