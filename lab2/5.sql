SELECT id FROM manufacturer_table
WHERE EXISTS (SELECT country, masterr FROM factory_table
              WHERE country IN ('Colombia', 'Pakistan', 'Hungary')
              AND masterr = manufacturer_table.id);