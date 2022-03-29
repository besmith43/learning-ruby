-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 23, 2014 at 06:40 AM
-- Server version: 5.5.40-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `bookstore_development`
--

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE IF NOT EXISTS `authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`id`, `first_name`, `last_name`, `created_at`, `updated_at`) VALUES
(1, 'Scott ', 'Raymond', '2014-10-22 21:01:13', '2014-10-22 21:01:13'),
(2, 'Aneesha', 'Bakharia', '2014-10-22 21:30:51', '2014-10-22 21:30:51'),
(3, 'Jason', 'Gilmore', '2014-10-23 12:55:13', '2014-10-23 12:55:13');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE IF NOT EXISTS `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `publisher_id` int(11) DEFAULT NULL,
  `isbn` varchar(255) DEFAULT NULL,
  `year` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `buy` varchar(255) DEFAULT NULL,
  `excerpt` text,
  `format` varchar(255) DEFAULT NULL,
  `pages` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `coverpath` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `title`, `category_id`, `author_id`, `publisher_id`, `isbn`, `year`, `price`, `buy`, `excerpt`, `format`, `pages`, `created_at`, `updated_at`, `coverpath`) VALUES
(1, 'Ajax on Rails', 1, 1, 1, '0596527446', '2011', '$9.99', 'http://www.ebay.com/itm/Ajax-on-Rails-by-Scott-Raymond-2007-Paperback-BUILD-DYNAMIC-WEB-APPS-RUBY-BOOK-/151434291155?pt=US_Texbook_Education&hash=item23422fe7d3', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam rhoncus elementum purus quis elementum. Vestibulum in nisi non est interdum aliquam id nec ipsum. Suspendisse ultricies finibus dapibus. Quisque risus tellus, hendrerit eleifend lacus ac, tincidunt porttitor dui. Nam non erat sed sapien egestas ullamcorper. Cras sagittis mi enim, id ultricies enim pharetra vitae. Vestibulum vulputate lectus sed dictum venenatis. Duis imperdiet, eros in luctus dictum, nibh est vestibulum augue, et semper tortor sapien sed odio. In arcu quam, molestie ut turpis vitae, interdum dapibus nibh. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum eu maximus massa. Mauris placerat vulputate risus eget hendrerit. Proin nulla massa, gravida ut nisl nec, porttitor imperdiet ex. ', 'Paperback', 495, '2014-10-22 21:20:03', '2014-10-23 13:09:45', 'covers/ajax_on_rails.jpg'),
(2, 'Ruby On Rails Power', 1, 2, 2, '1598632167', '2007', '$17.95', 'http://www.ebay.com/itm/Ruby-on-Rails-Power-The-Comprehensive-Guide-by-Aneesha-Bakharia-2007-/381005891559?pt=US_Texbook_Education&hash=item58b5b887e7', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam rhoncus elementum purus quis elementum. Vestibulum in nisi non est interdum aliquam id nec ipsum. Suspendisse ultricies finibus dapibus. Quisque risus tellus, hendrerit eleifend lacus ac, tincidunt porttitor dui. Nam non erat sed sapien egestas ullamcorper. Cras sagittis mi enim, id ultricies enim pharetra vitae. Vestibulum vulputate lectus sed dictum venenatis. Duis imperdiet, eros in luctus dictum, nibh est vestibulum augue, et semper tortor sapien sed odio. In arcu quam, molestie ut turpis vitae, interdum dapibus nibh. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum eu maximus massa. Mauris placerat vulputate risus eget hendrerit. Proin nulla massa, gravida ut nisl nec, porttitor imperdiet ex. ', 'Paperback', 465, '2014-10-22 21:34:28', '2014-10-22 21:34:28', 'covers/ruby_on_rails_power.jpg'),
(3, 'Beginning PHP 5', 2, 3, 3, '1893115518', '2004', '$12.00', 'http://www.ebay.com/itm/Beginning-PHP-5-and-MySQL-by-W-Jason-Gilmore-2004-Paperback-New-Edition-/131307427455?pt=US_Texbook_Education&hash=item1e9288567f', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam rhoncus elementum purus quis elementum. Vestibulum in nisi non est interdum aliquam id nec ipsum. Suspendisse ultricies finibus dapibus. Quisque risus tellus, hendrerit eleifend lacus ac, tincidunt porttitor dui. Nam non erat sed sapien egestas ullamcorper. Cras sagittis mi enim, id ultricies enim pharetra vitae. Vestibulum vulputate lectus sed dictum venenatis. Duis imperdiet, eros in luctus dictum, nibh est vestibulum augue, et semper tortor sapien sed odio. In arcu quam, molestie ut turpis vitae, interdum dapibus nibh. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum eu maximus massa. Mauris placerat vulputate risus eget hendrerit. Proin nulla massa, gravida ut nisl nec, porttitor imperdiet ex. ', 'Paperback', 420, '2014-10-23 12:56:35', '2014-10-23 12:56:35', 'covers/beginning_php_5.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Ruby On Rails', '2014-10-22 14:15:06', '2014-10-22 14:15:06'),
(2, 'PHP', '2014-10-22 14:17:06', '2014-10-22 14:17:06'),
(3, 'HTML5', '2014-10-22 20:59:28', '2014-10-22 20:59:28');

-- --------------------------------------------------------

--
-- Table structure for table `publishers`
--

CREATE TABLE IF NOT EXISTS `publishers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `publishers`
--

INSERT INTO `publishers` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'O''Reilly Media, Incorporated', '2014-10-22 21:18:16', '2014-10-22 21:18:16'),
(2, 'Course Technology', '2014-10-22 21:31:13', '2014-10-22 21:31:13'),
(3, 'Apress L. P.', '2014-10-23 12:55:27', '2014-10-23 12:55:27');

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `schema_migrations`
--

INSERT INTO `schema_migrations` (`version`) VALUES
('20141022135022'),
('20141022135609'),
('20141022135823'),
('20141022135905'),
('20141022135931'),
('20141022212246');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
