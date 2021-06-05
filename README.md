# joebase_db_create

Creation scripts and some query scripts for the Joebase action figure database.

Creation scripts are ordered according to their prefix number. 

## Files
| Name | Description |
| ---- | ----------- |
| 0010-joebase-create-master.sql | Master creation script for `joebase`. This script runs all other creation scripts. |
| 0110-joebase-create-db.sql | Table creation script for `joebase` |
| 0120-joebase-create-views.sql | Creates common data views for `joebase` |
| 0130-joebase-create-users.sql | Creates users for `joebase`. |
| 0140-joebase-code-simple-read-write.sql | Creates basic `joebase` insert procedures and read functions. |
| 0210-joebase-manufacturer-initialize.sql | Initializes data for the manufacturer table. | 
| 0220-joebase-retailer-initialize.sql | Initializes data for the retailer table. | 
| 0230-joebase-genre-initialize.sql | Initializes data for the genre table. | 
| 0240-joebase-producttype-initialize.sql | Initializes data for the product_type table. | 
| 0250-joebase-series-initialize.sql | Initializes data for the series table. | 
| 0260-joebase-product-initialize.sql | Initializes data for the product table. | 
| README.md | This file. |
| all-action-figure-info.sql | Sample pull script |
