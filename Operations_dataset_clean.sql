# This dataset contains of 4 tables and it is used only for practicing purposes for cleaning raw data.
# There are no duplicates in this dataset
# Changed the naming of machine_id and machine_code so it is coresponding with numerical and text
# The my_operations table is not normalized as it contains the same information in columns machine_id and machine_code.
ALTER TABLE my_operations
RENAME COLUMN machine_id TO code
RENAME COLUMN machine_code TO machine_id
RENAME COLUMN code TO machine_code

# Remove unneccessary '$' in price column
UPDATE my_products
SET price = TRIM(LEADING '$' FROM price)

# Alter price column format from text to decimal
ALTER TABLE my_products
MODIFY price DECIMAL(10,2)

# Remove unnecessary '-' from subcategory column
UPDATE my_products
SET subcategory = TRIM(LEADING '-' FROM subcategory)

# Remove unnecessary 'NK#' from product_id column
UPDATE my_products
SET product_id = TRIM(LEADING '#NK' FROM product_id)

# Remove unnecessary '-' from the product_id
UPDATE my_products
SET product_id = TRIM(TRAILING '-' FROM product_id)

# Unify category names from plural to singular
UPDATE my_products
SET category = TRIM(TRAILING 's' FROM category)

# Unify first capital letter in the store column 
UPDATE my_sales
SET store = CONCAT(UPPER(LEFT(store,1)),LOWER(SUBSTRING(store,2)))

# Alter data type for revenue from text to decimal
ALTER TABLE my_sales
MODIFY revenue DECIMAL(10,2)

# Fill missing data in quantity column in my_sales table
UPDATE my_sales s
JOIN my_products p ON s.product_id = p.product_id
SET s.quantity = ROUND(s.revenue/p.price,0)

# Replacing '.' to'-' in date part
UPDATE my_shipping
SET shipping_end = CONCAT(REPLACE(LEFT(shipping_end,10),'.','-'),SUBSTRING(shipping_end,11))

# Omitting dot in between date and time information
UPDATE my_shipping
SET shipping_end = CONCAT(LEFT(shipping_end,10),RIGHT(shipping_end,5))

# Adding space between date and time part of the string
UPDATE my_shipping
SET shipping_end = INSERT(shipping_end,11,0,' ')

# Replacing '.' for ':' in time part of the string
UPDATE my_shipping
SET shipping_end = REPLACE(shipping_end,'.',':')

# Changing empty cells as 'null' for shipping_end
UPDATE my_shipping
SET shipping_end =
	CASE
		WHEN shipping_end = '' THEN NULL
        ELSE shipping_end
        END
        
# Changing empty cells as 'null' for shipping_start     
UPDATE my_shipping
SET shipping_start =
	CASE
		WHEN shipping_start = '' THEN NULL
        ELSE shipping_start
        END
# Add missing seconds value
UPDATE my_shipping
SET shipping_end = CONCAT(shipping_end,':00')

# Updating date into the correct format for mysql to the form 'YYYY-MM-DDD hh:mm:ss' to prepare for data type convertion
UPDATE my_shipping
SET shipping_end = DATE_FORMAT(STR_TO_DATE(shipping_end, '%m-%d-%Y %H:%i:%s'), '%Y-%m-%d %H:%i:%s');

# Altering table structure data type as Datetime for all 8 applicable columns within this table for future data
ALTER TABLE my_shipping
MODIFY COLUMN shipping_end DATETIME

# Filled the 'error' column missing fields based on null values in 'shipping_end' column
UPDATE my_shipping
SET error =
    CASE WHEN shipping_end IS NULL THEN 'True'
    ELSE 'False'
    END
