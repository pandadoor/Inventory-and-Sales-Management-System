       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROJECT.
       AUTHOR. GROUP 4: ANDADOR, LIPATA, LOPEZ, and CRUZ. DIT 2-1.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.   
       FILE-CONTROL.
           SELECT P-PRODUCTS-FILE ASSIGN TO "PRODUCTS.DAT"
      *            INDEXED file (binary format, for faster search)
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS P-PRODUCT-ID
               FILE STATUS IS P-PRODUCTS-STATUS.
              
           SELECT S-SALES-FILE ASSIGN TO "SALES.DAT"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS S-SALES-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  P-PRODUCTS-FILE.
       01  P-PRODUCTS-RECORD.
           05  P-PRODUCT-ID            PIC X(10).
           05  P-PRODUCT-NAME          PIC X(30).
           05  P-COST-PER-UNIT         PIC S9(6)V99.
           05  P-UNIT-PRICE            PIC S9(6)V99.
           05  P-STOCK                 PIC S9(5).
           05  P-DATE-ADDED            PIC S9(8).
           
       FD  S-SALES-FILE.
       01  SALES-RECORD.
           05  S-PRODUCT-ID            PIC X(10).
           05  S-PRODUCT-NAME          PIC X(30).
           05  S-SOLD-UNITS            PIC S9(5).
           05  S-UNIT-PRICE            PIC S9(6)V99.
           05  S-TOTAL-AMOUNT          PIC S9(8)V99.
           05  S-COST-OF-GOODS         PIC S9(8)V99.
           05  S-PROFIT                PIC S9(8)V99.
           05  S-SALE-DATE             PIC S9(8).

       WORKING-STORAGE SECTION.
       01  MAIN-CHOICE                 PIC S9(9).
       01  P-UPDATE-CHOICE             PIC S9(9).
       01  IS-CHOICE                   PIC S9(9).
       01  RESET-SALES                 PIC A.
       01  RESET-PRODUCTS              PIC A.
       01  CONTINUE-ANOTHER            PIC A.
       01  CONTINUE-SALE               PIC A.

       01  WS-FIELD-INFO.
           05 WS-FIELD-NAME        PIC X(30).
           05 WS-FIELD-VALUE       PIC X(30).

       01  WS-VALIDATION-FLAGS.
           05 WS-IS-VALID          PIC X VALUE 'N'.
              88 VALID-INPUT       VALUE 'Y'.
              88 INVALID-INPUT     VALUE 'N'.
           05 WS-USER-CHOICE       PIC X.
              88 USER-CANCELLED    VALUE 'N' 'n'.
              88 USER-RETRY        VALUE 'Y' 'y' SPACE.

       01  P-PRODUCTS-STATUS           PIC XX.
           88  PRODUCTS-OK             VALUE "00".
           88  PRODUCTS-EOF            VALUE "10".
           
       01  S-SALES-STATUS              PIC XX.
           88  SALES-OK                VALUE "00".
           88  SALES-EOF               VALUE "10".
           
       01  INPUT-FIELDS.
           05  I-PRODUCT-ID            PIC X(10).
           05  I-PRODUCT-NAME          PIC X(30).
           05  I-COST-PER-UNI          PIC S9(6)V99.
           05  I-UNIT-PRICE            PIC S9(6)V99.
           05  I-STOCK                 PIC S9(5).
           05  I-SOLD-UNITS            PIC S9(5).
           
       01  DASHBOARD-TOTALS.
           05  DT-TOTAL-PRODUCTS       PIC S9(5) VALUE ZERO.
           05  DT-TOTAL-STOCK          PIC S9(8) VALUE ZERO.
           05  DT-TOTAL-REVENUE        PIC S9(10)V99 VALUE ZERO.
           05  DT-TOTAL-PROFIT         PIC S9(10)V99 VALUE ZERO.
           05  DT-TOTAL-QTY-SOLD       PIC S9(8) VALUE ZERO.
           05  DT-PROFIT-MARGIN        PIC S9(3)V99 VALUE ZERO.
           
       01  CALCULATION-FIELDS.
           05  CF-SALE-AMOUNT          PIC S9(8)V99.
           05  CF-COST-AMOUNT          PIC S9(8)V99.
           05  CF-PROFIT-AMOUNT        PIC S9(8)V99.
           
       01  DISPLAY-FIELD.
           05 DF-PUNIT-PRICE           PIC ZZZ,ZZZ,ZZ9.99.
           05  DF-DISP-AMOUNT          PIC ZZZ,ZZZ,ZZ9.99.
           05  DF-DISP-QTY             PIC ZZZ,ZZ9.
           05  DF-DISP-PERCENTAGE      PIC ZZ9.99.
           05  DF-S-PROFIT             PIC ZZZ,ZZZ,ZZ9.99.
           05  DF-PSTOCK               PIC ZZZZZZ.
           05  DF-PCOST-PER-UNIT       PIC ZZZ,ZZZ,ZZ9.99.
           
       01  CURRENT-DATE.
           05  CD-YEAR                 PIC 9(4).
           05  CD-MONTH                PIC 9(2).
           05  CD-DAY                  PIC 9(2).
       01  DATE-DISPLAY                PIC ZZ,ZZ,ZZZZ.

       PROCEDURE DIVISION.
       MENU-MAIN.
           PERFORM CLEAR-SCREEN.
           PERFORM DISPLAY-DASHBOARD.
           PERFORM STOCK-DISPLAY.
           DISPLAY "            CURRENT DATE: " DATE-DISPLAY.
           DISPLAY "=================================================="
           DISPLAY "|    INVENTORY AND SALES MANAGEMENT SYSTEM       |".
           DISPLAY "|------------------------------------------------|"
           DISPLAY "| 1. Add new product                             |".
           DISPLAY "| 2. Update product information                  |".
           DISPLAY "| 3. Record a sale                               |".
           DISPLAY "| 4. Income statement                            |".
           DISPLAY "| 5. Reset Sales Database                        |".
           DISPLAY "| 6. Reset Products Database                     |".
           DISPLAY "|                                                |".
           DISPLAY "| 9. Exit                                        |".
           DISPLAY "==================================================".
           DISPLAY "Please select an option: " WITH NO ADVANCING.
           ACCEPT MAIN-CHOICE.

           EVALUATE MAIN-CHOICE
                WHEN 1
                    PERFORM CLEAR-SCREEN
                    PERFORM PRODUCT-ADD
                WHEN 2
                    PERFORM CLEAR-SCREEN
                    PERFORM UPDATE-PRODUCT-MENU
                WHEN 3
                    PERFORM CLEAR-SCREEN
                    PERFORM RECORD-SALES
                WHEN 4
                    PERFORM CLEAR-SCREEN
                    PERFORM INCOME-STATEMENT
                WHEN 5
                    PERFORM SALES-RESET
                WHEN 6
                    PERFORM CLEAR-SCREEN
                    PERFORM PRODUCTS-RESET
                WHEN 9
                    PERFORM PROG-TERMINATE
                WHEN OTHER
                    PERFORM MENU-MAIN
           END-EVALUATE.

      *                        PRODUCT ADD AND UPDATE
       PRODUCT-ADD.
           PERFORM STOCK-DISPLAY
           DISPLAY "=================================================="
           DISPLAY "                 ADD NEW PRODUCT"
           DISPLAY "=================================================="
           
           MOVE "Enter Product ID" TO WS-FIELD-NAME
           PERFORM GET-TEXT-INPUT
               IF USER-CANCELLED
                    PERFORM CLEAR-SCREEN
                    DISPLAY "                Cancelled."
                    PERFORM MENU-MAIN
               END-IF
               MOVE WS-FIELD-VALUE TO I-PRODUCT-ID

               MOVE I-PRODUCT-ID TO P-PRODUCT-ID
               READ P-PRODUCTS-FILE
                   INVALID KEY CONTINUE
                   NOT INVALID KEY
                       PERFORM CLEAR-SCREEN
                       PERFORM SHOW-VALIDATION-ERROR

                   IF USER-CANCELLED 
                       PERFORM CLEAR-SCREEN
                       DISPLAY "                Cancelled."
                       PERFORM MENU-MAIN
                   ELSE
                       PERFORM CLEAR-SCREEN
                       PERFORM PRODUCT-ADD
                   END-IF
               END-READ
           
               MOVE "Enter Product Name" TO WS-FIELD-NAME
               PERFORM GET-TEXT-INPUT
                   IF USER-CANCELLED 
                       PERFORM CLEAR-SCREEN
                       DISPLAY "                Cancelled."
                       PERFORM MENU-MAIN
                   END-IF
               MOVE WS-FIELD-VALUE TO I-PRODUCT-NAME
    
               MOVE "Enter Cost Per Unit" TO WS-FIELD-NAME
               PERFORM GET-NUMERIC-INPUT
                   IF USER-CANCELLED
                    PERFORM CLEAR-SCREEN
                    DISPLAY "                Cancelled."
                    PERFORM MENU-MAIN
               END-IF
               MOVE FUNCTION NUMVAL(WS-FIELD-VALUE) TO I-COST-PER-UNI
          

           MOVE "Enter Unit Price" TO WS-FIELD-NAME
           PERFORM GET-NUMERIC-INPUT
               IF USER-CANCELLED
                    PERFORM CLEAR-SCREEN
                    DISPLAY "                Cancelled."
                    PERFORM MENU-MAIN
               END-IF
               MOVE FUNCTION NUMVAL(WS-FIELD-VALUE) TO I-UNIT-PRICE
        
           MOVE "Enter Stock Quantity: " TO WS-FIELD-NAME
           PERFORM GET-NUMERIC-INPUT
               IF USER-CANCELLED
                    PERFORM CLEAR-SCREEN
                    DISPLAY "                Cancelled."
                    PERFORM MENU-MAIN
               END-IF
               MOVE FUNCTION NUMVAL(WS-FIELD-VALUE) TO I-STOCK
           
           DISPLAY "Add another products? (Y/N)"
           DISPLAY "Enter Choice: " WITH NO ADVANCING 
           ACCEPT CONTINUE-ANOTHER 

           IF CONTINUE-ANOTHER = 'Y' OR CONTINUE-ANOTHER = 'y'
               PERFORM SAVE-PRODUCT
               PERFORM CLEAR-SCREEN
               PERFORM PRODUCT-ADD
            ELSE 
               PERFORM SAVE-PRODUCT
               DISPLAY SPACE
               PERFORM MENU-MAIN
           END-IF. 

       UPDATE-PRODUCT-MENU.
           PERFORM STOCK-DISPLAY.
           DISPLAY SPACE.
           DISPLAY "=================================================="
           DISPLAY "                  UPDATE PRODUCT"
           DISPLAY "--------------------------------------------------"
           DISPLAY "1. Delete Product"
           DISPLAY "2. Update Product Details"
           DISPLAY SPACE.
           DISPLAY "9. Return"
           DISPLAY "=================================================="
           DISPLAY "Enter your choice: " WITH NO ADVANCING
           ACCEPT P-UPDATE-CHOICE
           
           EVALUATE P-UPDATE-CHOICE
               WHEN 1 
                   PERFORM CLEAR-SCREEN
                   PERFORM DELETE-PRODUCT
               WHEN 2
                   PERFORM CLEAR-SCREEN
                   PERFORM UPDATE-PRODUCT-DETAILS
               WHEN 9 
                   PERFORM MENU-MAIN
               WHEN OTHER
                   PERFORM CLEAR-SCREEN
                   DISPLAY "                 Invalid option!"
                   PERFORM UPDATE-PRODUCT-MENU
           END-EVALUATE
           DISPLAY SPACE.
           
       DELETE-PRODUCT.
           PERFORM STOCK-DISPLAY
           MOVE "Enter Product ID to delete" TO WS-FIELD-NAME
           PERFORM GET-TEXT-INPUT
               IF USER-CANCELLED
                    PERFORM CLEAR-SCREEN
                    DISPLAY "                Cancelled."
                    PERFORM UPDATE-PRODUCT-MENU
               END-IF
               MOVE WS-FIELD-VALUE TO I-PRODUCT-ID

           MOVE I-PRODUCT-ID TO P-PRODUCT-ID
           READ P-PRODUCTS-FILE
               INVALID KEY
                    PERFORM CLEAR-SCREEN
                    PERFORM SHOW-VALIDATION-ERROR
               IF USER-CANCELLED
                    PERFORM CLEAR-SCREEN
                    DISPLAY "                 Delete cancelled."
                    PERFORM UPDATE-PRODUCT-MENU
               ELSE
                    PERFORM CLEAR-SCREEN
                    PERFORM DELETE-PRODUCT
               END-IF

               NOT INVALID KEY
                   DISPLAY "Product found: " P-PRODUCT-NAME
                   DISPLAY "Delete (Y), else cancel: " WITH NO ADVANCING
                   ACCEPT CONTINUE-ANOTHER
                   
                   IF CONTINUE-ANOTHER = "Y" OR CONTINUE-ANOTHER = "y"
                      DELETE P-PRODUCTS-FILE
                      PERFORM CLEAR-SCREEN
                      PERFORM STOCK-DISPLAY
                      DISPLAY "     Product deleted successfully!"
       
      *          ASKS WHETHER TO CONTINUE DELETING PRODUCTS OR NOT
                         DISPLAY "Delete another products? (Y/N)"
                         DISPLAY "Enter Choice: " WITH NO ADVANCING 
                         ACCEPT CONTINUE-ANOTHER 
   
                     IF CONTINUE-ANOTHER = 'Y' OR CONTINUE-ANOTHER = 'y'
                         PERFORM CLEAR-SCREEN
                         PERFORM DELETE-PRODUCT
                     ELSE 
                        PERFORM CLEAR-SCREEN 
                        PERFORM UPDATE-PRODUCT-MENU
                     END-IF                       
                  ELSE
                       PERFORM CLEAR-SCREEN
                       DISPLAY "                 Delete cancelled."
                       PERFORM UPDATE-PRODUCT-MENU
                   END-IF
           END-READ.

       UPDATE-PRODUCT-DETAILS.
           PERFORM SELECT-PRODUCT.
           IF USER-CANCELLED
               PERFORM CLEAR-SCREEN
               DISPLAY "                 Delete cancelled."
               PERFORM SELECT-PRODUCT
           END-IF
           
           DISPLAY SPACES
           DISPLAY "==========CURRENT PRODUCT DETAILS=========="
           MOVE P-COST-PER-UNIT TO DF-PCOST-PER-UNIT
           MOVE P-STOCK TO DF-PSTOCK
           MOVE P-UNIT-PRICE TO DF-PUNIT-PRICE
           DISPLAY "Product ID             : " P-PRODUCT-ID
           DISPLAY "Name                   : " P-PRODUCT-NAME
           DISPLAY "Cost Per Unit          : ₱" DF-PCOST-PER-UNIT
           DISPLAY "Unit Price             : ₱" DF-PUNIT-PRICE
           DISPLAY "Stock                  : " DF-PSTOCK
           DISPLAY "==========================================="
           DISPLAY SPACES
           
           
           DISPLAY "Enter new Stock quantity (empty to skip): "
           WITH NO ADVANCING
           ACCEPT I-PRODUCT-NAME

           IF I-PRODUCT-NAME = SPACES
               CONTINUE
           ELSE
               IF FUNCTION NUMVAL(I-PRODUCT-NAME) <= 0
                   PERFORM SHOW-VALIDATION-ERROR
                   IF USER-CANCELLED
                       PERFORM CLEAR-SCREEN
                       DISPLAY "                Cancelled."
                       PERFORM UPDATE-PRODUCT-MENU
                   END-IF
               ELSE
                   MOVE I-PRODUCT-NAME TO P-PRODUCT-NAME
               END-IF
           END-IF

           DISPLAY "Enter new Stock quantity (empty to skip): "
           WITH NO ADVANCING
           ACCEPT I-COST-PER-UNI

           IF I-COST-PER-UNI = SPACES
               CONTINUE
           ELSE
               IF FUNCTION NUMVAL(I-COST-PER-UNI) <= 0
                   PERFORM SHOW-VALIDATION-ERROR
                   IF USER-CANCELLED
                       PERFORM CLEAR-SCREEN
                       DISPLAY "                Cancelled."
                       PERFORM UPDATE-PRODUCT-MENU
                   END-IF
               ELSE
                   MOVE I-COST-PER-UNI TO P-COST-PER-UNIT
               END-IF
           END-IF
           
           DISPLAY "Enter new Stock quantity (empty to skip): "
           WITH NO ADVANCING
           ACCEPT I-UNIT-PRICE

           IF I-UNIT-PRICE = SPACES
               CONTINUE
           ELSE
               IF FUNCTION NUMVAL(I-UNIT-PRICE) <= 0
                   PERFORM SHOW-VALIDATION-ERROR
                   IF USER-CANCELLED
                       PERFORM CLEAR-SCREEN
                       DISPLAY "                Cancelled."
                       PERFORM UPDATE-PRODUCT-MENU
                   END-IF
               ELSE
                   MOVE I-UNIT-PRICE TO P-UNIT-PRICE
               END-IF
           END-IF
 
           DISPLAY "Enter new Stock quantity (empty to skip): "
           WITH NO ADVANCING
           ACCEPT I-STOCK

           IF I-STOCK = SPACES
               CONTINUE
           ELSE
               IF FUNCTION NUMVAL(I-STOCK) <= 0
                   PERFORM SHOW-VALIDATION-ERROR
                   IF USER-CANCELLED
                       PERFORM CLEAR-SCREEN
                       DISPLAY "                Cancelled."
                       PERFORM UPDATE-PRODUCT-MENU
                   END-IF
               ELSE
                   MOVE I-STOCK TO P-STOCK
               END-IF
           END-IF

           REWRITE P-PRODUCTS-RECORD
               INVALID KEY
                   DISPLAY "Error updating product!"
               NOT INVALID KEY
                   DISPLAY SPACES
                   PERFORM INITIALIZATION
                   DISPLAY "==============UPDATED DETAILS=============="
                   DISPLAY "Name               : " P-PRODUCT-NAME
                   DISPLAY "Cost Per Unit      : ₱" DF-PCOST-PER-UNIT
                   DISPLAY "Unit Price         : ₱" DF-PUNIT-PRICE
                   DISPLAY "Stock              : " DF-PSTOCK
                   DISPLAY "==========================================="
                   DISPLAY SPACES
           END-REWRITE
      *          ASKS WHETHER TO CONTINUE UPDATING PRODUCTS OR NOT
           DISPLAY "Update another products? (Y/N)"
           DISPLAY "Enter Choice: " WITH NO ADVANCING 
           ACCEPT CONTINUE-ANOTHER 

           IF CONTINUE-ANOTHER = 'Y' OR CONTINUE-ANOTHER = 'y'
                PERFORM CLEAR-SCREEN
                PERFORM UPDATE-PRODUCT-DETAILS
           ELSE 
               PERFORM CLEAR-SCREEN 
               PERFORM UPDATE-PRODUCT-MENU
           END-IF.

      *                     INCOME STATEMENT, RECORD SALE
       RECORD-SALES.
           PERFORM CLEAR-SCREEN
           PERFORM DISPLAY-DASHBOARD
           DISPLAY "=================================================="
           DISPLAY "                   RECORD SALES"
           DISPLAY "=================================================="

           PERFORM SELECT-PRODUCT.
           IF USER-CANCELLED
               PERFORM CLEAR-SCREEN
               DISPLAY "                   Cancelled."
               PERFORM MENU-MAIN
           END-IF

           PERFORM INITIALIZATION
           DISPLAY SPACE
           DISPLAY "Product ID         : " FUNCTION TRIM(P-PRODUCT-ID)
           DISPLAY "Product Name       : " P-PRODUCT-NAME
           DISPLAY "Available Stock    : " FUNCTION TRIM(DF-PSTOCK)
           DISPLAY "Unit Price         : ₱"                             - 
           FUNCTION TRIM(DF-PCOST-PER-UNIT)
           DISPLAY SPACE
           DISPLAY "Enter Sold Units: " WITH NO ADVANCING
           ACCEPT I-SOLD-UNITS

      *           CHECKS IF THE ENTERED SOLD-UNITS IS EMPTY
           IF I-SOLD-UNITS = SPACES OR I-SOLD-UNITS = ZERO OR           -
           I-SOLD-UNITS =" " 
                    PERFORM CLEAR-SCREEN
                    PERFORM SHOW-VALIDATION-ERROR
               IF USER-CANCELLED
                    PERFORM CLEAR-SCREEN
                    DISPLAY "                Cancelled."
                    PERFORM MENU-MAIN
               ELSE
                    PERFORM CLEAR-SCREEN
                    PERFORM RECORD-SALES
               END-IF
                    PERFORM RECORD-SALES
           ELSE

      *                    Check if sufficient stock
           IF I-SOLD-UNITS > P-STOCK
               PERFORM CLEAR-SCREEN
               DISPLAY "Insufficient stock! Available: " P-STOCK
               PERFORM RECORD-SALES
               DISPLAY SPACE
           END-IF

      *                        Calculate sales amounts
           COMPUTE CF-SALE-AMOUNT = I-SOLD-UNITS * P-UNIT-PRICE
           COMPUTE CF-COST-AMOUNT = I-SOLD-UNITS * P-COST-PER-UNIT
           COMPUTE CF-PROFIT-AMOUNT = CF-SALE-AMOUNT - CF-COST-AMOUNT

      *                         Update product stock
           COMPUTE P-STOCK = P-STOCK - I-SOLD-UNITS
           REWRITE P-PRODUCTS-RECORD

      *                        Build sales record
           MOVE P-PRODUCT-ID TO S-PRODUCT-ID
           MOVE P-PRODUCT-NAME TO S-PRODUCT-NAME
           MOVE I-SOLD-UNITS TO S-SOLD-UNITS
           MOVE P-UNIT-PRICE TO S-UNIT-PRICE
           MOVE CF-SALE-AMOUNT TO S-TOTAL-AMOUNT
           MOVE CF-COST-AMOUNT TO S-COST-OF-GOODS
           MOVE CF-PROFIT-AMOUNT TO S-PROFIT
           MOVE DATE-DISPLAY TO S-SALE-DATE

      *                        Append sales record
           CLOSE S-SALES-FILE
           OPEN EXTEND S-SALES-FILE
           WRITE SALES-RECORD
           IF NOT SALES-OK
               PERFORM CLEAR-SCREEN
               DISPLAY " Error recording sale! Status: " S-SALES-STATUS
               PERFORM RECORD-SALES
           ELSE
               DISPLAY "Sale recorded successfully!"
               MOVE CF-SALE-AMOUNT TO DF-DISP-AMOUNT
               DISPLAY "Total Sale Amount  : ₱ "                        -
               FUNCTION TRIM(DF-DISP-AMOUNT)
               MOVE CF-PROFIT-AMOUNT TO DF-DISP-AMOUNT
               DISPLAY "Profit             : ₱ "                        - 
               FUNCTION TRIM(DF-DISP-AMOUNT)
               DISPLAY "Remaining Stock    : "                          - 
               FUNCTION TRIM(DF-PSTOCK)
           END-IF
           CLOSE S-SALES-FILE

      *          ASKS WHETHER TO CONTINUE ENTERING SALES OR NOT
           DISPLAY "Enter another sale? (Y/N)"
           DISPLAY "Enter Choice: " WITH NO ADVANCING 
           ACCEPT CONTINUE-SALE 

            IF CONTINUE-SALE = 'Y' OR CONTINUE-SALE = 'y'
                PERFORM CLEAR-SCREEN
                PERFORM RECORD-SALES
            ELSE 
              CONTINUE
            END-IF.
            PERFORM CLEAR-SCREEN
           PERFORM MENU-MAIN.

       INCOME-STATEMENT.
           DISPLAY "=================================================="
           DISPLAY "                 INCOME STATEMENT"
           DISPLAY "=================================================="

           MOVE ZERO TO DT-TOTAL-REVENUE
           MOVE ZERO TO DT-TOTAL-PROFIT
           MOVE ZERO TO DT-TOTAL-QTY-SOLD

           OPEN INPUT S-SALES-FILE

           DISPLAY "SALES DETAILS:"
           DISPLAY "ID    NAME                  QTY           REVENUE"
           DISPLAY "      PROFIT"
           DISPLAY "--------------------------------------------------"

           PERFORM UNTIL SALES-EOF
               READ S-SALES-FILE
                   AT END
                       SET SALES-EOF TO TRUE
                   NOT AT END
                       ADD S-TOTAL-AMOUNT TO DT-TOTAL-REVENUE
                       ADD S-PROFIT TO DT-TOTAL-PROFIT
                       ADD S-SOLD-UNITS TO DT-TOTAL-QTY-SOLD

                       MOVE S-SOLD-UNITS TO DF-DISP-QTY
                       MOVE S-TOTAL-AMOUNT TO DF-DISP-AMOUNT
                       MOVE S-PROFIT TO DF-S-PROFIT
                       
                       DISPLAY S-PRODUCT-ID " "
                               S-PRODUCT-NAME(1:15) " " 
                               DF-DISP-QTY " " 
                               DF-DISP-AMOUNT
                       DISPLAY "      " "₱ " DF-S-PROFIT
               END-READ
           END-PERFORM

           DISPLAY "--------------------------------------------------"
           MOVE DT-TOTAL-QTY-SOLD TO DF-DISP-QTY
           DISPLAY "Total Quantity Sold: " DF-DISP-QTY

           MOVE DT-TOTAL-REVENUE TO DF-DISP-AMOUNT
           DISPLAY "Total Revenue: ₱" DF-DISP-AMOUNT

           MOVE DT-TOTAL-PROFIT TO DF-DISP-AMOUNT
           DISPLAY "Total Profit: ₱" DF-DISP-AMOUNT

           IF DT-TOTAL-REVENUE > ZERO
               COMPUTE DT-PROFIT-MARGIN =
                   (DT-TOTAL-PROFIT / DT-TOTAL-REVENUE) * 100
               MOVE DT-PROFIT-MARGIN TO DF-DISP-PERCENTAGE
               DISPLAY "Profit Margin: " DF-DISP-PERCENTAGE "%"
           END-IF
           CLOSE S-SALES-FILE.

           DISPLAY "=================================================="
           DISPLAY "9. Return"
           DISPLAY SPACE
           DISPLAY "Enter your choice: " WITH NO ADVANCING
           ACCEPT IS-CHOICE

           EVALUATE IS-CHOICE
               WHEN 9
                   PERFORM MENU-MAIN
               WHEN OTHER
                   PERFORM CLEAR-SCREEN
                   DISPLAY "                 Invalid option!"
                   PERFORM INCOME-STATEMENT
           END-EVALUATE.

      *      DISPLAY DASHBOARD - STOCK, INITIALIZATION, TERMINATION
       DISPLAY-DASHBOARD.
           PERFORM INITIALIZATION
           PERFORM CALCULATE-DASHBOARD
           
           DISPLAY "=================================================="
           DISPLAY "                DASHBOARD SUMMARY"
           DISPLAY "=================================================="
           
           MOVE DT-TOTAL-PRODUCTS TO DF-DISP-QTY
           DISPLAY "Total Products: " FUNCTION TRIM(DF-DISP-QTY)
           
           MOVE DT-TOTAL-STOCK TO DF-DISP-QTY
           DISPLAY "Total Stock Units: " FUNCTION TRIM(DF-DISP-QTY)
           
           MOVE DT-TOTAL-REVENUE TO DF-DISP-AMOUNT
           DISPLAY "Total Revenue: ₱ " FUNCTION TRIM(DF-DISP-AMOUNT)
           
           MOVE DT-TOTAL-PROFIT TO DF-DISP-AMOUNT
           DISPLAY "Total Profit: ₱ " FUNCTION TRIM(DF-DISP-AMOUNT)
           
           MOVE DT-TOTAL-QTY-SOLD TO DF-DISP-QTY
           DISPLAY "Total Units Sold: " FUNCTION TRIM(DF-DISP-QTY)
           
           IF DT-TOTAL-REVENUE > ZERO
               COMPUTE DT-PROFIT-MARGIN = 
                   (DT-TOTAL-PROFIT / DT-TOTAL-REVENUE) * 100
               MOVE DT-PROFIT-MARGIN TO DF-DISP-PERCENTAGE
               DISPLAY "Profit Margin: " DF-DISP-PERCENTAGE "%"
           END-IF.
           
       STOCK-DISPLAY.
           DISPLAY "=================================================="
           DISPLAY "               CURRENT STOCK LEVELS"
           DISPLAY "=================================================="
           DISPLAY "ID         NAME              STOCK     ADDED ON"
           DISPLAY "--------------------------------------------------"

           MOVE LOW-VALUES TO P-PRODUCT-ID
           START P-PRODUCTS-FILE KEY IS GREATER THAN P-PRODUCT-ID

           PERFORM UNTIL PRODUCTS-EOF OR P-PRODUCTS-STATUS NOT = "00"
               READ P-PRODUCTS-FILE NEXT RECORD
                   AT END 
                       SET PRODUCTS-EOF TO TRUE
                   NOT AT END
                       MOVE P-STOCK TO DF-DISP-QTY

                       MOVE P-DATE-ADDED(1:2) TO CD-MONTH
                       MOVE P-DATE-ADDED(3:2) TO CD-DAY
                       MOVE P-DATE-ADDED(5:4) TO CD-YEAR

                       DISPLAY 
                           P-PRODUCT-ID " "
                           P-PRODUCT-NAME(1:15) " "
                           DF-DISP-QTY "     "
                           CD-MONTH "/" CD-DAY "/" CD-YEAR
               END-READ
           END-PERFORM
           DISPLAY "--------------------------------------------------"
           DISPLAY SPACE.

       CALCULATE-DASHBOARD.
           MOVE ZERO TO DT-TOTAL-PRODUCTS
           MOVE ZERO TO DT-TOTAL-STOCK
           MOVE ZERO TO DT-TOTAL-REVENUE
           MOVE ZERO TO DT-TOTAL-PROFIT
           MOVE ZERO TO DT-TOTAL-QTY-SOLD
           
      *                        Calculate product totals
           MOVE LOW-VALUES TO P-PRODUCT-ID
           START P-PRODUCTS-FILE KEY IS GREATER THAN P-PRODUCT-ID
           PERFORM UNTIL PRODUCTS-EOF OR P-PRODUCTS-STATUS NOT = "00"
               READ P-PRODUCTS-FILE NEXT RECORD
                   AT END SET PRODUCTS-EOF TO TRUE
                   NOT AT END
                       ADD 1 TO DT-TOTAL-PRODUCTS
                       ADD P-STOCK TO DT-TOTAL-STOCK
               END-READ
           END-PERFORM
           
      *                        Calculate sales totals
           CLOSE S-SALES-FILE
           OPEN INPUT S-SALES-FILE
           PERFORM UNTIL SALES-EOF
               READ S-SALES-FILE
                   AT END SET SALES-EOF TO TRUE
                   NOT AT END
                       ADD S-TOTAL-AMOUNT TO DT-TOTAL-REVENUE
                       ADD S-PROFIT TO DT-TOTAL-PROFIT
                       ADD S-SOLD-UNITS TO DT-TOTAL-QTY-SOLD
               END-READ
           END-PERFORM
           CLOSE S-SALES-FILE.

       INITIALIZATION.
           MOVE P-COST-PER-UNIT TO DF-PCOST-PER-UNIT
           MOVE P-STOCK TO DF-PSTOCK
           MOVE P-UNIT-PRICE TO DF-PUNIT-PRICE

           ACCEPT CURRENT-DATE FROM DATE YYYYMMDD
           MOVE CURRENT-DATE(5:2) TO DATE-DISPLAY(1:2)
           MOVE "/" TO DATE-DISPLAY(3:1)
           MOVE CURRENT-DATE(7:2) TO DATE-DISPLAY(4:2)
           MOVE "/" TO DATE-DISPLAY(6:1)
           MOVE CURRENT-DATE(1:4) TO DATE-DISPLAY(7:4)
           
           OPEN I-O P-PRODUCTS-FILE
           IF NOT PRODUCTS-OK
               OPEN OUTPUT P-PRODUCTS-FILE
               CLOSE P-PRODUCTS-FILE
               OPEN I-O P-PRODUCTS-FILE
           END-IF
           
           OPEN INPUT S-SALES-FILE
           IF NOT SALES-OK
               OPEN OUTPUT S-SALES-FILE
               CLOSE S-SALES-FILE  
               OPEN INPUT S-SALES-FILE
           END-IF
           DISPLAY SPACE.

       SALES-RESET.
           PERFORM DISPLAY-DASHBOARD
           DISPLAY "Reset SALES Database? This can not be undone. (Y/N)" 
           DISPLAY "Enter Choice: " WITH NO ADVANCING
           ACCEPT RESET-SALES

           IF RESET-SALES = 'Y' OR RESET-SALES = 'y'
                  >>IF OS-TYPE EQUAL "WINDOWS"
                      CALL "SYSTEM" USING "del SALES.DAT"
                  >>ELSE
                      CALL "SYSTEM" USING "rm SALES.DAT"
                  >>END-IF
                   DISPLAY "Database have been reset sucessfully."
                   PERFORM MENU-MAIN
             ELSE 
               PERFORM MENU-MAIN
           END-IF. 

       PRODUCTS-RESET.
           PERFORM DISPLAY-DASHBOARD

           DISPLAY "Reset PRODUCTS Database? This can not be undone. "  -
           "(Y/N)"
           DISPLAY "Enter Choice: " WITH NO ADVANCING
           ACCEPT RESET-PRODUCTS

            IF RESET-PRODUCTS = 'Y' OR RESET-PRODUCTS = 'y'
                >>IF OS-TYPE EQUAL "WINDOWS"          
                    CALL "SYSTEM" USING "del PRODUCTS.DAT"
                >>ELSE
                    CALL "SYSTEM" USING "rm PRODUCTS.DAT"
                >>END-IF
                   DISPLAY "Database have been reset sucessfully."
                   PERFORM MENU-MAIN
               ELSE 
                   PERFORM MENU-MAIN
            END-IF. 
       
       GET-NUMERIC-INPUT.
           MOVE 'N' TO WS-IS-VALID
           PERFORM UNTIL VALID-INPUT OR USER-CANCELLED
               DISPLAY WS-FIELD-NAME ": " WITH NO ADVANCING
               ACCEPT WS-FIELD-VALUE

               IF WS-FIELD-VALUE = SPACES OR WS-FIELD-VALUE = ZERO
                   PERFORM SHOW-VALIDATION-ERROR
                   IF USER-CANCELLED EXIT PARAGRAPH END-IF
               ELSE
                   IF FUNCTION TEST-NUMVAL(WS-FIELD-VALUE) = 0
                      IF FUNCTION NUMVAL(WS-FIELD-VALUE) < 0
                           DISPLAY "Value cannot be negative."
                           PERFORM SHOW-VALIDATION-ERROR
                           IF USER-CANCELLED EXIT PARAGRAPH END-IF
                       ELSE
                           MOVE 'Y' TO WS-IS-VALID
                       END-IF

                   ELSE
                       DISPLAY "Invalid numeric value. Try again."
                       PERFORM SHOW-VALIDATION-ERROR
                       IF USER-CANCELLED EXIT PARAGRAPH END-IF
                   END-IF
               END-IF
           END-PERFORM.

       GET-TEXT-INPUT.
           MOVE 'N' TO WS-IS-VALID
           PERFORM UNTIL VALID-INPUT OR USER-CANCELLED
               DISPLAY WS-FIELD-NAME ": " WITH NO ADVANCING
               ACCEPT WS-FIELD-VALUE

               IF WS-FIELD-VALUE = SPACES
                   PERFORM SHOW-VALIDATION-ERROR
                   IF USER-CANCELLED
                       EXIT PARAGRAPH
                   END-IF
               ELSE
                   MOVE 'Y' TO WS-IS-VALID
               END-IF
           END-PERFORM.

       SHOW-VALIDATION-ERROR.
           DISPLAY SPACE
           DISPLAY "+ Invalid value entered for " WS-FIELD-NAME
           DISPLAY SPACE
           DISPLAY "+ Press 'N' to cancel or enter any to retry: "
           WITH NO ADVANCING
           ACCEPT WS-USER-CHOICE
           
           IF NOT USER-CANCELLED
               MOVE 'Y' TO WS-USER-CHOICE
           END-IF.

       SAVE-PRODUCT.
           MOVE I-PRODUCT-ID TO P-PRODUCT-ID
           MOVE I-PRODUCT-NAME TO P-PRODUCT-NAME
           MOVE I-COST-PER-UNI TO P-COST-PER-UNIT
           MOVE I-UNIT-PRICE TO P-UNIT-PRICE
           MOVE I-STOCK TO P-STOCK
           MOVE DATE-DISPLAY TO P-DATE-ADDED

           ACCEPT CURRENT-DATE FROM DATE YYYYMMDD
           MOVE CURRENT-DATE(5:2) TO DATE-DISPLAY(1:2)
           MOVE "/" TO DATE-DISPLAY(3:1)
           MOVE CURRENT-DATE(7:2) TO DATE-DISPLAY(4:2)
           MOVE "/" TO DATE-DISPLAY(6:1)
           MOVE CURRENT-DATE(1:4) TO DATE-DISPLAY(7:4)
           MOVE DATE-DISPLAY TO P-DATE-ADDED
           
           WRITE P-PRODUCTS-RECORD
               INVALID KEY
                   DISPLAY "Error adding product!"
               NOT INVALID KEY
                   DISPLAY "Product added successfully!"
                   DISPLAY "Product ID: " P-PRODUCT-ID
                   DISPLAY "Name: " P-PRODUCT-NAME
                   DISPLAY "Cost Per Unit: " DF-PCOST-PER-UNIT
                   DISPLAY "Unit Price: " DF-PUNIT-PRICE
                   DISPLAY "Stock: " P-STOCK
           END-WRITE.

       SELECT-PRODUCT.
           PERFORM STOCK-DISPLAY
           MOVE "Enter Product ID to select" TO WS-FIELD-NAME
           PERFORM GET-TEXT-INPUT

           MOVE WS-FIELD-VALUE TO P-PRODUCT-ID
           READ P-PRODUCTS-FILE
      *              CHECKS IF THE ENTERED PROD-ID IS EMPTY     
           INVALID KEY
                PERFORM SHOW-VALIDATION-ERROR
                IF USER-RETRY
                PERFORM SELECT-PRODUCT 
                END-IF
           END-READ.
 
       CLEAR-SCREEN.
           >>IF OS-TYPE EQUAL "WINDOWS"
               CALL "SYSTEM" USING "cls"
           >>ELSE
               CALL "SYSTEM" USING "clear"
           >>END-IF
           EXIT PARAGRAPH.

       PROG-TERMINATE.
           CLOSE P-PRODUCTS-FILE
           CLOSE S-SALES-FILE
           PERFORM CLEAR-SCREEN.
           DISPLAY SPACE.
           DISPLAY "          Files saved. System terminated."
           DISPLAY SPACE.
           STOP RUN.
           STOP RUN.
