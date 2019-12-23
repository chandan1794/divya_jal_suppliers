# Divya Jal Suppliers
A web app to maintain a small water kettle supplier business.

# App Structure
``` mermaid
graph LR
	login[Login] -- Fail --> login[Login]
	login[Login] -- Pass --> dashboard[Dashboard]
	
   dashboard[Dashboard] --> add_cust[Add New Customer]
   dashboard[Dashboard] --> add_req[Add a Request]
   dashboard[Dashboard] --> total_pending[Total Pending]
   dashboard[Dashboard] --> pending_req[Pending Requests]
   dashboard[Dashboard] --> view_all_customer[Ledger]
   dashboard[Dashboard] --> visuals[Visuals]

   add_cust[Add New Customer] --> add_cust_form[Name, Address, Phone Number, Email, bottles_per_day, price_per_bottle]
   
   add_req[Add a Request] --> add_req_form[customer_id, num_of_bottles, deliever_by]

   pending_req[Pending Requests] --> pending_requests_table[customer_name, num_of_bottles, deliever_by, delievery_address, phone_number]

  total_pending[Total Pending] --> total_pending_table[customer_name, pending_amount, last_collected_on]

   view_all_customer[Ledger] --> view_all_customer_table[customer_name, num_of_bottles, delievered_on, money_collected_on]

   view_all_customer_table --filterbyname--> view_single_customer_table[customer_name, num_of_bottles, delievered_on, money_collected_on]

   visuals --> stats[month_collected, profit, monthly_progress, bottles_delievered, total_customers]
```
> To compile this please install following extension https://chrome.google.com/webstore/detail/github-%20-mermaid/goiiopgdnkogdbjmncgedmgpoajilohe