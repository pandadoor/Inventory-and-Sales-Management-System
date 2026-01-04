# Inventory & Sales Management System (COBOL)

A robust, enterprise-logic terminal application for managing product inventory and tracking sales performance. Developed as a group project by **Group 4 (DIT 2-1)**.

## 👥 The Team (Group 4)
* **Andador**
* **Lipata**
* **Lopez**
* **Cruz**

---

## 🚀 Overview
This system provides a comprehensive suite for retail operations, including real-time stock monitoring, automated financial calculations, and a management dashboard. It leverages COBOL's strengths in high-precision decimal arithmetic and structured data handling.

### 🛠 Key Technical Features
* **Dual-File Architecture:**
    * **Products Database (`PRODUCTS.DAT`):** Uses **INDEXED** organization with **DYNAMIC** access, allowing for instantaneous product lookups via a unique Product ID.
    * **Sales Database (`SALES.DAT`):** Uses **SEQUENTIAL** organization to maintain a reliable audit trail of every transaction.
* **Financial Precision:** Implemented using `S9(6)V99` picture clauses to ensure that profit margins and revenues are calculated with absolute accuracy, avoiding the floating-point errors common in other languages.
* **Smart Dashboard:** Automatically calculates Total Revenue, Net Profit, and **Profit Margins (%)** every time the main menu is loaded.
* **Cross-Platform Database Tools:** Includes built-in reset functionality compatible with both **Windows (DEL)** and **Unix/Linux (RM)** environments.

---

## 📊 System Modules
1. **Product Management:** Add new items, update existing details, or delete discontinued stock.
2. **Sales Recording:** Automated stock decrementing when a sale is recorded, including cost-of-goods-sold (COGS) tracking.
3. **Income Statement:** A detailed financial report showing per-item profitability and overall business health.
4. **Validation Engine:** Robust input handling that prevents negative stock, empty IDs, or non-numeric prices.

---

## 💻 How to Run

### Prerequisites
* **GnuCOBOL** (OpenCOBOL) compiler.

### Compilation
Open your terminal and run:
```bash
cobc -x -o inventory PROJECT.CBL