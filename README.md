# Inventory and Sales Management System

> A comprehensive COBOL-based inventory and sales management system with real-time analytics and persistent data storage.

[![COBOL](https://img.shields.io/badge/COBOL-85-blue.svg)](https://www.ibm.com/docs/en/cobol-zos)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/status-active-success.svg)]()

## 🎯 Overview

This Inventory and Sales Management System is a robust COBOL application designed for small to medium-sized businesses to efficiently manage product inventories, track sales transactions, and generate comprehensive financial reports. The system leverages COBOL's powerful file handling capabilities to maintain persistent indexed and sequential data structures.

### Purpose
The system addresses core business needs including:
- Real-time inventory tracking and stock management
- Sales transaction recording and validation
- Revenue and profit analysis
- Business intelligence through dashboard metrics

## ✨ Features

### Core Functionality

#### 📦 Product Management
- **Add New Products**: Register products with unique IDs, pricing, and stock levels
- **Update Product Information**: Modify product details including name, cost, price, and stock
- **Delete Products**: Remove products from inventory with confirmation safeguards
- **View Product Details**: Access comprehensive product information including sales performance

#### 💰 Sales Operations
- **Record Sales Transactions**: Process sales with automatic stock deduction
- **Inventory Validation**: Real-time stock availability checking
- **Profit Calculation**: Automatic computation of revenue, costs, and profit margins
- **Transaction History**: Persistent storage of all sales records

#### 📊 Analytics & Reporting
- **Dashboard Summary**: Real-time overview of business metrics
  - Total products and stock levels
  - Cumulative revenue and profit
  - Overall profit margins
- **Income Statement**: Detailed sales breakdown with individual transaction analysis
- **Product Performance Reports**: 
  - Individual product revenue analysis
  - Comparative view of all products
  - Sales frequency and volume metrics

#### 🔧 System Management
- **Database Reset Options**: Secure reset functionality for sales and product databases
- **Cross-Platform Support**: Compatible with Windows and Unix-based systems
- **Data Validation**: Comprehensive input validation with error handling

## 🏗️ System Architecture

### High-Level Design

```
┌─────────────────────────────────────────────────────┐
│              User Interface Layer                   │
│  (Menu System, Input/Output Display Management)     │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│           Business Logic Layer                      │
│  (Validation, Calculations, Transaction Processing) │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│            Data Access Layer                        │
│     (File I/O Operations, Record Management)        │
└────────────────────┬────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼──────┐         ┌────────▼────────┐
│ PRODUCTS.DAT │         │   SALES.DAT     │
│  (Indexed)   │         │  (Sequential)   │
└──────────────┘         └─────────────────┘
```

### Component Breakdown

#### 1. **File Management System**
- **PRODUCTS.DAT** (Indexed Sequential File)
  - Organization: INDEXED
  - Access Mode: DYNAMIC
  - Key Field: P-PRODUCT-ID
  - Purpose: Fast product lookups and updates
  
- **SALES.DAT** (Sequential File)
  - Organization: SEQUENTIAL
  - Access Mode: SEQUENTIAL
  - Purpose: Append-only transaction log

#### 2. **Data Structures**

##### Product Record (P-PRODUCTS-RECORD)
```
Field                Type            Size
─────────────────────────────────────────
P-PRODUCT-ID        Alphanumeric    10
P-PRODUCT-NAME      Alphanumeric    30
P-COST-PER-UNIT     Numeric         9(6)V99
P-UNIT-PRICE        Numeric         9(6)V99
P-STOCK             Numeric         9(5)
P-DATE-ADDED        Numeric         9(8)
```

##### Sales Record (SALES-RECORD)
```
Field                Type            Size
─────────────────────────────────────────
S-PRODUCT-ID        Alphanumeric    10
S-PRODUCT-NAME      Alphanumeric    30
S-SOLD-UNITS        Numeric         9(5)
S-UNIT-PRICE        Numeric         9(6)V99
S-TOTAL-AMOUNT      Numeric         9(8)V99
S-COST-OF-GOODS     Numeric         9(8)V99
S-PROFIT            Numeric         9(8)V99
S-SALE-DATE         Numeric         9(8)
```

## 🔧 Technical Specifications

### Environment Requirements
- **COBOL Compiler**: GnuCOBOL 3.0+ or IBM COBOL
- **Operating System**: Windows 10/11, Linux, macOS, or Unix
- **Storage**: Minimum 10MB free disk space
- **Memory**: 512MB RAM minimum

### Key COBOL Features Utilized
- **Indexed File Organization**: O(log n) product lookups
- **Sequential File Processing**: Efficient transaction logging
- **Dynamic Access Mode**: Flexible record retrieval
- **Intrinsic Functions**: Modern COBOL computational capabilities
- **Screen Handling**: Cross-platform terminal operations

### Performance Characteristics
- **Product Search**: O(log n) via indexed file structure
- **Sales Recording**: O(1) append operation
- **Report Generation**: O(n) sequential scan
- **Dashboard Calculation**: O(n) for both product and sales files

## 💻 Installation

### Prerequisites
1. Install GnuCOBOL:

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install gnucobol
```

**macOS (using Homebrew):**
```bash
brew install gnucobol
```

**Windows:**
- Download from [GnuCOBOL Downloads](https://sourceforge.net/projects/gnucobol/)
- Follow the installation wizard

### Compilation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/inventory-management-cobol.git
cd inventory-management-cobol
```

2. Compile the program:
```bash
cobc -x -free PROJECT.cob -o inventory-system
```

**Compilation flags:**
- `-x`: Generate executable
- `-free`: Free-format COBOL source
- `-o`: Specify output filename

### Running the Application

**Unix/Linux/macOS:**
```bash
./inventory-system
```

**Windows:**
```cmd
inventory-system.exe
```

## 📖 Usage Guide

### Initial Setup

Upon first launch, the system automatically:
1. Creates `PRODUCTS.DAT` if it doesn't exist
2. Creates `SALES.DAT` if it doesn't exist
3. Initializes the dashboard with zero values

### Workflow Examples

#### Adding a Product
1. Select option `1` from main menu
2. Enter unique Product ID (e.g., `PROD001`)
3. Enter Product Name (e.g., `Laptop Computer`)
4. Enter Cost Per Unit (e.g., `45000.00`)
5. Enter Unit Price (e.g., `65000.00`)
6. Enter Stock Quantity (e.g., `50`)
7. Confirm or add another product

#### Recording a Sale
1. Select option `3` from main menu
2. Enter Product ID from displayed stock list
3. System displays product details and available stock
4. Enter quantity to sell
5. System validates stock availability
6. System automatically:
   - Calculates total sale amount
   - Computes profit
   - Updates product stock
   - Records transaction to SALES.DAT

#### Viewing Analytics
1. Select option `4` for Income Statement (all sales)
2. Select option `5` for Product Details:
   - Option `1`: Single product analysis
   - Option `2`: All products comparison

## 📁 File Structure

```
inventory-management-cobol/
│
├── PROJECT.cob           # Main source code
├── PRODUCTS.DAT          # Product database (auto-generated)
├── SALES.DAT             # Sales transactions (auto-generated)
├── README.md             # This file
├── LICENSE               # License information
└── docs/
    ├── USER_MANUAL.md    # Detailed user guide
    └── API_REFERENCE.md  # Internal paragraph documentation
```

## 🔄 Data Flow

### Product Addition Flow
```
User Input → Validation → Check Duplicate ID → 
Write to PRODUCTS.DAT → Confirmation Display
```

### Sales Transaction Flow
```
User Selects Product → Read PRODUCTS.DAT → 
Display Product Info → User Enters Quantity → 
Validate Stock → Calculate Amounts → 
Update Stock in PRODUCTS.DAT → 
Append to SALES.DAT → Display Receipt
```

### Dashboard Calculation Flow
```
Initialize Totals → Read All PRODUCTS.DAT → 
Sum Stock Values → Read All SALES.DAT → 
Sum Revenue/Profit → Calculate Margins → 
Display Summary
```

## 🛡️ Error Handling

The system implements comprehensive validation:

### Input Validation
- **Numeric Fields**: Rejects non-numeric input for quantities and prices
- **Required Fields**: Prevents empty submissions
- **Negative Values**: Blocks negative quantities and prices
- **Duplicate IDs**: Prevents product ID conflicts

### File Operations
- **File Status Checking**: Monitors all file operations
- **Graceful Degradation**: Creates missing files automatically
- **Transaction Integrity**: Validates writes before confirming

### User Experience
- **Cancel Options**: User can abort operations at any validation step
- **Retry Mechanism**: Allows correction of invalid inputs
- **Clear Error Messages**: Descriptive feedback for all errors

## 🔐 Security Considerations

- **Data Persistence**: Files stored in local directory
- **No Authentication**: Single-user system design
- **Deletion Safeguards**: Confirmation required for destructive operations
- **Backup Recommendation**: Manual backup of .DAT files recommended

## 🚀 Future Enhancements

Potential improvements for future versions:
- [ ] Multi-user support with file locking
- [ ] Export reports to CSV/PDF
- [ ] Date range filtering for reports
- [ ] Product categories and search functionality
- [ ] Barcode integration
- [ ] Inventory alert thresholds
- [ ] Customer management module
- [ ] Return/refund transaction handling

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards
- Follow COBOL-85 standards
- Use meaningful paragraph names
- Comment complex logic
- Test all validation paths

## 👥 Authors

**Group 4 - DIT 2-1**
- Andador
- Lipata
- Lopez
- Cruz

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- COBOL community for documentation and support
- GnuCOBOL project for the free compiler
- Educational institution for project guidance

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact: [your-email@example.com]
- Documentation: See `docs/` folder

---

**Last Updated**: January 2026  
**Version**: 1.0.0  
**Status**: Production Ready